`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:49:06 05/25/2014 
// Design Name: 
// Module Name:    clock_divider 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Clock divider. Use as an enable for assigning your next_state to avoid gated clocks.
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////


module clock_divider(
		clk_in,
		clk_out
		);
	function integer log2;
	input integer value;
	begin
		value = value-1;
		for (log2=0; value>0; log2=log2+1)
			value = value>>1;
		end
	endfunction

		
	parameter CLK_IN  = 12000000;
	parameter CLK_OUT = 6000000;
	
	localparam CLK_DIV = CLK_IN/CLK_OUT;
	localparam WIDTH = log2(CLK_DIV);
	
	input clk_in;
	output reg clk_out;
	
	reg [WIDTH-1:0] count;
	
	initial begin
		count <= 0;
	end
	
	always @ (posedge clk_in) begin
		count <= count >= CLK_DIV ? 0 : count + 1;
		clk_out <= count == 0;
	end
	
endmodule
