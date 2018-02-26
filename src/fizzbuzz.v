`timescale 1ns / 1ps

// Main fizzbuzz loop
// Ken Shirriff  http://righto.com

// The fizzbuzz problem is to output the numbers 1 to 100 except
// Output "Fizz" if the number is divisible by 3.
// Output "Buzz" if the number is divisible by 5.
// Output "Fizzbuzz" if the number is divisible by both.

// The algorithm is to have a BCD counter incremented from 1 to 100.
// Store count mod 3 in "mod3", and count mod 5 in "mod5".
// That way the modulo values can be simply incremented rather than an
// expensive modulo operation.

// Writes ASCII fizzbuzz output as 9600 baud serial.

module fizzbuzz(
  input clk,
  input rst,
  output [7:0] led,  // Diagnostic LED
  output out         // Output pin
  );

reg [1:0] mod3; // Current value mod 3
reg [2:0] mod5; // Current value mod 5
reg [7:0] char; // Current character to send
reg serial_send; // Flag to send character

// The serial sending module
serial serial(
  .clk(clk),
  .rst(rst),
  .char(char),
  .send(serial_send),
  .out(out),
  .busy(serial_busy)
  );

reg [3:0] state;

// States for fizzbuzz.
// NEXT indicates ready to move to next digit (line has been printed).
// States 1 to n indicate that the character should be printed.
// DONE indicates the algorithm is done. The reset button will restart it.
localparam NEXT = 4'b0, DONE = 4'b1111;

// Show state and middle digit on LEDs for debugging.
assign led[3:0] = state;
assign led[7:4] = digit1;

// Send an increment signal to the BCD counter in state NEXT
wire increment = (state == NEXT) ? 1'b1 : 1'b0;

// The 3-digit BCD counter.
wire [3:0] digit2, digit1, digit0;
bcd_counter bcd_counter(
  .clk(clk),
  .rst(rst),
  .increment(increment),
  .digit2(digit2),
  .digit1(digit1),
  .digit0(digit0)
);

// Main loop
always @(posedge clk) begin
  serial_send <= 1'b0;
  if (rst) begin
    // Start with BCD value 000 and modulo values 0
    mod3 <= 2'd0;
    mod5 <= 3'd0;
    state <= NEXT; // Will increment to 1 before first output.
  end else if (state == NEXT) begin
    // Line done. Move to next counter value or enter DONE state.
    if (digit2 == 1 && digit1 == 0 && digit0 == 0) begin
      state <= DONE;
    end else begin
      // Move to next counter value
      mod3 <= (mod3 == 2) ? 2'b0 : mod3 + 1'b1;
      mod5 <= (mod5 == 4) ? 3'b0 : mod5 + 1'b1;
      state <= 1; // Start output with state 1
    end
  end else if (!serial_busy && !serial_send && state != DONE) begin
    // The output path.  Output next character, controlled by state.
    state <= state + 1'b1;
    serial_send <= 1'b1; // Tell serial module to output a character.
    // serial_busy will be high until the serial module is done.
    if (mod3 == 2'b0 && mod5 == 3'b0) begin
     // Fizzbuzz: output each character of the string.
     case (state)
       1: char <= "F";
       2: char <= "i";
       3: char <= "z";
       4: char <= "z";
       5: char <= "b";
       6: char <= "u";
       7: char <= "z";
       8: char <= "z";
       9: char <= "\r";
       10: begin
         char <= "\n";
         state <= NEXT; // Done with output line
         end
      endcase
    end else if (mod3 == 2'b0) begin
      // Fizz
      case (state)
       1: char <= "F";
       2: char <= "i";
       3: char <= "z";
       4: char <= "z";
       5: char <= "\r";
       6: begin
         char <= "\n";
         state <= NEXT; // Done with output line
         end
      endcase
    end else if (mod5 == 3'b0) begin
      // Buzz
      case (state)
       1: char <= "B";
       2: char <= "u";
       3: char <= "z";
       4: char <= "z";
       5: char <= "\r";
       6: begin
         char <= "\n";
         state <= NEXT; // Done with output line
         end
      endcase
    end else begin
      // No divisors; output the digits of the number.
      case (state)
       1: begin
         if (digit2 == 0) begin
           serial_send <= 0; // Suppress leading zero
         end else begin
           char <= {2'b11, digit2[3:0]}; // Append 11 bits to get 7-bit ASCII digit
         end
       end
       2: begin
         if (digit2 == 0 && digit1 == 0) begin
           serial_send <= 0; // Suppress leading zero
         end else begin
           char <= {2'b11, digit1[3:0]};
         end
       end
       3: char <= {2'b11, digit0[3:0]};
       4: char <= "\r";
       5: begin
         char <= "\n";
         state <= NEXT;
       end
      endcase
    end
  end
end

endmodule
