module synchronous_fifo(clk,reset_i,full_o,data_i,wr_en_i,empty_o,data_o,rd_en_i);
  input clk,reset_i,wr_en_i,rd_en_i;
  output full_o,empty_o;
  input [2:0] data_i;
  output reg [2:0] data_o;
  parameter depth = 8;
  
  reg [2:0] mem [0 : depth-1];
  reg [2:0] wrt_ptr,rd_ptr;
  reg [3:0] count ;
  
  assign empty_o = (count == 0)? 1 : 0;
  assign full_o = (count == depth)? 1 : 0;
  
  // for writing
  always @(posedge clk,negedge reset_i)
  begin
      if(!reset_i)
      begin
      wrt_ptr <= 0;
      end
      else
      begin
          if(wr_en_i)
          begin
              mem[wrt_ptr] <= data_i; 
              wrt_ptr <= wrt_ptr + 1;
          end
      end
  end
  
  // for reading 
  always @(posedge clk,negedge reset_i)
  begin
      if(!reset_i)
      begin
      rd_ptr <= 0;
      end
      else
      begin
          if(rd_en_i)
          begin
              data_o <= mem[rd_ptr]; 
              rd_ptr <= rd_ptr + 1;
          end
      end
  end
  
  // for counting
  always @(posedge clk, negedge reset_i)
  begin
      if(!reset_i)
      begin
          count <= 0;
      end
      else
      begin
          if(rd_en_i)
          begin
              if(wr_en_i)
              begin
              count <= count + 0;
              end
              else
              begin
              count = count - 1;
              end
          end
          else
          begin
               if(wr_en_i)
               begin
                  count <= count + 1;
               end
               else
               begin
                  count <= count + 0;
               end
          end
      end
  end
endmodule
