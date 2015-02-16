`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:55:16 02/15/2015 
// Design Name: 
// Module Name:    reset 
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
module reset(
		input clk,
		output reset
    );


reg [15:0] counter;
initial begin
	counter = 0;
end

always @(posedge clk) begin
	counter <= (counter < 70) ? counter + 1 : counter;
end

assign reset = counter < 10;

endmodule
