`timescale 1ns / 1ps
module create_sim;

	// Inputs
	reg clk;
	reg rst_sys;
	reg rst_map;
	reg [4:0] num;

	// Outputs
	wire [360:0] map;
	wire [4:0] actual_num;

	// Instantiate the Unit Under Test (UUT)
	create_map uut (
		.clk(clk), 
		.rst_sys(rst_sys), 
		.rst_map(rst_map), 
		.num(num), 
		.map(map), 
		.actual_num(actual_num)
	);
	
	always begin
		clk = 1; #1;
		clk = 0; #1;
	end
	
	initial begin
		// Initialize Inputs
		rst_sys = 0;
		rst_map = 0;

		// Wait 100 ns for global reset to finish
		#100;
		rst_sys = 1; #50;
		rst_sys = 0; #50;
		num = 19; #50;
		
		rst_map = 1;#50;
		rst_map = 0;#50;
				rst_map = 1;#50;
		rst_map = 0;#50;
				rst_map = 1;#50;
		rst_map = 0;#50;
				rst_map = 1;#50;
		rst_map = 0;#50;
						rst_map = 1;#50;
		rst_map = 0;#50;
						rst_map = 1;#50;
		rst_map = 0;#50;
						rst_map = 1;#50;
		rst_map = 0;#50;
        
		// Add stimulus here

	end
      
endmodule

