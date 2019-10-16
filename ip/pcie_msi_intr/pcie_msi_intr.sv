`timescale 1 ps / 1 ps
module pcie_msi_intr #(
		parameter AUTO_INT_CARD_INTERRUPTS_USED             = "-1",
		parameter AUTO_INT_PORT0_SFP_I2C_INTERRUPTS_USED    = "-1",
		parameter AUTO_INT_PORT0_SFP_STATUS_INTERRUPTS_USED = "-1"
	) (
		output wire       app_int_sts,              //              int_msi.app_int_sts
		output wire [4:0] app_msi_num,              //                     .app_msi_num
		output wire       app_msi_req,              //                     .app_msi_req
		output wire [2:0] app_msi_tc,               //                     .app_msi_tc
		input  wire       app_int_ack,              //                     .app_int_ack
		input  wire       app_msi_ack,              //                     .app_msi_ack
		input  wire       clk,                      //                  clk.clk
		input  wire       reset,                    //                reset.reset
		input  wire       int0,                     //             int_card.irq
		input  wire       int_port0_sfp_i2c,        //    int_port0_sfp_i2c.irq
		input  wire       int_port0_sfp_status_irq  // int_port0_sfp_status.irq
	);

	// TODO: Auto-generated HDL template

	assign app_msi_req = 1'b0;

	assign app_msi_tc = 3'b000;

	assign app_int_sts = 1'b0;

	assign app_msi_num = 5'b00000;

endmodule
