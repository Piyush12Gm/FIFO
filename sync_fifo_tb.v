`timescale 1ns / 1ps
`define clk_period 8

module sync_fifo_tb();
    reg clk,rst_n;
    // write data inputs
    reg wr_en_i;
    reg [7:0]data_i;
    wire full_o;
    // read data inputs
    reg rd_en_i;
    wire [7:0]data_o;
    wire empty_o;
    integer i;

    sync_fifo DUT(
        .clk(clk),
        .rst_n(rst_n),
        .wr_en_i(wr_en_i),
        .data_i(data_i),
        .full_o(full_o),
        .rd_en_i(rd_en_i),
        .data_o(data_o),
        .empty_o(empty_o)
    );

    initial clk = 1'b1;
    always #(`clk_period/2) clk = ~clk;

    initial begin
        $dumpfile("wave_fifo.vcd");
        $dumpvars(0, sync_fifo_tb);
    end

    initial begin
        rst_n = 1'b1;

        wr_en_i = 1'b0;
        rd_en_i = 1'b0;

        data_i = 8'b0;

        #(`clk_period);
        rst_n = 1'b0;    // reset system

        #(`clk_period);
        rst_n = 1'b1;    // finish reset 

       //  write data
        wr_en_i = 1'b1;
        rd_en_i = 1'b0;

        for( i = 0; i< 8; i = i+1)begin
            data_i = i;
            #(`clk_period);
        end

        //  read data
        wr_en_i = 1'b0;
        rd_en_i = 1'b1;

        for( i = 0; i< 8; i = i+1)begin
            #(`clk_period);
        end

        //  write data
        wr_en_i = 1'b1;
        rd_en_i = 1'b0;

        for( i = 0; i< 8; i = i+1)begin
            data_i = i;
            #(`clk_period);
        end

        #(`clk_period);
        #(`clk_period);
        #(`clk_period);

        $finish;

    end

endmodule
