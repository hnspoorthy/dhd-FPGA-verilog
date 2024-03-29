## This file is a general .xdc for the Basys3 rev B board
## To use it in a project:
## - uncomment the lines corresponding to used pins
## - rename the used ports (in each line, after get_ports) according to the top level signal names in the project

## Clock signal
set_property PACKAGE_PIN W5 [get_ports clk_100M]							
	set_property IOSTANDARD LVCMOS33 [get_ports clk_100M]
	#create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clk]
 
## Switches
set_property PACKAGE_PIN V17 [get_ports {game_start}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {game_start}]
#set_property PACKAGE_PIN V16 [get_ports {move_left}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {move_left}]
#set_property PACKAGE_PIN W16 [get_ports {move_right}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {move_right}]
#set_property PACKAGE_PIN W17 [get_ports {move_up}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {move_up}]
#set_property PACKAGE_PIN W15 [get_ports {move_down}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {move_down}]
#set_property PACKAGE_PIN V15 [get_ports {sw[5]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[5]}]
#set_property PACKAGE_PIN W14 [get_ports {sw[6]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[6]}]
#set_property PACKAGE_PIN W13 [get_ports {sw[7]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[7]}]
#set_property PACKAGE_PIN V2 [get_ports {sw[8]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[8]}]
#set_property PACKAGE_PIN T3 [get_ports {sw[9]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[9]}]
#set_property PACKAGE_PIN T2 [get_ports {sw[10]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[10]}]
#set_property PACKAGE_PIN R3 [get_ports {sw[11]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[11]}]
#set_property PACKAGE_PIN W2 [get_ports {sw[12]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[12]}]
#set_property PACKAGE_PIN U1 [get_ports {sw[13]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {sw[13]}]
set_property PACKAGE_PIN T1 [get_ports clear]					
	set_property IOSTANDARD LVCMOS33 [get_ports clear]
set_property PACKAGE_PIN R2 [get_ports {game_on}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {game_on}]
 

## LEDs
#set_property PACKAGE_PIN U16 [get_ports {led[0]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[0]}]
#set_property PACKAGE_PIN E19 [get_ports {led[1]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[1]}]
#set_property PACKAGE_PIN U19 [get_ports {led[2]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[2]}]
#set_property PACKAGE_PIN V19 [get_ports {led[3]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[3]}]
#set_property PACKAGE_PIN W18 [get_ports {led[4]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[4]}]
#set_property PACKAGE_PIN U15 [get_ports {led[5]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[5]}]
#set_property PACKAGE_PIN U14 [get_ports {led[6]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[6]}]
#set_property PACKAGE_PIN V14 [get_ports {led[7]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[7]}]
#set_property PACKAGE_PIN V13 [get_ports {led[8]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[8]}]
#set_property PACKAGE_PIN V3 [get_ports {led[9]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[9]}]
#set_property PACKAGE_PIN W3 [get_ports {led[10]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[10]}]
#set_property PACKAGE_PIN U3 [get_ports {led[11]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[11]}]
#set_property PACKAGE_PIN P3 [get_ports {led[12]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[12]}]
#set_property PACKAGE_PIN N3 [get_ports {led[13]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[13]}]
#set_property PACKAGE_PIN P1 [get_ports {led[14]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[14]}]
#set_property PACKAGE_PIN L1 [get_ports {led[15]}]					
	#set_property IOSTANDARD LVCMOS33 [get_ports {led[15]}]
	
	
##7 segment display
#set_property PACKAGE_PIN W7 [get_ports {ssd_cathode[7]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {ssd_cathode[7]}]
#set_property PACKAGE_PIN W6 [get_ports {ssd_cathode[6]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {ssd_cathode[6]}]
#set_property PACKAGE_PIN U8 [get_ports {ssd_cathode[5]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {ssd_cathode[5]}]
#set_property PACKAGE_PIN V8 [get_ports {ssd_cathode[4]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {ssd_cathode[4]}]
#set_property PACKAGE_PIN U5 [get_ports {ssd_cathode[3]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {ssd_cathode[3]}]
#set_property PACKAGE_PIN V5 [get_ports {ssd_cathode[2]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {ssd_cathode[2]}]
#set_property PACKAGE_PIN U7 [get_ports {ssd_cathode[1]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {ssd_cathode[1]}]

