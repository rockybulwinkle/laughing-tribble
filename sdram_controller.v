`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    12:16:04 02/14/2015 
// Design Name: 
// Module Name:    sdram_controller 
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
module sdram_controller(
		input clk, reset,
		output reg clk_e,
		output reg cs, ras, cas, we,
		output dml, dmh,
		output reg [1:0] bs,
		output reg [12:0] addr_sd,
		input [15:0] data_sd,
		
		input [21:0] addr_usr,
		output reg [15:0] data_out_usr,
		output reg data_rdy,
		input do_command
    );
	assign dml = 0;
	assign dmh = 0;
	 
	parameter RESET=0;
	parameter SET_MODEREG_1 = 1;
	parameter SET_MODEREG_2 = 2;
	parameter IDLE = 3;
	parameter ACTIVATE = 4;
	parameter READ_AUTO_PC_1 = 5;
	parameter READ_AUTO_PC_2 = 6;
	parameter READ_AUTO_PC_3 = 7;
	parameter AUTO_PRECHARGE = 8;
	parameter IDLE2 = 9;
	parameter PRECHARGE = 10;

	 
	 reg [15:0] state;
	 	 reg [21:0] addr_latch;
		 
	initial begin 
		state <= RESET;
		addr_latch <= 0;
		data_out_usr <= 0;
	end

	 always @ (posedge clk or posedge reset) begin
	 
		if (reset) begin
			state <= RESET;
		end else begin
			case(state)
				RESET: state <= SET_MODEREG_1;
				SET_MODEREG_1: state <= SET_MODEREG_2;
				SET_MODEREG_2: state <= PRECHARGE;
				ACTIVATE: begin 
					state <= READ_AUTO_PC_1;
				end
				READ_AUTO_PC_1: state <= READ_AUTO_PC_2; 
				READ_AUTO_PC_2: state <= READ_AUTO_PC_3; 
				READ_AUTO_PC_3: begin 
					state <= AUTO_PRECHARGE;
					data_out_usr <= data_sd;
				end//data is ready
				AUTO_PRECHARGE: state <= IDLE; //precharging
				IDLE: begin 
					state <= do_command ? IDLE2: IDLE; // start again
					addr_latch <= addr_usr;
				end
				IDLE2: state <= do_command ? IDLE2: ACTIVATE; // start again
				
				PRECHARGE: state <= IDLE;
				
			default: state <= RESET;
			endcase
		end
	 end
	 
	 
	 always @ (state or addr_latch) begin
		case (state)
			RESET:
				begin
					cs <= 0;
					ras <= 0;
					cas <= 1;
					we <= 0;
					addr_sd[10] <= 0;
					addr_sd[9:0] <= 0;
					addr_sd[12:11] <= 0;
					bs <= 2'b0;
					clk_e <= 1;
					data_rdy <= 0;
				end
			SET_MODEREG_1: 
				begin
					cs <= 0;
					ras <= 0;
					cas <= 0;
					we <= 0;
					addr_sd <= {3'b0, 1'b0, 1'b0, 1'b0, 3'b010, 1'b0, 3'b0}; //cas latency = 2
					bs <= 2'b0;
					clk_e <= 1;
					data_rdy <= 0;
				end
			SET_MODEREG_2: 
				begin
					cs <= 0;
					// don't care about below things, just leave them as is because lazy
					ras <= 1;
					cas <= 1;
					we <= 1;
					addr_sd <= {3'b0, 1'b0, 1'b0, 1'b0, 3'b010, 1'b0, 3'b0}; //cas latency = 2
					bs <= 2'b0;
					clk_e <= 1;
					data_rdy <= 0;
				end
			ACTIVATE:
				begin
					cs <= 0;
					ras <= 0;
					cas <= 1;
					we <= 1;
					addr_sd[12:0] <= addr_latch[21:9];
					addr_latch <= addr_latch;
					bs <= 2'b0;
					clk_e <= 1;
					data_rdy <= 0;
				end
			READ_AUTO_PC_1:
				begin
					cs <= 0;
					ras <= 1;
					cas <= 0;
					we <= 1;
					addr_sd[8:0] <= addr_latch[8:0];
					addr_sd[10] <= 1;
					addr_sd[9] <= 0;
					addr_sd[12:11] <= 0;
					bs <= 2'b0;
					clk_e <= 1;
					data_rdy <= 0;
				end
			READ_AUTO_PC_2:
				begin
					cs <= 1;
					ras <= 1;
					cas <= 1;
					we <= 1;
					addr_sd[8:0] <= addr_latch[8:0];
					addr_sd[10] <= 1;
					addr_sd[9] <= 0;
					addr_sd[12:11] <= 0;
					bs <= 2'b0;
					clk_e <= 1;
					data_rdy <= 0;
				end
			READ_AUTO_PC_3:
				begin
					cs <= 1;
					ras <= 1;
					cas <= 1;
					we <= 1;
					addr_sd[8:0] <= addr_latch[8:0];
					addr_sd[10] <= 1;
					addr_sd[9] <= 0;
					addr_sd[12:11] <= 0;
					bs <= 2'b0;
					clk_e <= 1;
					data_rdy <= 0;
					addr_sd[9] <= 0;
					addr_sd[12:10] <= 0;
				end
			AUTO_PRECHARGE:
				begin
					cs <= 0;
					ras <= 1;
					cas <= 1;
					we <= 1;
					addr_sd[8:0] <= addr_latch[8:0];
					addr_sd[10] <= 1;
					addr_sd[9] <= 0;
					addr_sd[12:11] <= 0;
					bs <= 2'b0;
					clk_e <= 1;
					data_rdy <= 1;
				end
			IDLE:
				begin
					cs <= 0;
					ras <= 1;
					cas <= 1;
					we <= 1;
					addr_sd[8:0] <= addr_latch[8:0];
					addr_sd[10] <= 1;
					addr_sd[9] <= 0;
					addr_sd[12:11] <= 0;
					bs <= 2'b0;
					clk_e <= 1;
					data_rdy <= 1;
				end
			IDLE2: //waiting for uart to latch in data
				begin
					cs <= 0;
					ras <= 1;
					cas <= 1;
					we <= 1;
					addr_sd[8:0] <= addr_latch[8:0];
					addr_sd[10] <= 1;
					addr_sd[9] <= 0;
					addr_sd[12:11] <= 0;
					bs <= 2'b0;
					clk_e <= 1;
					data_rdy <= 1;
				end
			PRECHARGE:
				begin
					cs <= 0;
					ras <= 0;
					cas <= 1;
					we <= 0;
					addr_sd[10] <= 1;
					addr_sd[9:0] <= 0;
					addr_sd[12:11] <= 0;
					bs <= 0;
					clk_e <= 1;
					data_rdy <= 0;
				end
			default:
				begin
					cs <= 1'bx;
					ras <= 1'bx;
					cas <= 1'bx;
					we <= 1'bx;
					addr_sd <= 13'bxxxxxxxxxxxxx;
					bs <= 2'bxx;
					clk_e <= 1'bx;
					data_rdy <= 1'b0;
				end
		endcase
	 end
	 


endmodule
