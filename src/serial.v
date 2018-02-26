`timescale 1ns / 1ps
// Serial output module.
// Output a character using RS232 protocol (8N1) and 9600 baud
// Ken Shirriff  http://righto.com

module serial(
  input clk,
  input rst,
  input [7:0] char, // Character to output
  input send,       // High = request a send
  output reg out,   // Output pin
  output busy       // High while character is being output
);
    
// Busy while not in IDLE state
assign busy = (state == IDLE) ? 1'b0 : 1'b1;

// Divide 50 MHz by 5208 to get approximately 9600 baud
localparam DIVISOR = 13'd5208;
reg [12:0] counter;

localparam SPACE = 1'b0, MARK = 1'b1;

reg [3:0] state; // Bit counter
localparam IDLE = 4'd0, START = 4'd1, BIT0 = 4'd2, BIT1 = 4'd3,
  BIT2 = 4'd4, BIT3 = 4'd5, BIT4 = 4'd6, BIT5 = 4'd7, BIT6 = 4'd8,
  BIT7 = 4'd9, STOP = 4'd10;

reg [7:0] char1;

always @(posedge clk) begin
  if (rst) begin
    state <= IDLE;
    counter <= 0;
  end else if (state == IDLE) begin
    // Wait for a send request
    if (send == 1) begin
      state <= START;
      counter <= 0;
      char1 <= char;
    end
  end else begin
    if (counter < DIVISOR - 1) begin
      // Keep counting to the end of the bit time
      counter <= counter + 1'b1;
    end else begin
      // End of bit time. Reset counter and move to next state.
      counter <= 0;
		  if (state != STOP) begin
        state <= state + 1'b1;
      end else begin
        state <= IDLE;
      end
    end
  end
end

// Output the appropriate level depending on state
always @(*) begin
  case (state)
    IDLE: out = MARK; // Stop bit is also IDLE
    START: out = SPACE;
    BIT0: out = char1[0];
    BIT1: out = char1[1];
    BIT2: out = char1[2];
    BIT3: out = char1[3];
    BIT4: out = char1[4];
    BIT5: out = char1[5];
    BIT6: out = char1[6];
	  BIT7: out = char1[7];
    default: out = MARK;
  endcase
end

endmodule
