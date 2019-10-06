`timescale 1ns / 1ps

module clk_div
#(parameter count_div=10000)
(
    input reset,
    input clk_in,
    output clk_div
    );
    reg[20:0] count_next,count_reg;
    always@(posedge clk_in)
        if(reset==1'b1)
            count_reg<=0;
        else
            count_reg<=count_next;
    always@(*) begin
        count_next=count_reg;
        if(count_reg==count_div-1)
            count_next=0;
        else
            count_next=count_reg+1;
        end
    assign clk_div=(count_reg==count_div-1);
endmodule
