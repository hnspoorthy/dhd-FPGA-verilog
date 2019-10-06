`timescale 1ns / 1ps
module clk_pulse(
    input clk_200h,
    input inp_0,
    input inp_1,
    output inp_pulse
    );
    wire inp_comp;
    reg FF1_reg,FF2_reg,FF3_reg;
    reg FF1_next,FF2_next,FF3_next;
    assign inp_comp=inp_0|inp_1;
    always@(posedge clk_200h)
        begin
        FF1_reg<=FF1_next;
        FF2_reg<=FF2_next;
        FF3_reg<=FF3_next; 
        end
    always@(*)begin
        FF1_next=inp_comp;
    end
    always@(*)begin
        FF2_next=FF1_reg;
    end
    always@(*)begin
        FF3_next=FF2_reg;
    end
    assign inp_pulse=FF1_reg & FF2_reg & ~ FF3_reg;
           
endmodule

