`timescale 1ns / 1ps
module async_fifo_tb();
  parameter data_width = 6, depth = 16;
  parameter address_width = 4;
  reg write_clk,read_clk,reset,read_enable,write_enable;
  wire empty,full;
  wire overflow,underflow,valid;
  reg [data_width-1 : 0] write_data;
  wire [data_width-1 : 0] read_data;
  async_fifo DUT(write_clk,read_clk,reset,write_data,read_data,read_enable,write_enable,valid,full,empty,overflow,underflow);
  initial
  begin
  write_clk = 1'b0;
  read_clk = 1'b0;
  read_enable = 1'b0;
  write_enable = 1'b0;
  reset = 1'b1;
  #25 reset = 1'b0;
  
  end
  integer i;
  always #5 write_clk = ~write_clk;
  always #10 read_clk  = ~read_clk;
  
  //writing the data;
  initial
  begin
  #25 write_enable = 1'b1;
      read_enable = 1'b0;
      for (i=0;i<depth;i=i+1)
      begin
          write_data = i;
          #10 ;
      end
   // reading the data;
      read_enable =1'b1;
      write_enable = 1'b0;
      for (i=0;i<depth;i=i+1)
      begin
          #10 ;
      end
      
   #30 $finish;
  end
endmodule
