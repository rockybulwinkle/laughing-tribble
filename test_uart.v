`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   11:09:13 05/25/2014
// Design Name:   uart
// Module Name:   C:/Users/rocky/FPGA Design/uart/test_uart.v
// Project Name:  uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: uart
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module test_uart;

	// Inputs
	reg tx_clk;
	reg tx_start;
	reg [7:0] tx_byte;

	// Outputs
	wire tx_ready;
	wire tx_sending;
	wire tx_output;

	// Instantiate the Unit Under Test (UUT)
	uart uut (
		.tx_clk(tx_clk), 
		.tx_start(tx_start), 
		.tx_ready(tx_ready), 
		.tx_byte(tx_byte), 
		.tx_sending(tx_sending), 
		.tx_output(tx_output)
	);

	initial begin
		// Initialize Inputs
		tx_clk = 0;
		tx_start = 0;
		tx_byte = 0;

		// Wait 100 ns for global reset to finish
		#100;
		tx_byte = 8'b10111110;
		tx_start = 1;
		// Add stimulus here

	end
      
endmodule

