`timescale 1ns / 1ps
// Output a character using RS232 protocol (7N1) and 9600 baud

module serial(
  input clk,
  input rst,
  input [6:0] char, // Character to output
  input send,       // High = request a send
  output reg out,
  output busy
    );
    
assign busy = (state == IDLE) ? 1'b0 : 1'b1;

// Divide 50 MHz by 5208 to get approximately 9600 baud
localparam DIVISOR = 13'd5208;
reg [12:0] counter;

localparam SPACE = 1'b0, MARK = 1'b1;

reg [3:0] state; // Bit counter
localparam IDLE = 4'd0, START = 4'd1, BIT0 = 4'd2, BIT1 = 4'd3,
  BIT2 = 4'd4, BIT3 = 4'd5, BIT4 = 4'd6, BIT5 = 4'd7, BIT6 = 4'd8,
  STOP = 4'd9, GAP = 4'd10, DONE = 4'd11;

reg [6:0] char1;

always @(posedge clk) begin
  if (rst) begin
    state <= IDLE;
    counter <= 0;
  end else if (state == IDLE) begin
    if (send == 1) begin
      state <= START;
      counter <= 0;
      char1 <= char;
    end
  end else if (state == DONE) begin
    // DONE is just one clock to trigger the done signal
    state <= IDLE;
  end else begin
    if (counter < DIVISOR) begin
      // Keep counting to the end of the bit time
       counter <= counter + 1'b1;
    end else begin
      // End of bit time. Reset counter and move to next state.
      counter <= 0;
      state <= state + 1'b1;
    end
  end
end

// Output value depending on state
always @(*) begin
  case (state)
    IDLE: out = MARK;
    START: out = SPACE;
    BIT0: out = char1[0];
    BIT1: out = char1[1];
    BIT2: out = char1[2];
    BIT3: out = char1[3];
    BIT4: out = char1[4];
    BIT5: out = char1[5];
    BIT6: out = char1[6];
    STOP: out = SPACE;
    GAP: out = MARK;
    default: out = MARK;
  endcase
end

assign busy = (state == IDLE) ? 1'b0 : 1'b1;

endmodule
