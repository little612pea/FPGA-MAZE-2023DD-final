`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:42:41 10/30/2023 
// Design Name: 
// Module Name:    clkdiv 
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
//rtl
module clkdiv_2hz
    (
    input rst,
    input clk,
    output reg clk_div
    );
    reg [31:0] cnt;
	always @(posedge clk or posedge rst)begin
		if(rst) begin
			cnt <= 32'b0;
			clk_div <= 1'b0;
		end
		else if(cnt == 32'd25000000)begin
			clk_div <= ~clk_div;
			cnt <= 32'b0;
		end
		else begin
			cnt <= cnt + 32'b1;
		end
	end
endmodule