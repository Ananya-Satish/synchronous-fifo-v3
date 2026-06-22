`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 22.06.2026 17:40:22
// Design Name: 
// Module Name: fifov3
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


module fifov3 #(parameter DEPTH = 8,parameter WIDTH = 8)(
    input  logic [WIDTH-1:0] data_in,
    input  logic clk,
    input  logic reset,
    input  logic wr_valid,
    output logic wr_ready,
    input  logic rd_ready,
    output logic rd_valid,
    output logic [WIDTH-1:0] data_out,
    output logic full,
    output logic empty);
    
logic [WIDTH-1:0] mem [0:DEPTH-1];
localparam PTR_WIDTH = $clog2(DEPTH);
logic [PTR_WIDTH-1:0] wr_ptr;
logic [PTR_WIDTH-1:0] rd_ptr;
logic [PTR_WIDTH:0]   count;
logic write_fire;
logic read_fire;

assign full  = (count == DEPTH);
assign empty = (count == 0);

assign wr_ready = !full;
assign rd_valid = !empty;

assign write_fire = wr_valid && wr_ready;
assign read_fire  = rd_valid && rd_ready;

always_ff @(posedge clk)
begin
    if(reset)
    begin
        wr_ptr   <= 0;
        rd_ptr   <= 0;
        count    <= 0;
        data_out <= 0;
    end

    else
    begin
        if(write_fire)
        begin
            mem[wr_ptr] <= data_in;
            wr_ptr <= wr_ptr + 1;
        end

        if(read_fire)
        begin
            data_out <= mem[rd_ptr];
            $display("Reading mem[%0d] = %h", rd_ptr, mem[rd_ptr]);
            rd_ptr <= rd_ptr + 1;
        end

        if(write_fire && !read_fire)
            count <= count + 1;
        else if(read_fire && !write_fire)
            count <= count - 1;
            
             $display("T=%0t count=%0d wr_ptr=%0d rd_ptr=%0d write=%0b read=%0b data_in=%h data_out=%h",
                 $time, count, wr_ptr, rd_ptr,
                 write_fire, read_fire,
                 data_in, data_out);

    end
end

endmodule
