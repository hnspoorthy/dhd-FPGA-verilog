`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: Indraprastha Institute of Information Technology, Delhi, India	
// Engineer: Spoorthy H N, Ayesha Yadav, Vaishali Jain
// 
// Create Date: 02.03.2019 01:11:54
// Design Name: VGA Game
// Module Name: top_breakingbrick
// Project Name: Breaking brick
// Target Devices: Zynq 7000
// Tool Versions: Vivado 2018.2
// Description: Game designed using VGA module
// 
// Dependencies: 
// 
// Revision: 
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module top_vga(
    input clk_100M,
    input clear,
    input game_on,
    input game_start,
    output H_sync,
    output V_sync,
    input move_left,
    input move_right,
    input move_up,
    input move_down,
    input fire_in,
    output [3:0]VGA_red,
    output [3:0]VGA_green,
    output [3:0]VGA_blue
    );
    wire clk_65M, clk_5M, clk_1k, clk_200h;
    wire [16:0]H_count,V_count;
    wire vid_on;
    wire game_startp;
    wire [0:63]brom_ball_data; 
    wire [5:0] brom_ball_addr;
    wire [0:31]brom_count_data;
    wire [8:0] brom_count_addr;
    wire [0:255]brom_thumb_data;     
    wire [7:0] brom_thumb_addr;   
    wire [0:255]brom_thumbup_data;     
    wire [7:0] brom_thumbup_addr;     
    wire [16:0] shooter_xmid, shooter_ymid;
    wire p_fire;
    wire fire_bullet, y_hit, w11_hit, bullet_on, present_state;
    wire w11;
    wire game1_over, atk1_on, game2_over, atk2_on, game3_over, atk3_on, game4_over, atk4_on, game5_over, atk5_on, game6_over, atk6_on, game_stop;
    wire [0:63]brom_devil_data; 
    wire [5:0] brom_devil_addr; 
    
     //Using clocking wizard IP from Xilinx IP Catalog
     clk_cmt_5M clk1(.clk_65M(clk_65M),.clk_5M(clk_5M),.clk_100M(clk_100M));
     
     //Simple clock division to get the required frequencies
     clk_div #(.count_div(5000)) clk2(.reset(1'b0),.clk_in(clk_5M),.clk_div(clk_1k));
     clk_div #(.count_div(5)) clk3(.reset(1'b0),.clk_in(clk_1k),.clk_div(clk_200h));
     
     //To avoid switch debouncing
     clk_pulse clp0(.clk_200h(clk_200h),.inp_0(fire_in),.inp_1(1'b0),.inp_pulse(p_fire));
     
     //VGA control module
     vga_ctrl vgac1(.clk_65M(clk_65M),.clear(clear),.V_sync(V_sync),.H_sync(H_sync),.H_count(H_count),.V_count(V_count),.vid_on(vid_on));
     
     //Module that controls the movement of shooter
     shot_2wall shooter(.clk_65M(clk_65M),.brom_ball_data(brom_ball_data), .brom_ball_addr (brom_ball_addr) ,.game_startp(game_start),.brom_count_data(brom_count_data),.brom_count_addr(brom_count_addr),
                        .move_down(move_down),.move_up(move_up),.move_left(move_left),.move_right(move_right),.clear(clear),.game_on(game_on),.H_count(H_count),.V_count(V_count),.vid_on(vid_on),
                        .brom_thumbup_data(brom_thumbup_data),.brom_thumbup_addr(brom_thumbup_addr),.brom_thumb_data(brom_thumb_data),.brom_thumb_addr(brom_thumb_addr),.shooter_ymid(shooter_ymid),.shooter_xmid(shooter_xmid),.VGA_red(VGA_red),.VGA_green(VGA_green),
                        .VGA_blue(VGA_blue),.p_fire(p_fire),.atk1_on(atk1_on),.atk2_on(atk2_on),.atk3_on(atk3_on),.atk4_on(atk4_on),.atk5_on(atk5_on),.atk6_on(atk6_on),.game_stop(game_stop),.game1_over(game1_over),.game2_over(game2_over),
                        .game3_over(game3_over),.game4_over(game4_over),.game5_over(game5_over),.game6_over(game6_over), 
                        .brom_devil_addr(brom_devil_addr), .brom_devil_data(brom_devil_data));  
      
      //Module that controlds attackers in the game
      attacker1  ATK1 (.clk_65M(clk_65M),.H_count(H_count),.V_count(V_count),.vid_on(vid_on),.shooter_ymid(shooter_ymid),.shooter_xmid(shooter_xmid),.game_stop(game_stop),.atk1_on(atk1_on),.game1_over(game1_over));
      attacker2  ATK2 (.clk_65M(clk_65M),.H_count(H_count),.V_count(V_count),.vid_on(vid_on),.shooter_ymid(shooter_ymid),.shooter_xmid(shooter_xmid),.game_stop(game_stop),.atk2_on(atk2_on),.game2_over(game2_over));
      attacker3  ATK3 (.clk_65M(clk_65M),.H_count(H_count),.V_count(V_count),.vid_on(vid_on),.shooter_ymid(shooter_ymid),.shooter_xmid(shooter_xmid),.game_stop(game_stop),.atk3_on(atk3_on),.game3_over(game3_over));
      attacker4  ATK4 (.clk_65M(clk_65M),.H_count(H_count),.V_count(V_count),.vid_on(vid_on),.shooter_ymid(shooter_ymid),.shooter_xmid(shooter_xmid),.game_stop(game_stop),.atk4_on(atk4_on),.game4_over(game4_over));
      attacker5  ATK5 (.clk_65M(clk_65M),.H_count(H_count),.V_count(V_count),.vid_on(vid_on),.shooter_ymid(shooter_ymid),.shooter_xmid(shooter_xmid),.game_stop(game_stop),.atk5_on(atk5_on),.game5_over(game5_over));
      attacker6  ATK6 (.clk_65M(clk_65M),.H_count(H_count),.V_count(V_count),.vid_on(vid_on),.shooter_ymid(shooter_ymid),.shooter_xmid(shooter_xmid),.game_stop(game_stop),.atk6_on(atk6_on),.game6_over(game6_over));

      //Displaying the images from COE file using using Block Memory Generator IP from Xilinx IP Catalog
      blk_mem_ball ball (.clka(clk_65M),.ena(1'b1), .addra(brom_ball_addr), .douta (brom_ball_data)); 
      blk_mem_count ct(.clka(clk_65M),.ena(1'b1),.addra(brom_count_addr),.douta(brom_count_data));
      blk_mem_thumbsdown TD (.clka(clk_65M),.ena(1'b1), .addra(brom_thumb_addr), .douta (brom_thumb_data));
      blk_mem_thumbsup TU (.clka(clk_65M),.ena(1'b1), .addra(brom_thumbup_addr), .douta (brom_thumbup_data));
      blk_mem_ball devilblock (.clka(clk_65M),.ena(1'b1), .addra(brom_devil_addr), .douta (brom_devil_data));
      

endmodule
