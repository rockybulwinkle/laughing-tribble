`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:21:44 05/25/2014 
// Design Name: 
// Module Name:    uart_tlm 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////

module uart_tlm(
		fpgaClk_i,
		chan_io,
		clk_en,
		sd_clk,
		clk_fb,
		cs,
		we,
		ras,
		cas,
		dml,
		dmh,
		bs,
		sdAddr_o,
		sdData_io
    );
input fpgaClk_i;
output [2:0] chan_io;

output clk_en; //clock enable
output sd_clk; //clock

input clk_fb; //clock feedback... ?
output cs;
output we;
output ras;
output cas;
output dml;
output dmh;
output [1:0] bs; //bank select;
output [12:0] sdAddr_o; //address
input [15:0] sdData_io; // data

wire clk;
parameter FPGA_CLK_RATE=12000000;
//assign clk = fpgaClk_i;

wire [15:0] data_out_usr;
wire data_rdy;
wire tx_ready;
reg [21:0] addr_usr;
assign sd_clk = fpgaClk_i;

wire reset;

sdram_controller sdram_cont (
    .clk(fpgaClk_i), 
    .reset(reset), 
    .clk_e(clk_en), 
    .cs(cs), 
    .ras(ras), 
    .cas(cas), 
    .we(we), 
    .dml(dml), 
    .dmh(dmh), 
    .bs(bs), 
    .addr_sd(sdAddr_o), 
    .data_sd(sdData_io), 
    .addr_usr(addr_usr), 
    .data_out_usr(data_out_usr),
    .data_rdy(data_rdy),
	 .do_command(tx_ready)
    );

always @ (posedge tx_ready or posedge reset) begin
	addr_usr <= reset ? 1024 : addr_usr ==2048 ? 1024  : addr_usr + 1;
end	

assign chan_io[1] = tx_ready;

uart_2 #(FPGA_CLK_RATE, 300) uart_1 (
    .clk(fpgaClk_i), 
    .tx_output(chan_io[0]), 
    .tx_ready(tx_ready), 
    .tx_sending(chan_io[2]), 
    .tx_input(data_out_usr[7:0]),
    .tx_start(data_rdy),
    .reset(reset)
    );

reset instance_name (
    .clk(fpgaClk_i), 
    .reset(reset)
    );

endmodule
