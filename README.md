# dhd

Game_Details.pdf contains the details of the game, user controls and features of the game.
bb.xdc file contains the contraint file for Xilinx Basys 3 board.

top_breakingbrick.v : Top module for the game
clk_div.v           : Simple clock division module
clk_pulse.v         : Module to avoid switch debouncing
vga_ctrl.v          : VGA control module
shot_2wall.v        : Module that controls the movement of shooter
attacker(n).v       : Module that controlds attacker(n) in the game
