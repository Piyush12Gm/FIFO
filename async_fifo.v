module async_fifo #( 
    parameter DATA_WIDTH = 8,
    parameter DEPTH = 8,
    parameter ADDRESS_SIZE = 4
)(
    input wr_clk,
    input rd_clk,
    input rst_n,
    input wr_en_i,
    input rd_en_i,
    input [DATA_WIDTH-1:0] data_i,
    output reg [DATA_WIDTH-1:0] data_o,
    output reg valid,
    output empty_o,
    output full_o,
    output reg overflow,
    output reg underflow
);

    reg [ADDRESS_SIZE-1:0] wr_ptr, wr_ptr_g_s1, wr_ptr_g_s2;
    reg [ADDRESS_SIZE-1:0] rd_ptr, rd_ptr_g_s1, rd_ptr_g_s2;
    wire [ADDRESS_SIZE-1:0] wr_ptr_g;
    wire [ADDRESS_SIZE-1:0] rd_ptr_g;

    reg [DATA_WIDTH-1:0] mem [DEPTH-1:0];
    
    // Write logic
    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr <= 'b0;
            overflow <= 1'b0;
        end else begin
            if (wr_en_i && !full_o) begin
                mem[wr_ptr[ADDRESS_SIZE-2:0]] <= data_i;
                wr_ptr <= wr_ptr + 1;
            end else if (wr_en_i && full_o) begin
                overflow <= 1'b1;
            end
        end    
    end

    // Read logic
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr <= 'b0;
            data_o <= 'b0;
            valid <= 1'b0;
            underflow <= 1'b0;
        end else begin
            if (rd_en_i && !empty_o) begin
                data_o <= mem[rd_ptr[ADDRESS_SIZE-2:0]];
                rd_ptr <= rd_ptr + 1;
                valid <= 1'b1;
            end else if (rd_en_i && empty_o) begin
                underflow <= 1'b1;
                valid <= 1'b0;
            end else begin
                valid <= 1'b0;
            end
        end    
    end

    // Binary → Gray conversion
    assign wr_ptr_g = wr_ptr ^ (wr_ptr >> 1);
    assign rd_ptr_g = rd_ptr ^ (rd_ptr >> 1);

    // Synchronizers
    always @(posedge rd_clk or negedge rst_n) begin
        if (!rst_n) begin
            wr_ptr_g_s1 <= 'b0;
            wr_ptr_g_s2 <= 'b0;
        end else begin
            wr_ptr_g_s1 <= wr_ptr_g;
            wr_ptr_g_s2 <= wr_ptr_g_s1;
        end    
    end

    always @(posedge wr_clk or negedge rst_n) begin
        if (!rst_n) begin
            rd_ptr_g_s1 <= 'b0;
            rd_ptr_g_s2 <= 'b0;
        end else begin
            rd_ptr_g_s1 <= rd_ptr_g;
            rd_ptr_g_s2 <= rd_ptr_g_s1;
        end    
    end

    // Empty condition
    assign empty_o = (rd_ptr_g == wr_ptr_g_s2);

    // Full condition (standard async FIFO formula)
    assign full_o = (wr_ptr_g == {~rd_ptr_g_s2[ADDRESS_SIZE-1:ADDRESS_SIZE-2],
                                  rd_ptr_g_s2[ADDRESS_SIZE-3:0]});

endmodule