#set_property PACKAGE_PIN V7 [get_ports {ssd_cathode[0]}]							
#	set_property IOSTANDARD LVCMOS33 [get_ports {ssd_cathode[0]}]

#set_property PACKAGE_PIN U2 [get_ports {ssd_anode[0]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {ssd_anode[0]}]
#set_property PACKAGE_PIN U4 [get_ports {ssd_anode[1]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {ssd_anode[1]}]
#set_property PACKAGE_PIN V4 [get_ports {ssd_anode[2]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {ssd_anode[2]}]
#set_property PACKAGE_PIN W4 [get_ports {ssd_anode[3]}]					
#	set_property IOSTANDARD LVCMOS33 [get_ports {ssd_anode[3]}]


##Buttons
set_property PACKAGE_PIN U18 [get_ports fire_in]						
	set_property IOSTANDARD LVCMOS33 [get_ports fire_in]
set_property PACKAGE_PIN T18 [get_ports move_up]						
	set_property IOSTANDARD LVCMOS33 [get_ports move_up]
set_property PACKAGE_PIN W19 [get_ports move_left]						
	set_property IOSTANDARD LVCMOS33 [get_ports move_left]
set_property PACKAGE_PIN T17 [get_ports move_right]						
	set_property IOSTANDARD LVCMOS33 [get_ports move_right]
set_property PACKAGE_PIN U17 [get_ports move_down]						
	set_property IOSTANDARD LVCMOS33 [get_ports move_down]
 

#VGA Connector
set_property PACKAGE_PIN G19 [get_ports {VGA_red[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {VGA_red[0]}]
set_property PACKAGE_PIN H19 [get_ports {VGA_red[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {VGA_red[1]}]
set_property PACKAGE_PIN J19 [get_ports {VGA_red[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {VGA_red[2]}]
set_property PACKAGE_PIN N19 [get_ports {VGA_red[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {VGA_red[3]}]
set_property PACKAGE_PIN N18 [get_ports {VGA_blue[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {VGA_blue[0]}]
set_property PACKAGE_PIN L18 [get_ports {VGA_blue[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {VGA_blue[1]}]
set_property PACKAGE_PIN K18 [get_ports {VGA_blue[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {VGA_blue[2]}]
set_property PACKAGE_PIN J18 [get_ports {VGA_blue[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {VGA_blue[3]}]
set_property PACKAGE_PIN J17 [get_ports {VGA_green[0]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {VGA_green[0]}]
set_property PACKAGE_PIN H17 [get_ports {VGA_green[1]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {VGA_green[1]}]
set_property PACKAGE_PIN G17 [get_ports {VGA_green[2]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {VGA_green[2]}]
set_property PACKAGE_PIN D17 [get_ports {VGA_green[3]}]				
	set_property IOSTANDARD LVCMOS33 [get_ports {VGA_green[3]}]
set_property PACKAGE_PIN P19 [get_ports H_sync]						
	set_property IOSTANDARD LVCMOS33 [get_ports H_sync]
set_property PACKAGE_PIN R19 [get_ports V_sync]						
	set_property IOSTANDARD LVCMOS33 [get_ports V_sync]


##USB-RS232 Interface
#set_property PACKAGE_PIN B18 [get_ports RsRx]						
	#set_property IOSTANDARD LVCMOS33 [get_ports RsRx]
#set_property PACKAGE_PIN A18 [get_ports RsTx]						
	#set_property IOSTANDARD LVCMOS33 [get_ports RsTx]


##USB HID (PS/2)
#set_property PACKAGE_PIN C17 [get_ports PS2Clk]						
	#set_property IOSTANDARD LVCMOS33 [get_ports PS2Clk]
	#set_property PULLUP true [get_ports PS2Clk]
#set_property PACKAGE_PIN B17 [get_ports PS2Data]					
	#set_property IOSTANDARD LVCMOS33 [get_ports PS2Data]	
	#set_property PULLUP true [get_ports PS2Data]