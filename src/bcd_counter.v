`timescale 1ns / 1ps
// 3-digit BCD counter
// Start at 1

module bcd_counter(
  input clk,
  input rst,
  input increment,   // Set to 1 for a clock to increment counter
  output reg [3:0] digit2,
  output reg [3:0] digit1,
  output reg [3:0] digit0
    );
          
  always @(posedge clk) begin
    if (rst) begin
      digit2 <= 4'b0;
      digit1 <= 4'b0;
      digit0 <= 4'b0;
    end else if (increment) begin
      if (digit0 != 4'd9) begin
        // Regular increment digit 0
        digit0 <= digit0 + 1'b1;
      end else begin
        // Carry from digit 0
        digit0 <= 4'd0;
        if (digit1 != 4'd9) begin
          // Regular increment digit 1
            digit1 <= digit1 + 1'b1;
        end else begin
          // Carry from digit 1
          digit1 <= 4'd0;
          digit2 <= digit2 + 1'b1;
        end
      end
    end
  end


endmodule
