module async_fifo(write_clk,read_clk,reset,write_data,read_data,read_enable,write_enable,valid,full,empty,overflow,underflow);
  parameter data_width = 6, depth = 16;
  // as for the depth of 16  we need 4 address bus width but for asynchrnous we need width of 1 extra
  parameter address_width = 4;
  input write_clk,read_clk,reset,read_enable,write_enable;
  output empty,full;
  output reg overflow,underflow,valid;
  input [data_width-1 : 0] write_data;
  output reg [data_width-1 : 0] read_data;
  
  reg [address_width : 0] write_ptr, read_ptr;
  
  reg [data_width-1 : 0] fifo_mem[depth-1 : 0];
  
  reg [data_width-1 : 0] write_ptr_gray_s1,write_ptr_gray_s2,read_ptr_gray_s1,read_ptr_gray_s2;
  
  // writing data into fifo
  always @(posedge write_clk)
  begin
      if(reset)
      begin
          write_ptr <= 0;
      end
      else 
      begin
          if(write_enable && !full)
          begin
              fifo_mem[write_ptr] <= write_data;
              write_ptr <= write_ptr + 1;
          end
      end
  end 
  
  // reading data from fifo
  always @(posedge read_clk)
  begin
      if(reset)
      begin
          read_ptr <= 0;
      end
      else 
      begin
          if(read_enable && !empty)
          begin
              read_data <= fifo_mem[read_ptr];
              read_ptr <= read_ptr + 1;
          end
      end
  end 
  
  // to determine the empty and full we need to convert the wrt_ptr and read_ptr into the gray code;
  // doing xor with the original and right_shifted of it
  
  wire [address_width : 0] read_ptr_gray , write_ptr_gray;
  assign read_ptr_gray = read_ptr ^ (read_ptr >> 1);
  assign write_ptr_gray = write_ptr ^ (write_ptr >> 1);
  
  
  
  // 2 stage synchronizer for wr_pointer wrt to read_clk;
  always @(posedge read_clk)
  begin
      if(reset)
      begin
          write_ptr_gray_s1 <= 0;
          write_ptr_gray_s2 <= 0;
      end
      else
      begin
          write_ptr_gray_s1 <= write_ptr_gray;
          write_ptr_gray_s2 <= write_ptr_gray_s1;
      end
  
  end
  
  
  // 2 stage synchronizer for read_pointer wrt to write_clk;
  always @(posedge write_clk)
  begin
      if(reset)
      begin
          read_ptr_gray_s1 <= 0;
          read_ptr_gray_s2 <= 0;
      end
      else
      begin
          read_ptr_gray_s1 <= read_ptr_gray;
          read_ptr_gray_s2 <= read_ptr_gray_s1;
      end
  
  end
  
  // empty and full condition
  // here we are checking for the gray right. 
  // so we need to check first two msb bits of read and write ptr because in binary to gray code the effect of msb will be in first two msb positions of gray code
  
  assign empty = (write_ptr_gray_s2 == read_ptr_gray);
  assign full = (write_ptr_gray[address_width-1]!= read_ptr_gray_s2[address_width-1]) && 
                (write_ptr_gray[address_width-2]!= read_ptr_gray_s2[address_width-2]) &&
                (write_ptr_gray[address_width-3:0] == read_ptr_gray_s2[address_width-3 : 0]);
                
  // full and empty conditions
  always @(posedge write_clk) overflow <= write_enable && full; 
  always @(posedge read_clk) 
  begin
      overflow <= read_enable && empty;
      valid <= (read_enable && (!empty));
  end
  
endmodule
