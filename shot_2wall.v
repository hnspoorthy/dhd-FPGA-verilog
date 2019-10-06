`timescale 1ns / 1ps
module shot_2wall(
    input clk_65M,
    input clear,
    input game_on,
    input game_startp,
    input move_left,  //V : Shooter to move left
    input move_right, //V : Shooter to move right
    input move_up,    //A: shooter to move up
    input move_down,  ////A: shooter to move down  
    input p_fire,     //fire button signal after clock pulse module
    input [16:0] H_count,
    input [16:0] V_count,
    input wire [0:63]brom_ball_data,     
    output wire [5:0] brom_ball_addr,
    input wire [0:255]brom_thumb_data,  
    input wire [0:255]brom_thumbup_data,    
    output wire [7:0] brom_thumb_addr,    
    output wire [7:0] brom_thumbup_addr,  
    input vid_on,
    input atk1_on,atk2_on,atk3_on,atk4_on,atk5_on,atk6_on,
    input game1_over, game2_over,game3_over, game4_over, game5_over, game6_over,
    output [16:0] shooter_ymid, shooter_xmid,
    output reg[3:0] VGA_red,
    output reg[3:0] VGA_green,
    output reg[3:0] VGA_blue,
    input wire [0:31] brom_count_data,
    output wire [8:0] brom_count_addr,
    output reg game_stop,
    
    input wire [0:63]brom_devil_data,//ay  
    output wire [7:0] brom_devil_addr  //AY
);
   
    parameter HPIXELS =1344;
    parameter VLINES = 806;
    parameter HBP = 296;
    parameter HFP = 1320;
    parameter VBP = 35;
    parameter VFP = 803;
    parameter HSP = 136;
    parameter VSP = 6;
    parameter HSCREEN=1024;
    parameter VSCREEN= 768;

    parameter WALL_1_LEFT= 170;//
    parameter WALL_1_RIGHT = 180;//
    parameter WALL_2_LEFT= 1000;
    parameter WALL_2_RIGHT = 1010;
    parameter WALL_3_LEFT= 180;//
    parameter WALL_3_RIGHT = 1010;
    parameter WALL_4_LEFT= 180;//
    parameter WALL_4_RIGHT = 1010;
    parameter WALL_2_TOP= 20;
    parameter WALL_2_BOTTOM= 750;
    parameter WALL_3_TOP= 20;
    parameter WALL_3_BOTTOM= 30;
    parameter WALL_1_TOP= 20;
    parameter WALL_1_BOTTOM= 750;
    parameter WALL_4_TOP= 740;
    parameter WALL_4_BOTTOM= 750;
    
    parameter ball_xstart=627;//
    parameter ball_ystart=49;
    parameter ball_xstop=690;//
    parameter ball_ystop=112;
    
    parameter thumb_xstart=250;//
    parameter thumb_ystart=150;
    parameter thumb_xstop=505;//
    parameter thumb_ystop=405;
    
    parameter thumbup_xstart=300;//
    parameter thumbup_ystart=200;
    parameter thumbup_xstop=555;//
    parameter thumbup_ystop=455;
    
    parameter SHOOTER_X_START=600;  //V : shooter
    parameter SHOOTER_Y_START=745;
    parameter SHOOTER_SIZE=10; //A: shooter size  
    parameter VELOCITY_SHOOTER_DEFAULT=3;
    
    parameter c_xstart=100;
    parameter c_xstop=131;
    parameter c_ystart=200;
    parameter c_ystop =231;
    
    parameter W1_X0=300, W1_X1=330, W1_Y0=100, W1_Y1=120;
    parameter W2_X0=370, W2_X1=400, W2_Y0=130, W2_Y1=150;//120
    parameter W3_X0=440, W3_X1=470, W3_Y0=160, W3_Y1=180;
    parameter W4_X0=500, W4_X1=530, W4_Y0=190, W4_Y1=210;    
    parameter W5_X0=570, W5_X1=600, W5_Y0=220, W5_Y1=240;//220
    parameter W6_X0=640, W6_X1=670, W6_Y0=250, W6_Y1=270;//250
    parameter W7_X0=700, W7_X1=730, W7_Y0=280, W7_Y1=300;//220 
    parameter W8_X0=770, W8_X1=800, W8_Y0=310, W8_Y1=330;
    parameter W9_X0=840, W9_X1=870, W9_Y0=340, W9_Y1=360;
    parameter W10_X0=900, W10_X1=930, W10_Y0=370, W10_Y1=390;
    
    parameter DEVIL_XSTART=675;//AY
    parameter DEVIL_YSTART=49;//AY
    parameter DEVIL_YSTOP=112;//AY


    //For firing bullet
    parameter BULLET_Y_START = 735;
    parameter BULLET_X_START = 170;
    parameter BULLET_X_START2 = 1011;
    parameter BULLET_SIZE=6;
    parameter VELOCITY_BULLET_DEFAULT=20;
    //reg bullet_on;
    wire [16:0]bullet_ystart, bullet_ystop, bullet_ystart1, bullet_ystop1;
    wire [16:0]bullet_xstart, bullet_xstop, bullet_xstart1, bullet_xstop1;
    wire fire_bullet;
    wire stop_play;
    wire [4:0] total_wall_hit;
    reg [16:0] bullet_ystart_next, bullet_ystart_reg, bullet_ystart2_next, bullet_ystart2_reg, bullet_xstart_next, bullet_xstart_reg, bullet_xstart2_reg, bullet_xstart2_next;
    reg game_win, game_win_next; 
     parameter S0 = 1'b0, //reset state
               S1 = 1'b1; //state when bullet is fired
    reg [3:0] count_reg, count_next;
    reg bullet_present_state =  S0;
    reg bullet_next_state;
    wire[16:0] shooter_xstart,shooter_ystart,shooter_xstop, shooter_ystop;
    //wire [16:0] shooter_xmid_reg; //A: shooter will have a middle point
    //wire [16:0] shooter_ymid_reg; //A: y mid of shooter
    reg wall_1, wall_2, wall_3, wall_4, ball_on, shooter_on,thumb_on, thumbup_on;
    reg w1,w2,w3,w4,w5,w6,w7,w8,w9,w10,w11;
    reg w1_hit,w2_hit,w3_hit,w4_hit,w5_hit,w6_hit,w7_hit,w8_hit,w9_hit,w10_hit,w11_hit;
    
    //Counter parameters
    wire [3:0] counter_index;
    reg counter_on;
    wire [5:0] rom_ball_addr, rom_ball_pix;
    wire [4:0] rom_count_addr, rom_count_pix;
    wire [7:0] rom_thumb_addr, rom_thumb_pix;
    wire [7:0] rom_thumbup_addr, rom_thumbup_pix;
    reg game_over, game_over_next;
    reg ball, count,thumb, thumbup;
    
    //PARAMETER FOR DEVIL MOVEMENT 
    wire [16:0] devil_xstart, devil_xstop;//ay
    wire [5:0] rom_devil_addr, rom_devil_pix;
    reg devil_move, devil_on, devil;
    reg devil_hit;
    
   always@(*)
        begin
        if((H_count>=WALL_1_LEFT+ HBP) && (H_count<=WALL_1_RIGHT +HBP) && (V_count>=WALL_1_TOP+ VBP) && (V_count<=WALL_1_BOTTOM +VBP) && stop_play==1'b0)
            begin
            wall_1<=1'b1;
            wall_2<=1'b0;
            wall_3<=1'b0;
            wall_4<=1'b0;
            end   
        else if((H_count>=WALL_2_LEFT+ HBP) && (H_count<=WALL_2_RIGHT +HBP) && (V_count>=WALL_2_TOP+ VBP) && (V_count<=WALL_2_BOTTOM +VBP)&& stop_play==1'b0)
            begin
                wall_2<=1'b1;
                wall_1<=1'b0;
                wall_3<=1'b0;
                wall_4<=1'b0;
            end
        else if((H_count>=WALL_3_LEFT+ HBP) && (H_count<=WALL_3_RIGHT +HBP) && (V_count>=WALL_3_TOP+ VBP) && (V_count<=WALL_3_BOTTOM +VBP)&& stop_play==1'b0)
            begin
                wall_3<=1'b1;
                wall_1<=1'b0;
                wall_2<=1'b0;
                wall_4<=1'b0;
                end
        else if((H_count>=WALL_4_LEFT+ HBP) && (H_count<=WALL_4_RIGHT +HBP) && (V_count>=WALL_4_TOP+ VBP) && (V_count<=WALL_4_BOTTOM +VBP)&& stop_play==1'b0)
        begin
                wall_3<=1'b0;
                wall_1<=1'b0;
                wall_2<=1'b0;
                wall_4<=1'b1;
        end
        end
    always@(*)
        begin
            if(((H_count>=ball_xstart + HBP) && (H_count<=HBP+ ball_xstop)) &&((V_count>=ball_ystart + VBP) && (V_count<=VBP+ ball_ystop))&& stop_play==1'b0 && devil_move==1'b0)
                ball_on=1;
            else
                ball_on=0;
        end
    // devil movement //ay
       always@(*)
            begin
                if(((H_count>=devil_xstart + HBP) && (H_count<=HBP+ devil_xstop)) &&((V_count>=DEVIL_YSTART + VBP) && (V_count<=VBP+ DEVIL_YSTOP))&& devil_move==1'b1)
                    devil_on=1;
                else
                    devil_on=0;
            end         
    always@(*)
        begin
            if(((H_count>=thumb_xstart + HBP) && (H_count<=HBP+ thumb_xstop)) &&((V_count>=thumb_ystart + VBP) && (V_count<=VBP+ thumb_ystop))&& game_over==1'b1)
                thumb_on=1;
            else
                thumb_on=0;
        end
    always@(*)
        begin
            if(((H_count>=thumbup_xstart + HBP) && (H_count<=HBP+ thumbup_xstop)) &&((V_count>=thumbup_ystart + VBP) && (V_count<=VBP+ thumbup_ystop))&& game_win==1'b1)
                thumbup_on=1;
            else
                thumbup_on=0;
        end
    always@(*)
        begin
        if(((H_count>=shooter_xstart+ HBP) && (H_count<=HBP+ shooter_xstop)) &&((V_count>=shooter_ystart+ VBP) && (V_count<=VBP+ shooter_ystop))&& stop_play==1'b0)
            shooter_on=1;
        else
            shooter_on=0;
        end        

    always@(*)
    begin
    if(((H_count>=W1_X0 + HBP) && (H_count<=HBP+ W1_X1)) &&((V_count>=W1_Y0 + VBP) && (V_count<=VBP+ W1_Y1)) && (w1_hit == 1'b0)&& stop_play==1'b0)
    w1=1;
    else
    w1=0;
    end
    always@(*)
    begin
    if(((H_count>=W2_X0 + HBP) && (H_count<=HBP+ W2_X1)) &&((V_count>=W2_Y0 + VBP) && (V_count<=VBP+ W2_Y1)) && (w2_hit == 1'b0)&& stop_play==1'b0)
    w2=1;
    else
    w2=0;
    end
    always@(*)
    begin
    if(((H_count>=W3_X0 + HBP) && (H_count<=HBP+ W3_X1)) &&((V_count>=W3_Y0 + VBP) && (V_count<=VBP+ W3_Y1)) && (w3_hit == 1'b0)&& stop_play==1'b0)
    w3=1;
    else
    w3=0;
    end
    always@(*)
    begin
    if(((H_count>=W4_X0 + HBP) && (H_count<=HBP+ W4_X1)) &&((V_count>=W4_Y0 + VBP) && (V_count<=VBP+ W4_Y1)) && (w4_hit == 1'b0)&& stop_play==1'b0)
    w4=1;
    else
    w4=0;
    end
    always@(*)
    begin
    if(((H_count>=W5_X0 + HBP) && (H_count<=HBP+ W5_X1)) &&((V_count>=W5_Y0 + VBP) && (V_count<=VBP+ W5_Y1)) && (w5_hit == 1'b0)&& stop_play==1'b0)
    w5=1;
    else
    w5=0;
    end
    always@(*)
    begin
    if(((H_count>=W6_X0 + HBP) && (H_count<=HBP+ W6_X1)) &&((V_count>=W6_Y0 + VBP) && (V_count<=VBP+ W6_Y1)) && (w6_hit == 1'b0)&& stop_play==1'b0)
    w6=1;
    else
    w6=0;
    end
    always@(*)
    begin
    if(((H_count>=W7_X0 + HBP) && (H_count<=HBP+ W7_X1)) &&((V_count>=W7_Y0 + VBP) && (V_count<=VBP+ W7_Y1)) && (w7_hit == 1'b0)&& stop_play==1'b0)
    w7=1;
    else
    w7=0;
    end
    always@(*)
    begin
    if(((H_count>=W8_X0 + HBP) && (H_count<=HBP+ W8_X1)) &&((V_count>=W8_Y0 + VBP) && (V_count<=VBP+ W8_Y1))&& (w8_hit == 1'b0)&& stop_play==1'b0)
    w8=1;
    else
    w8=0;
    end
    always@(*)
    begin
    if(((H_count>=W9_X0 + HBP) && (H_count<=HBP+ W9_X1)) &&((V_count>=W9_Y0 + VBP) && (V_count<=VBP+ W9_Y1)) && (w9_hit == 1'b0)&& stop_play==1'b0)
    w9=1;
    else
    w9=0;
    end
    always@(*)
    begin
    if(((H_count>=W10_X0 + HBP) && (H_count<=HBP+ W10_X1)) &&((V_count>=W10_Y0 + VBP) && (V_count<=VBP+ W10_Y1)) && (w10_hit == 1'b0)&& stop_play==1'b0)
    w10=1;
    else
    w10=0;
    end                                          
    
    //reg game_stop;
   reg [16:0] shooter_ymid_reg, shooter_xmid_reg; 
    reg [16:0] shooter_xmid_next, shooter_ymid_next;
    assign shooter_xmid=shooter_xmid_reg;
    assign shooter_ymid=shooter_ymid_reg;
    assign shooter_xstart=shooter_xmid - (SHOOTER_SIZE);
    assign shooter_xstop =shooter_xmid + (SHOOTER_SIZE);
    assign shooter_ystart = shooter_ymid - (SHOOTER_SIZE);
    assign shooter_ystop = shooter_ymid + (SHOOTER_SIZE);
    
    wire refr_tick;
    assign refr_tick=((V_count==0) && (H_count==0));
    
    always@(posedge clk_65M)
    begin
    if(clear ==1'b1)
    begin
        shooter_xmid_reg<=SHOOTER_X_START;
        shooter_ymid_reg<=SHOOTER_Y_START;
    end
    else
    begin
        shooter_xmid_reg<=shooter_xmid_next;
        shooter_ymid_reg<=shooter_ymid_next;
    end
    end
    
    always@(*)
    begin
    shooter_xmid_next<=shooter_xmid_reg;
    shooter_ymid_next<=shooter_ymid_reg;
    if(game_stop==1'b1)
    begin
        shooter_xmid_next<=SHOOTER_X_START;
        shooter_ymid_next<=SHOOTER_Y_START;
    end 
    else if(shooter_xstop<(715+HBP)&& refr_tick==1'b1 && move_right==1'b1 && shooter_ymid >=745)
    begin
        shooter_xmid_next<=shooter_xmid_reg+VELOCITY_SHOOTER_DEFAULT;
    end
    else if(shooter_xstart>(170) && refr_tick==1'b1 && move_left==1'b1 && shooter_ymid >=745) // 
    begin
       shooter_xmid_next<=shooter_xmid_reg-VELOCITY_SHOOTER_DEFAULT;
    end    
    else if(shooter_ystart>VSP && refr_tick==1'b1 && move_down==1'b1 && shooter_ymid <745 && (shooter_xstop>=(715+HBP) ||shooter_xstart<=170))  // 
    begin
       shooter_ymid_next<=shooter_ymid_reg+VELOCITY_SHOOTER_DEFAULT;
    end  
    else if(shooter_ystop<(VFP-VSP-VBP) && refr_tick==1'b1 && move_up==1'b1 && shooter_ymid >=25 && (shooter_xstop>=(715+HBP)||shooter_xstart<=170))//
    begin
       shooter_ymid_next<=shooter_ymid_reg-VELOCITY_SHOOTER_DEFAULT;
    end   
    end
    
    assign rom_ball_addr=V_count[5:0]-VBP[5:0]-ball_ystart;
    assign brom_ball_addr = rom_ball_addr[5:0];
    assign rom_ball_pix=H_count[5:0]- HBP[5:0]-ball_xstart;
    
    assign rom_thumb_addr=V_count[7:0]-VBP[7:0]-thumb_ystart;
    assign brom_thumb_addr = rom_thumb_addr[7:0];
    assign rom_thumb_pix=H_count[7:0]- HBP[7:0]-thumb_xstart;
    
    assign rom_thumbup_addr=V_count[7:0]-VBP[7:0]-thumbup_ystart;
    assign brom_thumbup_addr = rom_thumbup_addr[7:0];
    assign rom_thumbup_pix=H_count[7:0]- HBP[7:0]-thumbup_xstart;
    
    //assignment for devil after hitting walls
    assign rom_devil_addr=V_count[5:0]-VBP[5:0]-DEVIL_YSTART;
    assign brom_devil_addr = rom_devil_addr[5:0];
    assign rom_devil_pix=H_count[5:0]- HBP[5:0]-devil_xstart;  
       
    always@(*)  //loop for wall 1
    begin
        VGA_red=4'b0000; //white
        VGA_green=4'b0000;
        VGA_blue=4'b0000;
        if(vid_on==1 && game_on==1 && game_win ==1'b1 && thumbup_on==1 && game_over!=1'b1 ) //display blue color of the wall
           begin
               thumbup=brom_thumbup_data[rom_thumbup_pix];
               if(thumbup==1'b1)
                 begin
                     VGA_red=4'b0000;//blue
                     VGA_green=4'b0000;
                     VGA_blue=4'b1111;
                 end
         
                else
                begin
                    VGA_red=4'b1111;//white
                     VGA_green=4'b1111;
                     VGA_blue=4'b1111;
                end
            end
        
        else if(vid_on==1 && game_on==1 && game_win==1'b1 && game_over!=1'b1)
                    begin
                        VGA_red=4'b0000;//green
                               VGA_green=4'b1111;
                               VGA_blue=4'b0000;
                    end
        else if(vid_on==1 && game_on==1 && game_over ==1'b1 && thumb_on==1 ) //display blue color of the wall
           begin
               thumb=brom_thumb_data[rom_thumb_pix];
               if(thumb==1'b1)
                 begin
                     VGA_red=4'b0000;//blue
                     VGA_green=4'b0000;
                     VGA_blue=4'b1111;
                 end
         
                else
                begin
                    VGA_red=4'b1111;//white
                     VGA_green=4'b1111;
                     VGA_blue=4'b1111;
                end
            end
        else if (vid_on==1 && game_on ==1 && game_over==1'b1)
           begin
                   VGA_red=4'b0000;
                   VGA_green=4'b0000;//black
                   VGA_blue=4'b0000;
           end
        else if(vid_on==1 && game_on==1 && (atk1_on == 1 || atk2_on == 1 || atk3_on == 1 || atk4_on == 1 || atk5_on == 1 || atk6_on == 1)  && stop_play==1'b0 && devil_move==1'b0) //display attacker1
                   begin
                      VGA_red=4'b0000;//black
                      VGA_green=4'b0000;
                      VGA_blue=4'b0000;
                   end      
       else if (vid_on==1 && game_on==1 && fire_bullet==1  && stop_play==1'b0) //Sp: to dislay bullet
                       begin
                           VGA_red=4'b1111;//red
                           VGA_green=4'b0000;
                           VGA_blue=4'b0000;
                       end      
            
       else if(vid_on==1 && game_on==1 && ball_on==1 && devil_move==1'b0) //display red color of the ball
        begin
        ball=brom_ball_data[rom_ball_pix];
        if(ball==1'b1)
                begin
                    VGA_red=4'b1111; // red : monster
                    VGA_green=4'b0000;
                    VGA_blue=4'b0000;
                end 
        else
            begin
                   VGA_red=4'b1000;
                   VGA_green=4'b1000;
                   VGA_blue=4'b1000;
           end
       end
       else if(vid_on==1 && game_on==1 && devil_on==1 && devil_move==1'b1) //display red color of the ball
          begin
          devil=brom_devil_data[rom_devil_pix];
          if(devil==1'b1)
                  begin
                      VGA_red=4'b0000; //green : monster
                      VGA_green=4'b1111;
                      VGA_blue=4'b0000;
                  end 
          else
              begin
                     VGA_red=4'b1000;
                     VGA_green=4'b1000;
                     VGA_blue=4'b1000;
             end
         end
       else if(vid_on==1 && game_on==1 && shooter_on==1) //display shooter
           begin
               VGA_red=4'b1111; //pink shooter
               VGA_green=4'b0011;
               VGA_blue=4'b1001;
           end 
       else if(vid_on == 1 && game_on == 1 && counter_on == 1 )     //counter display
       begin
           count = brom_count_data[rom_count_pix];
           if(count == 1'b1)
           begin
               VGA_red = 4'b1100;//orange count
               VGA_green = 4'b1111;
               VGA_blue = 4'b1111; 
           end
           else
           begin
             VGA_red=4'b1000; //grey
              VGA_green=4'b1000;
              VGA_blue=4'b1000;
          end  
      end
    
    
    else if(vid_on==1 && game_on==1 && w1==1 ) //display white brick
    begin
        VGA_red=4'b1111;//peach
        VGA_green=4'b1001;
        VGA_blue=4'b1001;
    end 
    else if(vid_on==1 && game_on==1 && w2==1 ) //display blue color of the wall
    begin
        VGA_red=4'b1111; // white
        VGA_green=4'b1111;
        VGA_blue=4'b1111;
    end 
    else if(vid_on==1 && game_on==1 && w3==1 ) //display blue color of the wall
    begin
        VGA_red=4'b0000;//blue
        VGA_green=4'b0000;
        VGA_blue=4'b1111;
    end 
    else if(vid_on==1 && game_on==1 && w4==1 ) //display green color of the wall
    begin
        VGA_red=4'b1111; // white
        VGA_green=4'b1001;
        VGA_blue=4'b1001;
    end 
    
    else if(vid_on==1 && game_on==1 && w5==1 ) //display blue color of the wall
    begin
        VGA_red=4'b1111;//peach
        VGA_green=4'b1111;
        VGA_blue=4'b1111;
    end 
    else if(vid_on==1 && game_on==1 && w6==1 ) //display blue color of the wall
    begin
        VGA_red=4'b0000; // white
        VGA_green=4'b0000;
        VGA_blue=4'b1111;
    end 
    else if(vid_on==1 && game_on==1 && w7==1 ) //display blue color of the wall
    begin
        VGA_red=4'b1111;//peach
        VGA_green=4'b1001;
        VGA_blue=4'b1001;
    end 
    else if(vid_on==1 && game_on==1 && w8==1 ) //display blue color of the wall
    begin
        VGA_red=4'b1111; // white
        VGA_green=4'b1111;
        VGA_blue=4'b1111;
    end 
    else if(vid_on==1 && game_on==1 && w9==1 ) //display blue color of the wall
    begin
        VGA_red=4'b0000;//peach
        VGA_green=4'b0000;
        VGA_blue=4'b1111;
    end 
    else if(vid_on==1 && game_on==1 && w10==1 ) //display blue color of the wall
    begin
        VGA_red=4'b1111;
        VGA_green=4'b1001;
        VGA_blue=4'b1001;
    end 
    else if(vid_on==1 && game_on==1 && wall_1==1  ) //display blue color of the wall
    begin
       VGA_red=4'b0000;
       VGA_green=4'b0011;
       VGA_blue=4'b0011;
    end
    else if(vid_on==1 && game_on==1 && wall_2==1  ) //display blue color of the wall
    begin
       VGA_red=4'b0000;
       VGA_green=4'b0011;
       VGA_blue=4'b0011;
    end
    else if(vid_on==1 && game_on==1 && wall_3==1 ) //display blue color of the wall
    begin
       VGA_red=4'b0000;
       VGA_green=4'b0011;
       VGA_blue=4'b0011;
    end
    else if(vid_on==1 && game_on==1 && wall_4==1 ) //display blue color of the wall
    begin
       VGA_red=4'b0000;
       VGA_green=4'b0011;
       VGA_blue=4'b0011;
    end
    
   
     else if(vid_on==1 && game_on==1 )//&& stop_play==1'b0) //display yellow color of the wall
           begin
               VGA_red=4'b1000;
              VGA_green=4'b1000;//grey
              VGA_blue=4'b1000;
           end
           
    else if(vid_on==1)//display white 
    begin
        VGA_red=4'b1111;
        VGA_green=4'b1111;//white
        VGA_blue=4'b1111;
    end
      
    
  end
 
 //bullet firing
    reg next_state;
    reg present_state;
    reg y_hit;
    reg bullet_on;
    
    always @(posedge clk_65M)
    begin
    if(clear == 1'b0 && game_on == 1'b1) 
        begin
           present_state <= next_state;
        end
    else
       begin
       present_state <= S0;
       
       end
    end
    
    always@(posedge clk_65M)
    begin
       if(clear ==1'b1 || y_hit == 1'b1)
       begin
          bullet_ystart_reg <= BULLET_Y_START;
          bullet_xstart_reg <= BULLET_X_START;
          bullet_xstart2_reg <= BULLET_X_START2;
       end
       else
       begin
          bullet_ystart_reg <= bullet_ystart_next;
          bullet_xstart_reg <= bullet_xstart_next;
          bullet_xstart2_reg <= bullet_xstart2_next;    
       end
    end
    
    always@(posedge clk_65M)
    begin
       if(clear == 1'b1)
          count_reg <=0;
       else
          count_reg <= count_next;    
    end
    
    always @(*)
    begin
       next_state = present_state;
       count_next = count_reg;
       case(present_state)
       S0: if(p_fire == 1 && count_reg < 4'd11)
            begin
                next_state <= S1;
                count_next <= count_reg + 1;
            end
           else
                next_state <= S0;
       S1: if(y_hit == 1)
           begin
               next_state <= S0;
           end
           else
           next_state <= S1;
        default : next_state <= S0;
        endcase
    end
   
   assign bullet_ystart = bullet_ystart_reg;
   assign bullet_ystop = bullet_ystart + BULLET_SIZE;
   assign bullet_xstart = shooter_xmid - 2;
   assign bullet_xstop = shooter_xmid +2;
   
   assign bullet_ystart1 = shooter_ymid - 2;
   assign bullet_ystop1 = shooter_ymid +2;
   assign bullet_xstart1 = bullet_xstart_reg;
   assign bullet_xstop1 = bullet_xstart1 + BULLET_SIZE;
  
   wire bullet_xstart2, bullet_xstop2, bullet_ystart2, bullet_ystop2;
//   assign bullet_ystart2 = shooter_ymid - 2;
//   assign bullet_ystop2 = shooter_ymid +2;
   assign bullet_xstart2 = bullet_xstart2_reg;
   assign bullet_xstop2 = bullet_xstart2 + BULLET_SIZE;
   
   
   
   always@(*)
   begin
   if (present_state == S1 && y_hit == 1'b0)
       if((H_count >= bullet_xstart + HBP) && (H_count <= bullet_xstop + HBP) && (V_count >= bullet_ystart + VBP) && (V_count <= bullet_ystop + VBP))
            bullet_on = 1'b1;
       else if(((H_count >= bullet_xstart1 + HBP)) && ((H_count <= bullet_xstop1 + HBP)) && ((V_count >= bullet_ystart1 + VBP)) && ((V_count <= bullet_ystop1 + VBP)))
            bullet_on = 1'b1;
       else if(((H_count >= bullet_xstart2 + HBP)) && ((H_count <= bullet_xstop2 + HBP)) && ((V_count >= bullet_ystart1 + VBP)) && ((V_count <= bullet_ystop1 + VBP)))
            bullet_on = 1'b1;
       else
            bullet_on = 1'b0;
    else 
       bullet_on = 1'b0;  
    end  
    
   always@(*)
   begin
    bullet_ystart_next= bullet_ystart_reg;
    bullet_xstart_next= bullet_xstart_reg;
    bullet_xstart2_next= bullet_xstart2_reg;
       if(!(clear == 1'b0 &&  game_on == 1'b1))
           begin
               w1_hit <= 1'b0;
               w2_hit <= 1'b0;
               w3_hit <= 1'b0;
               w4_hit <= 1'b0;
               w5_hit <= 1'b0;
               w6_hit <= 1'b0;
               w7_hit <= 1'b0;
               w8_hit <= 1'b0;
               w9_hit <= 1'b0;
               w10_hit <= 1'b0;               
               w11_hit <= 1'b0;
               devil_hit<=1'b0;
           end
        else
            begin
            if (shooter_ymid >= 745 && shooter_xstop < 1011)
            begin
               if(present_state == S1 && (bullet_ystart >16'd60) && refr_tick==1'b1 && y_hit == 1'b0)
                begin
                    bullet_ystart_next<= bullet_ystart_reg - VELOCITY_BULLET_DEFAULT;
                    if((bullet_ystart <=  W1_Y1)&& (bullet_ystop >= W1_Y0)&& (bullet_xstart >= W1_X0 - 3) && (bullet_xstop<= W1_X1 + 3) && w1_hit!=1'b1)
                        begin
                            y_hit <= 1'b1;
                            w1_hit<=1'b1;
                        end 
                    else if((bullet_ystart <=  W2_Y1)&& (bullet_ystop >= W2_Y0)&& (bullet_xstart >= W2_X0 - 3) && (bullet_xstop<= W2_X1 + 3) && w2_hit!=1'b1)
                        begin
                            y_hit <= 1'b1;
                            w2_hit<=1'b1;
                        end 
                    else if((bullet_ystart <=  W3_Y1)&& (bullet_ystop >= W3_Y0)&& (bullet_xstart >= W3_X0 - 3) && (bullet_xstop<= W3_X1 + 3) && w3_hit!=1'b1)
                        begin
                            y_hit <= 1'b1;
                            w3_hit<=1'b1;
                        end 
                    else if((bullet_ystart <=  W4_Y1)&& (bullet_ystop >= W4_Y0)&& (bullet_xstart >= W4_X0 - 3) && (bullet_xstop<= W4_X1 + 3) && w4_hit!=1'b1)
                        begin
                            y_hit <= 1'b1;
                            w4_hit<=1'b1;
                        end 
                    else if((bullet_ystart <=  W5_Y1)&& (bullet_ystop >= W5_Y0)&& (bullet_xstart >= W5_X0 - 3) && (bullet_xstop<= W5_X1 + 3) && w5_hit!=1'b1)
                        begin
                            y_hit <= 1'b1;
                            w5_hit<=1'b1;
                        end 
                    else if((bullet_ystart <=  W6_Y1)&& (bullet_ystop >= W6_Y0)&& (bullet_xstart >= W6_X0 - 3) && (bullet_xstop<= W6_X1 + 3) && w6_hit!=1'b1)
                        begin
                            y_hit <= 1'b1;
                            w6_hit<=1'b1;
                        end 
                    else if((bullet_ystart <=  W7_Y1)&& (bullet_ystop >= W7_Y0)&& (bullet_xstart >= W7_X0 - 3) && (bullet_xstop<= W7_X1 + 3) && w7_hit!=1'b1)
                        begin
                            y_hit <= 1'b1;
                            w7_hit<=1'b1;
                        end 
                    else if((bullet_ystart <=  W8_Y1)&& (bullet_ystop >= W8_Y0)&& (bullet_xstart >= W8_X0 - 3) && (bullet_xstop<= W8_X1 + 3) && w8_hit!=1'b1)
                        begin
                            y_hit <= 1'b1;
                            w8_hit<=1'b1;
                        end
                    else if((bullet_ystart <=  W9_Y1)&& (bullet_ystop >= W9_Y0)&& ( bullet_xstart>= W9_X0 - 3) && (bullet_xstop <= W9_X1 + 3) && w9_hit!=1'b1)
                        begin
                            y_hit <= 1'b1;
                            w9_hit<=1'b1;
                        end 
                    else if((bullet_ystart <=  W10_Y1)&& (bullet_ystop >= W10_Y0)&& (bullet_xstart >= W10_X0 - 3) && ( bullet_xstop <= W10_X1 + 3) && w10_hit!=1'b1)
                        begin
                            y_hit <= 1'b1;
                            w10_hit<=1'b1;
                        end 
                    //con for devil to be hit //ay
                    else if (bullet_ystart<=DEVIL_YSTOP && bullet_xstart>=devil_xstart && bullet_xstop<=devil_xstop && devil_move==1'b1 && devil_hit!=1'b1)
                        begin
                        devil_hit<=1'b1;
                        y_hit<=1'b1;
                        end
                    else 
                        y_hit <= 1'b0;
                end
                else if(present_state == S1 && bullet_ystart <= 16'd60 && refr_tick == 1'b1)
                       y_hit = 1'b1;
                else 
                    y_hit = 1'b0;
            end 
            
            else if (shooter_xstart <= 170 && shooter_xstop < 1011)
            begin
                if(present_state == S1 && (bullet_xstart1 < 16'd1000) && refr_tick==1'b1 && y_hit == 1'b0)
                begin
                     bullet_xstart_next <= bullet_xstart_reg + VELOCITY_BULLET_DEFAULT;
                    if((bullet_ystart1 <=  W1_Y1)&& (bullet_ystop1 >= W1_Y0)&& (bullet_xstart1 >= W1_X0 - 3) && (bullet_xstop1 <= W1_X1 + 3) && w1_hit!=1'b1)
                         begin
                             y_hit <= 1'b1;
                             w1_hit<=1'b1;
                         end 
                     else if((bullet_ystart1 <=  W2_Y1)&& (bullet_ystop1 >= W2_Y0)&& (bullet_xstart1 >= W2_X0 - 3) && (bullet_xstop1 <= W2_X1 + 3) && w2_hit!=1'b1)
                         begin
                             y_hit <= 1'b1;
                             w2_hit<=1'b1;
                         end 
                     else if((bullet_ystart1 <=  W3_Y1)&& (bullet_ystop1 >= W3_Y0)&& (bullet_xstart1 >= W3_X0 - 3) && (bullet_xstop1 <= W3_X1 + 3) && w3_hit!=1'b1)
                         begin
                             y_hit <= 1'b1;
                             w3_hit<=1'b1;
                         end 
                     else if((bullet_ystart1 <=  W4_Y1)&& (bullet_ystop1 >= W4_Y0)&& (bullet_xstart1 >= W4_X0 - 3) && (bullet_xstop1 <= W4_X1 + 3) && w4_hit!=1'b1)
                         begin
                             y_hit <= 1'b1;
                             w4_hit<=1'b1;
                         end 
                     else if((bullet_ystart1 <=  W5_Y1)&& (bullet_ystop1 >= W5_Y0)&& (bullet_xstart1 >= W5_X0 - 3) && (bullet_xstop1 <= W5_X1 + 3) && w5_hit!=1'b1)
                         begin
                             y_hit <= 1'b1;
                             w5_hit<=1'b1;
                         end 
                     else if((bullet_ystart1 <=  W6_Y1)&& (bullet_ystop1 >= W6_Y0)&& (bullet_xstart1 >= W6_X0 - 3) && (bullet_xstop1 <= W6_X1 + 3) && w6_hit!=1'b1)
                         begin
                             y_hit <= 1'b1;
                             w6_hit<=1'b1;
                         end 
                     else if((bullet_ystart1 <=  W7_Y1)&& (bullet_ystop1 >= W7_Y0)&& (bullet_xstart1 >= W7_X0 - 3) && (bullet_xstop1 <= W7_X1 + 3) && w7_hit!=1'b1)
                         begin
                             y_hit <= 1'b1;
                             w7_hit<=1'b1;
                         end 
                     else if((bullet_ystart1 <=  W8_Y1)&& (bullet_ystop1 >= W8_Y0)&& (bullet_xstart1 >= W8_X0 - 3) && (bullet_xstop1 <= W8_X1 + 3) && w8_hit!=1'b1)
                         begin
                             y_hit <= 1'b1;
                             w8_hit<=1'b1;
                         end
                     else if((bullet_ystart1 <=  W9_Y1)&& (bullet_ystop1 >= W9_Y0)&& ( bullet_xstart1 >= W9_X0 - 3) && (bullet_xstop1 <= W9_X1 + 3) && w9_hit!=1'b1)
                         begin
                             y_hit <= 1'b1;
                             w9_hit<=1'b1;
                         end 
                     else if((bullet_ystart1 <=  W10_Y1)&& (bullet_ystop1 >= W10_Y0)&& (bullet_xstart1 >= W10_X0 - 3) && ( bullet_xstop1 <= W10_X1 + 3) && w10_hit!=1'b1)
                         begin
                             y_hit <= 1'b1;
                             w10_hit<=1'b1;
                         end 
                     //con for devil to be hit //ay
                     else if (bullet_ystart<=DEVIL_YSTOP && bullet_xstart>=devil_xstart && bullet_xstop<=devil_xstop && devil_move==1'b1 && devil_hit!=1'b1)
                         begin
                         devil_hit<=1'b1;
                         y_hit<=1'b1;
                         end
                     else 
                         y_hit <= 1'b0;
                 end
                else if(present_state == S1 && bullet_xstart1 >= 16'd1000 && refr_tick == 1'b1)
                     y_hit = 1'b1;
                else 
                     y_hit = 1'b0;
            end
            
            else if (shooter_xstart > 170 && shooter_xstop >= 1011) 
            begin
                if(present_state == S1 && (bullet_xstart2 > 16'd170) && refr_tick==1'b1 && y_hit == 1'b0)
                     bullet_xstart2_next <= bullet_xstart2_reg - VELOCITY_BULLET_DEFAULT;
                else if(present_state == S1 && bullet_xstart2 <= 16'd170 && refr_tick == 1'b1)
                     y_hit = 1'b1;
                else 
                     y_hit = 1'b0;
            end
            end
        end
        
 assign fire_bullet = bullet_on;
 assign total_wall_hit =(w1_hit+w2_hit+w3_hit+w4_hit+w5_hit+w6_hit+w7_hit+w8_hit+w9_hit+w10_hit);

 //Sp: Counter display
 always@(*)
     begin
        if ((H_count>=c_xstart +HBP && H_count <=c_xstop +HBP) && (V_count>=c_ystart+VBP && V_count<=c_ystop+VBP) && stop_play==1'b0)

           counter_on = 1;
         else
           counter_on = 0;
     end   

     assign rom_count_addr = V_count [4:0] - VBP [4:0] - c_ystart;
     assign brom_count_addr = rom_count_addr [4:0] + count_reg * 32;
     assign rom_count_pix = H_count [4:0] - HBP [4:0] - c_xstart; 
     
     always@(posedge clk_65M)
     begin     
     if(clear ==1'b1)         
         game_stop=1'b1;     
     else if ((game_startp ==1'b1))         
         game_stop=1'b0;     
     else if(game_on==1'b0)         
         game_stop=1'b1;       
     end   
     
     always@(posedge clk_65M)
      begin     
      if(game_stop ==1'b1)         
        game_over <= 1'b0;   
      else
        game_over <= game_over_next;
      end 
        
     always@(*)
     begin
     game_over_next = game_over;
     if((count_reg == 4'd11 || ((game1_over == 1'b1 || game2_over == 1'b1 || game3_over==1'b1 || game4_over == 1'b1 || game5_over == 1'b1 || game6_over == 1'b1) && devil_move == 1'b0)) && game_win != 1'b1)
        game_over_next=1'b1;
     else 
        game_over_next=1'b0;
     end
     
     always@(posedge clk_65M)
       begin     
       if(game_stop ==1'b1)         
         game_win <= 1'b0;   
       else
         game_win <= game_win_next;
       end 
     
     always@(*)
     begin
        game_win_next = game_win;
         if(total_wall_hit>=4'd2 && devil_hit==1'b1)//ay for testing 
            game_win_next=1'b1;
         else
            game_win_next=1'b0;
     end
     
     always@(*)
      begin
          if(total_wall_hit>=4'd2 )//&& count_reg<=4'd11)//ay for testing 
             devil_move=1'b1;//ay
          else
            devil_move=1'b0;
      end

//    always@(clk_65M)
//     begin
//     if(total_wall_hit==4'd10)
//        game_win=1'b1;
//     else
//        game_win=1'b0;
//     end

    
    assign stop_play=(game_over || game_win);
    
    //ayesha
    // devil movement
    reg [16:0] devil_xstart_reg, devil_xstart_next;//, devil_xstart_delta_reg, devil_xstart_delta_next;
    assign devil_xstart=devil_xstart_reg;
    assign devil_xstop=devil_xstart+63;
    reg wall_hit_left,wall_hit_left_next;
    reg wall_hit_right,wall_hit_right_next;
    //assign wall_hit_left  = (devil_xstart<=WALL_1_RIGHT);
    //assign wall_hit_right  = (devil_xstop>=WALL_2_LEFT);
    always@(clk_65M)
    begin
        if(game_stop==1'b1)
            begin
            wall_hit_left<=1'b0;
            wall_hit_right<=1'b0;
            end
        else
            begin
            wall_hit_left<=wall_hit_left_next;
            wall_hit_right<=wall_hit_right_next;
            end
        
    end
    
    always@(*)
       begin
       wall_hit_left_next=wall_hit_left;
       wall_hit_right_next=wall_hit_right;
       if(devil_xstop>=WALL_2_LEFT)
            begin
            wall_hit_right_next<=1'b1;
            wall_hit_left_next<=1'b0;
            end
       else if(devil_xstart<=WALL_1_RIGHT) //&& refr_tick ==1'b1
            begin
            wall_hit_left_next<=1'b1;
            wall_hit_right_next<=1'b0;
            end
        end
        
    always@(posedge clk_65M)
        begin
        if(total_wall_hit<4'd2)//total_wall_hit<4'd2
            devil_xstart_reg<=DEVIL_XSTART;
        else if(total_wall_hit>=4'd2) 
            devil_xstart_reg<=devil_xstart_next;
        end
    always@(*)
       begin
         devil_xstart_next=devil_xstart_reg;//&& devil_xstart>=WALL_1_RIGHT-50 
         //(collision_reg%2==1 || devil_xstart<=WALL_1_RIGHT
       if((wall_hit_left==1'b0 && wall_hit_right==1'b0) && refr_tick==1'b1 && devil_move==1'b1 )
            devil_xstart_next=devil_xstart_reg+VELOCITY_SHOOTER_DEFAULT; 
       else if(wall_hit_right==1'b1 && wall_hit_left==1'b0 && refr_tick==1'b1 && devil_move==1'b1 )
            devil_xstart_next=devil_xstart_reg-VELOCITY_SHOOTER_DEFAULT;                         
       else if((wall_hit_left==1'b1 && wall_hit_right==1'b0) && refr_tick==1'b1 && devil_move==1'b1 )
            devil_xstart_next=devil_xstart_reg+VELOCITY_SHOOTER_DEFAULT;
       else if(game_stop==1'b1)
            devil_xstart_next<=DEVIL_XSTART;
       end   
                   
endmodule