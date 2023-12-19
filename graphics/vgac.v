`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:17:12 12/17/2023 
// Design Name: 
// Module Name:    vgac 
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
module vgac(vga_clk,rst,d_in,row_addr,col_addr,rdn,r,g,b,hs,vs);
input [11:0] d_in;           //bbbb_gggg_rrrr,pixel
input vga_clk;               //25MHz
input rst;
output reg[8:0] row_addr;    //pixel ram row address,480(512)lines
output reg[9:0] col_addr;    //pixel ram col address,640(1024)pixels
output reg[3:0]r,g,b;        //red,green,blue colors
output reg rdn;              //read pixel RAM
output reg hs,vs;            //horizontal and vertical synchronization

reg[9:0] h_count;            //VGA horizontal counter (0-799):pixels
always @(posedge vga_clk)begin
    if(rst)begin
	 h_count <= 10'h0;
	 end else if(h_count == 10'd799)begin
	 h_count <= 10'h0;
	 end else begin
	 h_count <= h_count + 10'h1;
	 end
end
//v_count:VGA vertical counter(0-524)
reg[9:0] v_count;//VGA vertical counter(0-524):lines
always @(posedge vga_clk or posedge rst)begin
    if(rst)begin
	     v_count <= 10'h0;
	 end else if(h_count == 10'd799)begin
	     if(v_count == 10'd524)begin
		     v_count <= 10'h0;
		  end else begin
		      v_count <= v_count +10'h1;
		  end
	 end
end
//signals,will be latched for outputs

wire [9:0] row = v_count-10'd35;
wire [9:0] col = h_count-10'd143;
wire h_sync = (h_count > 10'd95);
wire v_sync = (v_count > 10'd1);
wire read = (h_count > 10'd142)&&
            (h_count < 10'd783)&&
				(v_count > 10'd34) &&
				(v_count < 10'd515);
//vga signals
always @(posedge vga_clk)begin
    row_addr <= row[8:0];
	 col_addr <= col;
	 rdn <= ~read;
	 hs <= h_sync;
	 vs <= v_sync;
	 r <= rdn? 4'h0:d_in[3:0];
	 g <= rdn? 4'h0:d_in[7:4];
	 b <= rdn? 4'h0:d_in[11:8];
end
endmodule
