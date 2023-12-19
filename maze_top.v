//一出来先按一个reset进入欢迎界面，在这里可以调节num，按enter进入游戏，
//调用一次create，再按下enter可以换地图，只要检测到上下左右就把地图固定，
//然后调用move，但是move的时候应该不能一个clk就move，应该再分频比如每半秒move一格。
//到终点了就显示win界面，按下enter返回creat那个界面
module maze_top(
    input clk, rst_sys,        //clk & rst negative signal    
    input rstn,                //rst positive signal
    input PS2_data,         //ps2_data
    input PS2_clk,          //ps2_clk
    output hsync, vsync,    //horizontal & vertical scan signal
    output [3:0] r,      //rgb value to VGA port
    output [3:0] g,
    output [3:0] b,
    output [7:0] SEGMENT,   //7-segment
    output [3:0] AN,        //common anode
    output SEGCLK,          //serial segment clk
    output SEGDT,           //serial segment data
    output SEGEN,           //serial segment enable 
    output SEGCLR,          //serail segment clear   
)

wire up, down, left, right, enter;
wire [360:0] map;
wire [4:0] num;
wire [4:0] actual_num;
wire [8:0] my_x, my_y;
wire win;


gen_map_top gen_map_top_inst(
    .clk(clk),
    .rst(rstn),
    .rst_random(rst_sys),
    .num(num),
    .map(map),
    .actual_num(actual_num)
);

FSM FSM_inst(
    input clk, rst_sys,        //clk & rst negative signal    
    input rstn,                //rst positive signal
    input PS2_data,    
    output state
);

PS2 ps2_inst(
    .clk(PS2_clk),
    .data(PS2_data),
    .up(up),
    .down(down),
    .left(left),
    .right(right),
    .enter(enter)
);

graphics graphics_inst(
    .clk(clk),
    .rst(rst_sys),
    .HSYNC(hsync),
    .VSYNC(vsync),
    .Red(r),
    .Green(g),
    .Blue(b),
    .num(num),
    .mode(mode),
    .map(map),
    .current_x_index(actual_num[4:0]),
    .current_y_index(actual_num[9:5])
);


endmodule