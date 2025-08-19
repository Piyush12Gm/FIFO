`timescale 1ns / 1ps
`define wr_clk_period 8   // Write clock = 125 MHz
`define rd_clk_period 14  // Read clock  ≈ 71 MHz

module async_fifo_tb();
    reg wr_clk, rd_clk, rst_n;
    // write inputs
    reg wr_en_i;
    reg [7:0] data_i;
    wire full_o;
    // read inputs
    reg rd_en_i;
    wire [7:0] data_o;
    wire empty_o;
    wire valid, overflow, underflow;

    integer i;

    // DUT instantiation
    async_fifo #(
        .DATA_WIDTH(8),
        .DEPTH(8),
        .ADDRESS_SIZE(4)
    ) DUT (
        .wr_clk(wr_clk),
        .rd_clk(rd_clk),
        .rst_n(rst_n),
        .wr_en_i(wr_en_i),
        .rd_en_i(rd_en_i),
        .data_i(data_i),
        .data_o(data_o),
        .valid(valid),
        .empty_o(empty_o),
        .full_o(full_o),
        .overflow(overflow),
        .underflow(underflow)
    );

    // Clock generation
    initial wr_clk = 1'b1;
    always #(`wr_clk_period/2) wr_clk = ~wr_clk;

    initial rd_clk = 1'b1;
    always #(`rd_clk_period/2) rd_clk = ~rd_clk;

    initial begin
        $dumpfile("async_fifo_tb.vcd");
        $dumpvars(0, async_fifo_tb);
    end

    initial begin
        rst_n = 1'b1;
        wr_en_i = 1'b0;
        rd_en_i = 1'b0;
        data_i  = 8'b0;

        // Reset
        #(`wr_clk_period);
        rst_n = 1'b0;   // assert reset
        #(`wr_clk_period);
        rst_n = 1'b1;   // de-assert reset

        // -------------------------
        // WRITE data into FIFO
        // -------------------------
        wr_en_i = 1'b1;
        rd_en_i = 1'b0;
        for (i = 0; i < 8; i = i + 1) begin
            data_i = i;
            #(`wr_clk_period);
        end
        wr_en_i = 1'b0;

        // -------------------------
        // READ data from FIFO
        // -------------------------
        rd_en_i = 1'b1;
        for (i = 0; i < 8; i = i + 1) begin
            #(`rd_clk_period);
        end
        rd_en_i = 1'b0;

        // -------------------------
        // WRITE again
        // -------------------------
        wr_en_i = 1'b1;
        for (i = 0; i < 8; i = i + 1) begin
            data_i = i + 10;
            #(`wr_clk_period);
        end
        wr_en_i = 1'b0;

        // Small wait
        #(`wr_clk_period*4);

        $finish;
    end

endmodule
