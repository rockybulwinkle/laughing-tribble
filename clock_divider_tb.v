`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   13:06:17 05/25/2014
// Design Name:   clock_divider
// Module Name:   C:/Users/rocky/FPGA Design/uart/clock_divider_tb.v
// Project Name:  uart
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: clock_divider
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module clock_divider_tb;

	// Inputs
	reg clk_in;

	// Outputs
	wire clk_out;

	// Instantiate the Unit Under Test (UUT)
	clock_divider #(12000000, 9600) uut (
		.clk_in(clk_in), 
		.clk_out(clk_out)
	);

	initial begin
		// Initialize Inputs
		clk_in = 0;

		// Wait 100 ns for global reset to finish
		#100;
        
		// Add stimulus here
		
	end
	
	always
		#41.667 clk_in = !clk_in;
      
endmodule

