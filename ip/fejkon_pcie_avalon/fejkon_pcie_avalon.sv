`timescale 1 ps / 1 ps
module fejkon_pcie_avalon (
    output wire [127:0] mem_access_resp_data,  // mem_access_resp.data
    input  wire         mem_access_resp_ready, //                .ready
    output wire         mem_access_resp_valid, //                .valid
    input  wire [127:0] mem_access_req_data,   //  mem_access_req.data
    output wire         mem_access_req_ready,  //                .ready
    input  wire         mem_access_req_valid,  //                .valid
    output wire [31:0]  mm_address,            //              mm.address
    output wire [3:0]   mm_byteenable,         //                .byteenable
    output wire         mm_read,               //                .read
    input  wire [31:0]  mm_readdata,           //                .readdata
    input  wire         mm_readdatavalid,      //                .readdatavalid
    output wire         mm_write,              //                .write
    input  wire         mm_waitrequest,        //                .waitrequest
    output wire [31:0]  mm_writedata,          //                .writedata
    input  wire         mm_writeresponsevalid, //                .writeresponsevalid
    input  wire [1:0]   mm_response,           //                .response
    input  wire         reset,                 //           reset.reset
    input  wire         clk                    //             clk.clk
  );

  // 64-bit address is available, but we only implement 32 bit addressing
  logic [31:0] mem_access_req_address;
  assign mem_access_req_address = {mem_access_req_data[62:33], 2'b0};

  logic        compl_valid = 0;
  logic [15:0] compl_requester_id = 0;
  logic [7:0]  compl_tag = 0;
  logic [31:0] compl_data = 0;
  logic [6:0]  compl_lower_address = 0;

  logic [31:0] m_address = 0;
  logic        m_read = 0;
  logic        m_write = 0;
  logic [31:0] m_writedata = 0;
  logic        m_busy = 0;

  always @(posedge clk) begin
    // Read finished
    if (mm_readdatavalid) begin
      compl_valid <= 1'b1;
      compl_data <= mm_readdata;
      m_busy <= 1'b0;
    end else begin
      compl_valid <= 1'b0;
    end
    // New read starting
    if (mem_access_req_valid && ~m_busy && ~m_write) begin
      if (mem_access_req_data[0]) begin
        m_write <= 1'b1;
        m_address <= mem_access_req_address;
        m_writedata <= mem_access_req_data[32:1];
      end else begin
        // Read
        m_busy <= 1'b1;
        m_read <= 1'b1;
        m_address <= mem_access_req_address;
        compl_requester_id <= mem_access_req_data[16:1];
        compl_tag <= mem_access_req_data[24:17];
        compl_lower_address <= mem_access_req_address[6:0];
      end
    end else begin
      if (~mm_waitrequest) begin
        m_write <= 1'b0;
        m_read  <= 1'b0;
      end
    end
  end

  assign mem_access_resp_valid = compl_valid;
  assign mem_access_resp_data = {64'b0, compl_data, 3'b0, compl_lower_address[6:2], compl_tag, compl_requester_id};
  assign mem_access_req_ready = ~m_busy && ~m_write;

  assign mm_address = m_address;
  assign mm_byteenable = 4'b1111;
  assign mm_read = m_read;
  assign mm_write = m_write;
  assign mm_writedata = m_writedata;

endmodule
