module FSM (
    input clk, rst_sys,        //clk & rst negative signal    
    input rstn,                //rst positive signal
    input arrived,
    output reg [1:0] state,
    output reg [8:0] my_x, my_y
);
always @ (posedge clk)begin
    case (state)
    2'b00:begin
        if(!rst_sys)begin
            state <= 2'b01;
        end
    end
    2'b01:begin
        if(!rstn)begin
            state <= 2'b10;
        end
    end
    2'b10:begin
        if(rstn)begin
            state <= 2'b01;
            my_x <= 9'b000000001;
            my_y <= 9'b000000001;
        end
        else if (arrived)begin
            state <= 2'b11;
        end
    end
    endcase
end
always @(posedge rst_sys)begin
        state <= 2'b00; //welcome,input size of map and rst_sys=>0 to start
        my_x <= 9'b000000001;
        my_y <= 9'b000000001;
        
end

endmodule