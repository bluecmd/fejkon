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

  always @(posedge clk) begin
    compl_valid <= 1'b0;
    if (mem_access_req_valid) begin
      if (mem_access_req_data[0]) begin
        // No write support
      end else begin
        // Read
        compl_valid <= 1'b1;
        compl_requester_id <= mem_access_req_data[16:1];
        compl_tag <= mem_access_req_data[24:17];
        compl_lower_address <= mem_access_req_address[6:0];
        case (mem_access_req_address)
          32'h0: compl_data <= 32'h02010de5;
          32'h4: compl_data <= 32'hdeadbeef;
          default: compl_data <= ~32'h0;
        endcase
      end
    end
  end

  assign mem_access_resp_valid = compl_valid;
  assign mem_access_resp_data = {64'b0, compl_data, 3'b0, compl_lower_address[6:2], compl_tag, compl_requester_id};
  assign mem_access_req_ready = 1'b1;

  assign mm_address = 32'b0;
  assign mm_byteenable = 4'b0000;
  assign mm_read = 1'b0;
  assign mm_write = 1'b0;
  assign mm_writedata = 32'b0;

endmodule
