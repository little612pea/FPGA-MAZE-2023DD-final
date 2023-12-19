// PS2模块定义
//in top module PS2 definition should be as follows:
/*PS2 ps2_unit(
    .clk(clk), .rst(hard_reset),           
	.ps2_clk(PS2_clk), .ps2_data(PS2_data),
    .up(up), .left(left), .right(right), .down(down), .enter(enter),
    digit_output(digit_output)  );*/
module PS2(
	input clk, rst, // clk and reset
	input ps2_clk, ps2_data, // ps2_clk and ps2_data
	output reg up, left, right, down, enter // up, left, right, down and enter
);

reg ps2_clk_falg0, ps2_clk_falg1, ps2_clk_falg2; // register for ps2_clk
wire negedge_ps2_clk = !ps2_clk_falg1 & ps2_clk_falg2; // detect the falling edge of ps2_clk
reg negedge_ps2_clk_shift; // register for the falling edge of ps2_clk
reg [9:0] data; // store the 10-bit data received from ps2
reg data_break, data_done, data_expand; // flags for data processing
reg[7:0] temp_data; // temporary storage of ps2 data
reg[3:0] num; // register for counting the number of ps2 data bits

// update the clock edge detection and auxiliary register
always@(posedge clk or posedge rst) begin
	if(rst) begin
		ps2_clk_falg0 <= 1'b0;
		ps2_clk_falg1 <= 1'b0;
		ps2_clk_falg2 <= 1'b0;
	end
	else begin
		ps2_clk_falg0 <= ps2_clk; //ps2_clk_falg0 is the previous value of ps2_clk
		ps2_clk_falg1 <= ps2_clk_falg0;
		ps2_clk_falg2 <= ps2_clk_falg1;
	end
end

// upodate the PS2 data bit counter
always@(posedge clk or posedge rst) begin
	if(rst)
		num <= 4'd0;
	else if (num == 4'd11)
		num <= 4'd0;
	else if (negedge_ps2_clk)
		num <= num + 1'b1;
end

// update the auxiliary register
always@(posedge clk) begin
	negedge_ps2_clk_shift <= negedge_ps2_clk;
end

// logic for reading data bits and temporary storage
always@(posedge clk or posedge rst) begin
	if(rst)
		temp_data <= 8'd0;
	else if (negedge_ps2_clk_shift) begin
		case(num)
			4'd2 : temp_data[0] <= ps2_data;
			4'd3 : temp_data[1] <= ps2_data;
			4'd4 : temp_data[2] <= ps2_data;
			4'd5 : temp_data[3] <= ps2_data;
			4'd6 : temp_data[4] <= ps2_data;
			4'd7 : temp_data[5] <= ps2_data;
			4'd8 : temp_data[6] <= ps2_data;
			4'd9 : temp_data[7] <= ps2_data;
			default: temp_data <= temp_data;
		endcase
	end
	else temp_data <= temp_data;
end

// logic for PS2 data processing
always@(posedge clk or posedge rst) begin
	if(rst) begin
		data_break <= 1'b0;
		data <= 10'd0;
		data_done <= 1'b0;
		data_expand <= 1'b0;
	end
	else if(num == 4'd11) begin
		if(temp_data == 8'hE0) begin
			data_expand <= 1'b1;
		end
		else if(temp_data == 8'hF0) begin
			data_break <= 1'b1;
		end
		else begin
			data <= {data_expand, data_break, temp_data};
			data_done <= 1'b1;
			data_expand <= 1'b0;
			data_break <= 1'b0;
		end
	end
	else begin
		data <= data;
		data_done <= 1'b0;
		data_expand <= data_expand;
		data_break <= data_break;
	end
end

// logic for PS2 data decoding
always @(posedge clk) begin
	case (data)
        10'h05A: enter <= 1;
        10'h15A: enter <= 0;
        10'h275: up <= 1;
        10'h375: up <= 0;
        10'h26B: left <= 1;
        10'h36B: left <= 0;
        10'h274: right <= 1;
        10'h374: right <= 0;
        10'h072: down <= 1;
        10'h172: down <= 0;
    endcase
end

endmodule


// ps2 module constraint
/*set_property PACKAGE_PIN N18 [get_ports PS2_clk]					
	set_property IOSTANDARD LVCMOS33 [get_ports PS2_clk]
set_property PACKAGE_PIN M19 [get_ports PS2_data]					
	set_property IOSTANDARD LVCMOS33 [get_ports PS2_data]*/