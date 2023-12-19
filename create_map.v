//create_map module:
//when posedge rst, randomly generate the map_3D
module create_map(
    input clk, 
    input rst_sys,
    input rst_map,  
    input [4:0] num, //input size should be odd and between 3 and 19
    output reg [360:0] map,
    output reg [4:0] actual_num
);  
    // Declare variables here  
    reg [31:0] x = 1, y = 2; 
    reg [31:0] X_index = 1, Y_index = 1;
    reg [31:0] i, j, cnt1, cnt2, temp_j;
    reg [31:0] flag = 0;
    reg [31:0] rand_point = 0;
    reg [3:0] map_3D [30:0][30:0];
    reg done1 = 0, done2 = 0, done3 = 0, done4 = 0;
    reg [7:0] rand_num;

    // random num creater
    always @(posedge clk or posedge rst_sys) begin
        if(rst_sys) begin
            rand_num <= 8'b10101010;
        end
        else begin
            rand_num[0] <= rand_num[7];
            rand_num[1] <= rand_num[0];
            rand_num[2] <= rand_num[1];
            rand_num[3] <= rand_num[2];
            rand_num[4] <= rand_num[3] ^ rand_num[7];
            rand_num[5] <= rand_num[4] ^ rand_num[7];
            rand_num[6] <= rand_num[5] ^ rand_num[7];
            rand_num[7] <= rand_num[6];
        end
    end

    always @(posedge rst_map) begin
        x = 1;
        y = 2;
        X_index = 1;
        Y_index = 1;
        flag = 0;
        rand_point = 0;
        done1 = 0;
        done2 = 0;
        done3 = 0;
        done4 = 0;
		  
        actual_num = (num % 2 == 0) ? num - 1 : num;
        // Initialize the map_3D to all zeros
        for (i = 0; i < 19; i = i + 1) begin
            for (j = 0; j < 19; j = j + 1) begin
                map_3D[i][j] = 4'b0000;  // 0 for wall and 1 for path
            end
        end
        // Set values based on conditions
        for (i = 0; i < 19; i = i + 1) begin
            for (j = 0; j < 19; j = j + 1) begin
                if (i >= actual_num || j >= actual_num) 
                    map_3D[i][j] = 4'b1111;  // -1 for out of range
                else if (i != 0 && j != 0 && i != actual_num - 1 && j != actual_num - 1) begin
                    if (i % 2 != 0 && j % 2 == 1)
                        map_3D[i][j] = 4'b0001;  // 1 for path
                end
            end
        end

        // Set specific values
        map_3D[1][1] = 4'b0101; 
        map_3D[1][2] = 4'b0110; 
        map_3D[2][1] = 4'b0110; 
        for(cnt1 = 0; cnt1 < 200; cnt1 = cnt1 + 1)begin
            if(!done1)begin
                flag = 0;  
                for (i = 0; i < actual_num; i = i + 1) begin  
                    for (j = 0; j < actual_num; j = j + 1) begin
                        if (map_3D[i][j] == 4'b0110) 
                            flag = flag + 1;  //if there is a blue block, flag++
                    end  
                end
                if(!flag) begin
                        done1 = 1;
                    end
                else begin 
                    done2 = 0;
                    for(cnt2 = 0; cnt2 < 300; cnt2 = cnt2 + 1)begin
                        if (!done2) begin		 
                            if (flag == 1)  
                                rand_point = 0; 
                            else  begin
                                rand_point = rand_num % flag;
                                    end
                            done3 = 0;
                                                                    
                            for (i = 0; i < actual_num; i = i + 1) begin
                                if(!done3) begin
                                    done4 = 0;
                                    temp_j = 0;
                                    for (j = 0; j < actual_num; j = j + 1) begin  
                                        if(!done4) begin
                                            if (map_3D[i][j] == 4'b0110 && rand_point == 0) begin  
                                                x = i;  
                                                y = j; 
                                                temp_j = j; 
                                                done4 = 1;
                                            end  
                                            else if (map_3D[i][j] == 4'b0110) begin  
                                                rand_point = rand_point - 1;  
                                            end
                                        end
                                    end  
                                    if (map_3D[i][temp_j] == 4'b0110 && rand_point == 0) begin  
                                        done3 = 1; 
                                    end
                                end
                            end  
                            if (map_3D[x + 1][y] == 4'b0101) begin  
                                if (map_3D[x - 1][y] == 4'b0001) begin  
                                    map_3D[x - 1][y] = 4'b0101;  
                                    map_3D[x][y] = 4'b0101;  
                                    x = x - 1;  
                                end  
                                else begin  
                                    map_3D[x][y] = 4'b0000;  
                                    done2 = 1;
                                end
                            end else if(map_3D[x - 1][y] == 4'b0101) begin
                                if (map_3D[x + 1][y] == 1) begin
                                    map_3D[x + 1][y] = 4'b0101;
                                    map_3D[x][y] = 4'b0101;
                                    x = x + 1;
                                end
                                else begin
                                    map_3D[x][y] = 0;
                                    done2 = 1;
                                end 
                            end
                            else if(map_3D[x][y + 1] == 4'b0101) begin
                                if (map_3D[x][y - 1] == 1) begin
                                    map_3D[x][y - 1] = 4'b0101;
                                    map_3D[x][y] = 4'b0101;
                                    y = y - 1;
                                end
                                else begin
                                    map_3D[x][y] = 0;
                                    done2 = 1;
                                end
                            end
                            else if(map_3D[x][y - 1] == 4'b0101) begin
                                if (map_3D[x][y + 1] == 1) begin
                                    map_3D[x][y + 1] = 4'b0101;
                                    map_3D[x][y] = 4'b0101;
                                    y = y + 1;
                                end
                                else begin
                                    map_3D[x][y] = 0;
                                    done2 = 1;
                                end
                            end
                            if(!done2)begin
                                X_index = x;
                                Y_index = y;
                                if (X_index > 1 && map_3D[X_index - 1][Y_index] == 4'b0000)  
                                    map_3D[X_index - 1][Y_index] = 4'b0110;  
                                if (Y_index > 1 && map_3D[X_index][Y_index - 1] == 4'b0000)  
                                    map_3D[X_index][Y_index - 1] = 4'b0110;  
                                if (X_index < actual_num - 2 && map_3D[X_index + 1][Y_index] == 4'b0000)  
                                    map_3D[X_index + 1][Y_index] = 4'b0110;  
                                if (Y_index < actual_num - 2 && map_3D[X_index][Y_index + 1] == 4'b0000)  
                                    map_3D[X_index][Y_index + 1] = 4'b0110; 
                            end
                        end 
                    end 
                end
            end
        end

        for (i = 0; i < actual_num; i = i + 1) begin
            for (j = 0; j < actual_num; j = j + 1) begin
                if (map_3D[i][j] == 4'b0101)
                    map_3D[i][j] = 4'b0001;
            end
        end

        for (i = 0; i < actual_num; i = i + 1) begin
            for (j = 0; j < actual_num; j = j + 1) begin
                map[i * actual_num + j] = map_3D[i][j];
            end
        end
        map[actual_num * (actual_num - 1) - 2] = 4'b0001;
    end 
endmodule
