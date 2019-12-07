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

  // TODO: Auto-generated HDL template

  assign mem_access_resp_valid = 1'b0;

  assign mem_access_resp_data = 128'b0;

  assign mem_access_req_ready = 1'b0;

  assign mm_address = 32'b0;

  assign mm_byteenable = 4'b0000;

  assign mm_read = 1'b0;

  assign mm_write = 1'b0;

  assign mm_writedata = 32'b0;

endmodule
