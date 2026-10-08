`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.10.2026 19:28:15
// Design Name: 
// Module Name: tb_digital_sequence_recognizer
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


`timescale 1ns / 1ps

module tb_digital_sequence_recognizer;

    reg        clk;
    reg        reset;
    reg        serial_in;
    reg  [3:0] config_target;
    wire [1:0] visual_status;
    wire [2:0] match_count;

    // Instantiate Unit Under Test (UUT)
    digital_sequence_recognizer uut (
        .clk(clk),
        .reset(reset),
        .serial_in(serial_in),
        .config_target(config_target),
        .visual_status(visual_status),
        .match_count(match_count)
    );

    // 100 MHz Clock Generator (10ns clock period)
    always #5 clk = ~clk;

    initial begin
        // Initialize inputs
        clk           = 0;
        reset         = 1;
        serial_in     = 0;
        config_target = 4'b1011; // Set Target Sequence to 1011

        // Release Reset
        #20 reset = 0;

        // Feed serial sequence: 1 -> 0 -> 1 -> 1
        #10 serial_in = 1;
        #10 serial_in = 0;
        #10 serial_in = 1;
        #10 serial_in = 1; // Full Match expected here

        // Break pattern
        #10 serial_in = 0; // Error expected here

        #20 $finish;
    end

endmodule