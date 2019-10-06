module attacker3
//#(parameter ATTK_X_START=497, parameter ATTK_Y_START=49, parameter ATTK_XVEL_DEF=1, parameter ATTK_YVEL_DEF= 5, parameter ATTK_SIZE=3)

(
    input clk_65M,
    input clear,
    input game_on,
//    input game_startp,
    input [16:0] H_count,
    input [16:0] V_count,
    input vid_on,
    input game_stop,
    input [16:0] shooter_ymid, shooter_xmid,
    output reg atk3_on, /*atk2_on, atk3_on, atk4_on, atk5_on,*/
    //output [16:0] atk_ystart, atk_xstart,
    output reg game3_over
    );
    
    parameter HBP = 296;
    parameter HFP = 1320;
    parameter VBP = 35;
    parameter VFP = 803;
    parameter HSP = 136;
    parameter VSP = 6;
    parameter WALL_1_LEFT= 170;
    parameter WALL_1_RIGHT = 180;
    parameter WALL_2_LEFT= 1000;
    parameter WALL_2_RIGHT = 1010;
    parameter WALL_4_LEFT= 180;
    parameter WALL_4_RIGHT = 1010;
    parameter WALL_2_TOP= 20;
    parameter WALL_2_BOTTOM= 750;
    parameter WALL_1_TOP= 20;
    parameter WALL_1_BOTTOM= 750;
    parameter WALL_4_TOP= 740;
    parameter WALL_4_BOTTOM= 750;
    
    parameter ATTK_X_START = 627; 
    parameter ATTK_Y_START = 49; 
    parameter ATTK_XVEL_DEF = 1; 
    parameter ATTK_YVEL_DEF = 4;
    parameter ATTK_SIZE=3;
    
    parameter SHOOTER_SIZE=10; 
    wire [16:0]atk_ystart, atk_xstart;
    wire [16:0]atk_ystop, atk_xstop;
   
    reg [16:0] atk_ystart_next, atk_ystart_reg;
    reg [16:0] atk_xstart_next, atk_xstart_reg;
    
                   
    always@(*)
    begin
    if(((H_count>=atk_xstart + HBP) && (H_count<=HBP+ atk_xstop)) &&((V_count>=atk_ystart + VBP) && (V_count<=VBP+ atk_ystop)) && game3_over == 1'b0)
        atk3_on=1;
    else
        atk3_on=0;
    end
    
    assign atk_xstart = atk_xstart_reg;
    assign atk_xstop = atk_xstart_reg + ATTK_SIZE;
    assign atk_ystart = atk_ystart_reg;
    assign atk_ystop = atk_ystart_reg + ATTK_SIZE;
               
    always@(posedge clk_65M)
    begin
    if(game_stop == 1'b1)
        begin
            atk_xstart_reg<=ATTK_X_START;
            atk_ystart_reg<=ATTK_Y_START;
        end
    else
        begin
            atk_xstart_reg<=atk_xstart_next;
            atk_ystart_reg<=atk_ystart_next;
        end
    end
    
    wire [16:0] shooter_xstart, shooter_xstop, shooter_ystart, shooter_ystop;   
    assign shooter_xstart = shooter_xmid - (SHOOTER_SIZE);
    assign shooter_xstop = shooter_xmid + (SHOOTER_SIZE);
    assign shooter_ystart = shooter_ymid - (SHOOTER_SIZE);
    assign shooter_ystop = shooter_ymid + (SHOOTER_SIZE);
    
    wire refr_tick;
    reg atk1_hit;
    assign refr_tick=((V_count==0) && (H_count==0));      
       
    always@(*)
    begin
        atk_xstart_next= atk_xstart_reg;
        if(game_stop==1'b1)
            atk_xstart_next=ATTK_X_START;   
        else if(refr_tick==1'b1 && (atk_ystop < WALL_4_TOP ))// && atk1_hit==1'b0)
           atk_xstart_next= atk_xstart_reg + ATTK_XVEL_DEF;
        else if(refr_tick==1'b1 && (atk_ystop >= WALL_4_TOP))// && atk1_hit==1'b0)
            atk_xstart_next = ATTK_X_START;    
    end
    //reg game_over_reg;
    always@(*)
    begin
        atk_ystart_next= atk_ystart_reg;

        if(game_stop==1'b1)
        begin
            atk_ystart_next <= ATTK_Y_START;
            game3_over <= 1'b0;
        end
        else if((refr_tick ==1'b1) && game3_over == 1'b0 && (atk_xstart >= shooter_xstart) && (atk_xstop<=shooter_xstop) && (atk_ystop<=shooter_ystop)&& (atk_ystart>=shooter_ystart))
        game3_over =1'b1;
        
        else if(refr_tick ==1'b1 && (atk_ystop < WALL_4_TOP )&& game3_over == 1'b0)// && atk1_hit==1'b0)
        begin
            atk_ystart_next <= atk_ystart_reg + ATTK_YVEL_DEF;   
            game3_over <= 1'b0;
        end
        else if(refr_tick==1'b1 && (atk_ystop >= WALL_4_TOP )&& game3_over == 1'b0)// && atk1_hit==1'b0)
        begin
            atk_ystart_next <= ATTK_Y_START;    
            game3_over <= 1'b0;
        end
        else if(game3_over == 1'b1)
            game3_over = 1'b1;
    end
    endmodule