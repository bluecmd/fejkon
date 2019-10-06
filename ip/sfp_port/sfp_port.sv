//
// I/O module to handle signals from SFP(+) ports
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Affero General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Affero General Public License for more details.
//
// You should have received a copy of the GNU Affero General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.

`timescale 1 ps / 1 ps
module sfp_port (
    input  wire       clk,              //   clk.clk
    input  wire       reset,            // reset.reset
    output wire       i2c_reset,        // i2c_reset.reset
    input  wire       los,              //   sfp.los
    input  wire       mod0_prsnt_n,     //      .prsnt_n
    output wire       tx_disable,       //      .txdis
    inout  tri1       mod1_scl,         //      .scl
    inout  tri1       mod2_sda,         //      .sda
    output wire [1:0] ratesel,          //      .ratesel
    input  wire       tx_fault,         //      .txfail
    input  wire [3:0] mm_address,       //    mm.address
    input  wire       mm_read,          //      .read
    output wire [7:0] mm_readdata,      //      .readdata
    input  wire       mm_write,         //      .write
    input  wire [7:0] mm_writedata,     //      .writedata
    output wire [1:0] mm_response,      //      .response

    // Altera I2C master bus driver
    output wire sda_in,
    input  wire sda_oe,
    output wire scl_in,
    input  wire scl_oe
  );

  wire [7:0] rd_data;
  wire [1:0] rd_response;

  wire [1:0] wr_response;

  reg       tx_disable_r;
  reg [1:0] ratesel_r;
  reg       i2c_reset_r;
  reg       mod0_prsnt_n_r;

  // Reader
  assign rd_data = {1'b0, i2c_reset_r, ratesel, tx_disable_r, tx_fault, los, ~mod0_prsnt_n};
  assign rd_response = mm_address == 4'h0 ? 2'b00 : 2'b11;

  // Writer
  always @(posedge clk or posedge reset)
  begin
    if (reset)
      begin
        tx_disable_r <= 1;
        ratesel_r <= 2'b00;
        i2c_reset_r <= 0;
      end
    else if (mm_write)
      begin
        // Status register
        if (mm_address == 4'h0)
          begin
            tx_disable_r <= mm_writedata[3];
            ratesel_r <= mm_writedata[5:4];
            i2c_reset_r <= mm_writedata[6];
          end
      end
    else
    begin
      // Only reset for one clock cycle
      i2c_reset_r <= 0;
    end
  end

  always @(posedge clk)
  begin
    mod0_prsnt_n_r <= mod0_prsnt_n;
  end

  assign wr_response = mm_address == 4'h0 ? 2'b00 : 2'b11;

  assign ratesel = ratesel_r;
  assign tx_disable = tx_disable_r;

  assign mm_response = mm_read ? rd_response : wr_response ;
  assign mm_readdata = rd_data;

  // Reset the I2C core when:
  // - the host tells us to (i2c_reset_r)
  // - the system is being reset (rest)
  // - a SFP module was just plugged in (mod0_prsnt_n 1->0)
  assign i2c_reset = i2c_reset_r | reset | (~mod0_prsnt_n & mod0_prsnt_n_r);

  // Altera I2C master bus driver
  assign scl_in = mod1_scl;
  assign sda_in = mod2_sda;
  assign mod1_scl = scl_oe ? 1'b0 : 1'bz;
  assign mod2_sda = sda_oe ? 1'b0 : 1'bz;

endmodule
