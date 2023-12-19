module move(
	input clk_10Hz,
	input [1:0] state,
    input [360:0] map,
    input [4:0] num,
    input up, left, right, down,
    input [8:0] my_x,
    input [8:0] my_y,
    output reg [8:0] my_new_x,
    output reg [8:0] my_new_y,
    output reg arrived
);
always @(posedge clk_10Hz) begin
	if(state==2'b10)begin
		my_new_x = my_x;
		my_new_y = my_y;
		arrived = 0;
		if(my_x == num - 1&& my_y == num - 1)begin
			arrived = 1;
		end
		else if(up && my_y != 0)begin
			if(map[(my_y - 1) * num + my_x]==1)begin
				my_new_y = my_y - 1; //up
			end
		end
		else if(down && my_y != num - 1)begin
			if(map[(my_y + 1) * num + my_x]==1)begin
				my_new_y = my_y + 1; //down
			end
		end
		else if(left && my_x != 0)begin
			if(map[my_y * num + my_x - 1]==1)begin
				my_new_x = my_x - 1; //left
			end
		end
		else if(right && my_x != num - 1)begin
			if(map[my_y * num + my_x + 1]==1)begin
				my_new_x = my_x + 1; //right
			end
		end
	end
end
endmodule