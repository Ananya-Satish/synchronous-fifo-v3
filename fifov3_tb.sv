`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2026 17:51:04
// Design Name: 
// Module Name: fifov3_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module fifov3_tb;
parameter DEPTH = 8;
parameter WIDTH = 8;
logic [WIDTH-1:0] data_in;
logic clk;
logic reset;
logic wr_valid;
logic wr_ready;
logic rd_ready;
logic rd_valid;
logic [WIDTH-1:0] data_out;
logic full;
logic empty;

fifov3 #(
    .DEPTH(DEPTH),
    .WIDTH(WIDTH)
) dut (
    .data_in(data_in),
    .clk(clk),
    .reset(reset),
    .wr_valid(wr_valid),
    .wr_ready(wr_ready),
    .rd_ready(rd_ready),
    .rd_valid(rd_valid),
    .data_out(data_out),
    .full(full),
    .empty(empty)
);

always #5 clk = ~clk;

initial
begin

    clk = 0;
    reset = 1;
    wr_valid = 0;
    rd_ready = 0;
    data_in = 0;

    #20;
    reset = 0;

   @(negedge clk);
    data_in  = 8'hAA;
    wr_valid = 1;
    
    @(posedge clk);

    @(negedge clk);
    data_in  = 8'hBB;

    @(posedge clk);

    @(negedge clk);
    data_in  = 8'hCC;

    @(posedge clk);

    @(negedge clk);
    wr_valid = 0;
    
    @(posedge clk);
    wr_valid = 0;
    rd_ready = 0;

    repeat(3)
        @(posedge clk);

    rd_ready = 1;

    repeat(3)
        @(posedge clk);
    rd_ready = 0;

    $display("\n--- Filling FIFO ---");

    wr_valid = 1;

    for(int i=0;i<DEPTH;i++)
    begin
        @(negedge clk);
        data_in = i;
    end

    wr_valid = 0;

    @(posedge clk);

    $display("\n--- FIFO FULL ---");
    $display("wr_ready = %0b", wr_ready);

    @(posedge clk);

    rd_ready = 1;
    wr_valid = 1;
    data_in  = 8'h55;

    @(posedge clk);

    wr_valid = 0;
    rd_ready = 0;

    rd_ready = 1;

    repeat(DEPTH)
        @(posedge clk);

    rd_ready = 0;

    #20;
    $finish;

end

endmodule
