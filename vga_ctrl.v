`timescale 1ns / 1ps
module vga_ctrl(
    input clk_65M,
    input clear,
    output reg V_sync,
    output reg H_sync,
    output [16:0] H_count,
    output [16:0] V_count,
    output reg vid_on
    );
   parameter HPIXELS =1344;
       parameter VLINES = 806;
       parameter HBP = 296;
       parameter HFP = 1320;
       parameter VBP = 35;
       parameter VFP = 803;
       parameter HSP = 136;
       parameter VSP = 6;
     
    reg [16:0] H_count_reg, H_count_next;
   
    always@(posedge clk_65M)
    begin
    if(clear==1'b1)
        H_count_reg<=17'd0;
    else
        H_count_reg<=H_count_next;
    end
    
    always@(*)
            begin
            H_count_next=H_count_reg;
            if(H_count_reg == HPIXELS - 1)
                H_count_next=17'd0;
            else
                H_count_next=H_count_reg+1;
            end
            
    assign H_count= H_count_reg;
    
    always@(*)
            begin
            if(H_count_reg<HSP)
                H_sync=1'b0;
            else
                H_sync=1'b1;
            end    
    
    reg V_count_en;
        always@(*)
        begin
        if(H_count_reg==HPIXELS-1)
            V_count_en<=1'b1;
        else
            V_count_en<=1'b0;
        end
   
   // code for V_count_next 
   reg [16:0] V_count_reg, V_count_next;
   always@(posedge clk_65M)
                begin
                if(clear==1'b1)
                    V_count_reg<=17'd0;
                else
                    V_count_reg<=V_count_next;
                end
                
                            
    always@(*)
    begin
    V_count_next=V_count_reg;
    if(V_count_en==1'b1)
        if(V_count_reg == VLINES-1)
            V_count_next=17'd0;
        else
            V_count_next=V_count_reg + 1;
    end
    
    assign V_count= V_count_reg;
    
    always@(*)
    begin
    if(V_count_reg<VSP)
        V_sync=1'b0;
    else
        V_sync=1'b1;
    end
    
    always@(*)
    begin
    if((H_count_reg>HBP) && (H_count_reg<HFP) && (V_count_reg > VBP) && (V_count_reg<VFP))
        vid_on=1'b1;
    else
        vid_on=1'b0;
    end
   
endmodule
