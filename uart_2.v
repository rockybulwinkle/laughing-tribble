`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:21:03 05/25/2014 
// Design Name: 
// Module Name:    uart_2 
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
module uart_2(
		clk,
		tx_output,
		tx_ready,
		tx_sending,
		tx_input,
		tx_start,
		reset
    );
	parameter CLK_IN = 12000000;
	parameter BAUD_RATE = 115200;
	
	input clk;
	output tx_output;
	output reg tx_ready;
	output reg tx_sending;
	input [7:0] tx_input;
	input tx_start;
	input reset;

	
	wire tx_clock;
	clock_divider #(CLK_IN, BAUD_RATE) instance_name (
		.clk_in(clk),
		.clk_out(tx_clock)
	);
	
	reg [10:0] tx_full;
	
	assign tx_output = tx_full[0];
	
	reg [3:0] tx_count;
	
	reg tx_state;
	reg tx_next_state;
	
	always @ (posedge clk) begin
		case (tx_state)
			0: begin
					tx_full <= {1'b1, 1'b1, tx_input, 1'b0, 1'b1, 1'b1};
					tx_count <= 0;
					tx_ready <= 1;
					tx_sending <= 0;
				end
			1: begin
					tx_full <= tx_clock? tx_full >> 1 : tx_full;
					tx_count <= tx_clock? tx_count + 1 : tx_count;
					tx_ready <= 0;
					tx_sending <= 1;
				end
		endcase
	end
	
	always @ (posedge clk) begin
		tx_state <= reset? 0 : (tx_clock || (tx_next_state == 1'b0))? tx_next_state : tx_state;
	end
	
	always @ (*) begin
		case(tx_state)
			0: begin
					tx_next_state <= tx_start? 1'b1 : 1'b0;
				end
			1: begin
					tx_next_state <= (tx_count < 12) ? 1'b1 : 1'b0;
				end
		endcase
	end
	

endmodule
