module welcome(
    input clkdiv_2hz,
    input up,
    input down,
    input [1:0] state,
    output reg [4:0] my_num
);
reg enable;
always @ (posedge clkdiv_2hz)begin
    if(state==2'b00)begin
        if (!enable)begin
        my_num <= 5'b01010;
        enable <= 1'b1;
        end
        else 
        if (up&&my_num<19)begin
            my_num <= my_num + 1'b1;
        end
        else if (down&&my_num>0)begin
            my_num <= my_num - 1'b1;
        end
    end
end
endmodule