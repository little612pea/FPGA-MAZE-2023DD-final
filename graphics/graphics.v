`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:18:17 12/13/2023 
// Design Name: 
// Module Name:    graphics 
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
module graphics(
			input clk,
			input rst,
			// VGA
			output HSYNC, 
			output VSYNC,
			output [3:0]Red,
			output [3:0]Green,
			output [3:0]Blue,
			
			input [4:0] num,
			input [1:0] mode,
			input [360:0] map,
			input [8:0] current_x_index,
			input [8:0] current_y_index
    );
	 wire [11:0] pix_data;
	 wire [9:0] x;
	 wire [8:0] y;
	 wire clk_div;
	 
	 // clk divider
	 clkdiv_25mhz clk_div_25mhz(
		.clk(clk), 
		.rst(1'b0), 
		.clk_div(clk_div)
		);
		
	// vga driver
	 vgac vga_ctrl(
		.d_in(pix_data),           //bbbb_gggg_rrrr,pixel
		.vga_clk(clk_div),               //25MHz
		.rst(rst),
		.row_addr(y),   //pixel ram row address,480(512)lines
		.col_addr(x),    //pixel ram col address,640(1024)pixels
		.r(Red),
		.g(Green),
		.b(Blue),
		.rdn(),             //read pixel RAM
		.hs(HSYNC),            //horizontal and vertical synchronization
		.vs(VSYNC)
		);	

	// draw
	 draw draw(
		.clk(clk),
		.rst(rst), 
		.x(x), 
		.y(y), 
		.num(num),
		.mode(mode),
		.map(map), 
		.current_x_index(current_x_index),
		.current_y_index(current_y_index),
		.pix_data(pix_data),
		.pix_x_index(),
		.pix_y_index()
		);
		


endmodule
