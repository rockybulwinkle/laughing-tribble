`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   14:02:10 02/15/2015
// Design Name:   uart_tlm
// Module Name:   C:/Users/rocky/FPGA Design/uart/tlm_tb.v
// Project Name:  uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart_tlm
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module tlm_tb;

	// Inputs
	reg fpgaClk_i;
	reg clk_fb;

	// Outputs
	wire [2:0] chan_io;
	wire clk_en;
	wire sd_clk;
	wire cs;
	wire we;
	wire ras;
	wire cas;
	wire dml;
	wire dmh;
	wire [1:0] bs;
	wire [12:0] sdAddr_o;
	
	//inouts
	wire [15:0] sdData_io;

	// Instantiate the Unit Under Test (UUT)
	uart_tlm uut (
		.fpgaClk_i(fpgaClk_i), 
		.chan_io(chan_io), 
		.clk_en(clk_en), 
		.sd_clk(sd_clk), 
		.clk_fb(clk_fb), 
		.cs(cs), 
		.we(we), 
		.ras(ras), 
		.cas(cas), 
		.dml(dml), 
		.dmh(dmh), 
		.bs(bs), 
		.sdAddr_o(sdAddr_o), 
		.sdData_io(sdData_io)
	);

mt48lc16m16a2 instance_name (
    .Dq(sdData_io), 
    .Addr(sdAddr_o), 
    .Ba(bs), 
    .Clk(fpgaClk_i), 
    .Cke(clk_en), 
    .Cs_n(cs), 
    .Ras_n(ras), 
    .Cas_n(cas), 
    .We_n(we), 
    .Dqm({dml, dmh})
    );



	initial begin
		// Initialize Inputs
		fpgaClk_i = 0;
		clk_fb = 0;
		// Add stimulus here

	end
	
	always #41 fpgaClk_i = ~fpgaClk_i;
      
endmodule

