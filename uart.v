`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    01:51:52 05/25/2014 
// Design Name: 
// Module Name:    uart 
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
module uart(
		clk,
		tx_start,
		tx_ready,
		tx_byte,
		tx_sending,
		tx_output
    );

input clk;
input tx_start;
input [7:0] tx_byte;
output reg tx_ready;
output reg tx_sending;
output tx_output;

reg [7:0] tx_data;
wire [10:0] tx_full;
reg [1:0] tx_state;
reg [1:0] tx_next_state;
reg [3:0] tx_output_byte_index;

initial begin
	tx_ready <= 1;
	tx_state <= 0;
	tx_sending <= 0;
	tx_next_state <= 0;
	tx_output_byte_index <= 0;
	tx_data <= 0;
end

assign tx_full = {1'b1, tx_data[7:0], 1'b0, 1'b1};
assign tx_output = tx_full[tx_output_byte_index];

always @(posedge clk) begin
	case (tx_state)
		0: tx_next_state <= tx_start? 2'd1 : 2'd0;
		1: tx_next_state <= 2'd2;
		2: tx_next_state <= tx_output_byte_index > 14? 2'd0 : 2'd2;
		3: tx_next_state <= 3'd3;
	endcase
end

always @ (posedge clk) begin
	tx_state <= tx_next_state;
end

always @ (posedge clk) begin
	case (tx_state)
		2: tx_output_byte_index <= tx_output_byte_index+1;
		default: tx_output_byte_index <= 0;
	endcase
end

always @(*) begin
	case (tx_state)
		0: begin
				tx_ready <= 1;
				tx_sending <= 0;
				tx_data <= 8'd255;
			end
		1: begin
				tx_ready <= 0;
				tx_data <= tx_byte;
				tx_sending <= 1;
			end
		2: begin
				tx_ready <= 0;
				tx_data <= tx_data;
				tx_sending <= 1;
			end
		3: begin
				tx_ready <= 0;
				tx_sending <= 0;
				tx_data <= 8'd0;
			end
	endcase
end

endmodule


















