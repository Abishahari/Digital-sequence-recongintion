`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08.10.2026 19:26:20
// Design Name: 
// Module Name: digital_sequence_recognizer
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

module digital_sequence_recognizer (
    input  wire       clk,
    input  wire       reset,
    input  wire       serial_in,
    input  wire [3:0] config_target,
    output reg  [1:0] visual_status,
    output reg  [2:0] match_count
);

    reg [3:0] shift_reg;
    wire [3:0] next_shift = {shift_reg[2:0], serial_in};

    // State Encoding: 00=Idle, 01=Tracking, 10=Match, 11=Error
    localparam IDLE     = 2'b00;
    localparam TRACKING = 2'b01;
    localparam MATCH    = 2'b10;
    localparam ERROR    = 2'b11;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            shift_reg     <= 4'b0000;
            visual_status <= IDLE;
            match_count   <= 3'd0;
        end else begin
            shift_reg <= next_shift;

            // Prefix matching logic
            if (next_shift == config_target) begin
                visual_status <= MATCH;        // 4-bit Full Match
                match_count   <= 3'd4;
            end else if (next_shift[2:0] == config_target[3:1]) begin
                visual_status <= TRACKING;     // 3-bit Prefix Match
                match_count   <= 3'd3;
            end else if (next_shift[1:0] == config_target[3:2]) begin
                visual_status <= TRACKING;     // 2-bit Prefix Match
                match_count   <= 3'd2;
            end else if (next_shift[0] == config_target[3]) begin
                visual_status <= TRACKING;     // 1-bit Prefix Match
                match_count   <= 3'd1;
            end else begin
                visual_status <= ERROR;        // Pattern Broken
                match_count   <= 3'd0;
            end
        end
    end

endmodule

