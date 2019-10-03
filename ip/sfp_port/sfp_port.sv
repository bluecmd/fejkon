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

  reg [7:0] rd_data;
  reg [1:0] rd_response;

  reg [1:0] wr_response;

  reg       tx_disable_r;
  reg [1:0] ratesel_r;

  // Reader
  always @(posedge clk or posedge reset)
    begin
      if (reset)
        begin
          rd_data <= 8'b0;
          rd_response <= 2'b10;
        end
      else if (mm_read)
        begin
          // Status register
          // TODO(bluecmd): Seems to be some delay here where state
          // transitions lag one clock cycle, probably due to Avalon needing
          // the data the same clock cycle or something?
          if (mm_address == 4'h0)
            begin
              rd_data <= {2'b00, ratesel, tx_disable_r, tx_fault, los, ~mod0_prsnt_n};
              rd_response <= 2'b00;
            end
          else
            rd_response <= 2'b11;
        end
    end

  // Writer
  always @(posedge clk or posedge reset)
  begin
    if (reset)
      begin
        wr_response <= 2'b10;
      end
    else if (mm_write)
      begin
        // Status register
        if (mm_address == 4'h0)
          begin
            tx_disable_r <= mm_writedata[3];
            ratesel_r <= mm_writedata[5:4];
            wr_response <= 2'b00;
          end
        else
          wr_response <= 2'b11;
      end
  end

  assign ratesel = ratesel_r;
  assign tx_disable = tx_disable_r;

  assign mm_response = mm_read ? rd_response : wr_response ;
  assign mm_readdata = rd_data;


  // Altera I2C master bus driver
  assign scl_in = mod1_scl;
  assign sda_in = mod2_sda;
  assign mod1_scl = scl_oe ? 1'b0 : 1'bz;
  assign mod2_sda = sda_oe ? 1'b0 : 1'bz;

endmodule
