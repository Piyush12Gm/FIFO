`timescale 1ns / 1ps
module tb();
parameter depth = 8;
reg clk,rst_n;
reg wr_en_i,rd_en_i;
reg [2:0] data_i;
wire [2:0] data_o;
wire full_o,empty_o;

synchronous_fifo dut (.clk(clk),.reset_i(rst_n),.wr_en_i(wr_en_i),.data_i(data_i),.full_o(full_o),.rd_en_i(rd_en_i),.data_o(data_o),.empty_o(empty_o));
    initial 
        clk = 1'b1;
    always #5 clk=~clk;
    integer i;
    initial
        begin
            rst_n = 1'b1;
            wr_en_i = 1'b0;
            rd_en_i = 1'b0;
            data_i = 8'b0;
            
            #10 rst_n = 1'b0;
            #10 rst_n = 1'b1;
 //write enable           
            wr_en_i = 1'b1;
            rd_en_i = 1'b0;
            for(i=0;i<8;i=i+1)
                begin
                    data_i = i;
                    #10;
                end
                
  //read enable
            wr_en_i = 1'b0;
            rd_en_i = 1'b1;
            for(i=0;i<8;i=i+1)
                begin
                    
                    #10;
                end
 //write enable
              wr_en_i = 1'b1;
                         rd_en_i = 1'b0;
                         for(i=0;i<8;i=i+1)
                             begin
                                 data_i = i;
                                 #10;
                             end
 //read enable
                         wr_en_i = 1'b0;
                         rd_en_i = 1'b1;
                         for(i=0;i<8;i=i+1)
                             begin
                                 
                                 #10;
                             end
            #10;
            #10;
            #10;
            $stop;
        end
endmodule
