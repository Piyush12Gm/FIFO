module sync_fifo
    (
    input clk,
    input rst_n,
    // write data inputs
    input wr_en_i,
    input [7:0]data_i,
    output full_o,
    // read data inputs
    input rd_en_i,
    output reg [7:0]data_o,
    output empty_o );

    parameter DEPTH = 8;
    reg [7:0]mem [0:DEPTH-1];
    reg [2:0]wr_ptr;   // Because wr_ptr go from 0(000) to 7(111)
    reg [2:0] rd_ptr;  // Because rd_ptr go from  0(000) to 7(111)
    reg [3:0]count;    // min = 0(0000) and max = 8(1000)

    // assign full_o  = (count == DEPTH) ? 1 : 0;
    assign full_o  = (count == DEPTH);
    assign empty_o = (count == 0);

    //Handle the write process
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            wr_ptr <= 3'd0;
        end
        else begin
            if(wr_en_i && !full_o)begin
                mem[wr_ptr] <= data_i;
                wr_ptr <= wr_ptr + 1;
            end
        end
    end


    //Handle the Read process
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            rd_ptr <= 3'd0;
        end
        else begin
            if(rd_en_i && !empty_o)begin
                data_o <= mem[rd_ptr];
                rd_ptr <= rd_ptr + 1;
            end
        end
    end


    //Handle the count value
    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)begin
            count <= 4'd0;
        end
        else begin
            case({(wr_en_i && !full_o), (rd_en_i && !empty_o)})
            2'b10: count <= count + 1;
            2'b01: count <= count - 1;
            2'b11: count <= count;
            2'b00: count <= count;
            default: count <= count;
            endcase
        end
    end

endmodule

```
c:\Users\anura\OneDrive\Pictures\Screenshots\Screenshot 2025-08-19 000433.png
