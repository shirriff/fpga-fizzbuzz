`timescale 1ns / 1ps

// Main fizzbuzz loop

module fizzbuzz(
  input clk,
  input rst,
  output [7:0] led,
  output out
  );

reg [1:0] mod3; // Current value mod 3
reg [2:0] mod5; // Current value mod 5
reg [6:0] char;
reg serial_send;

serial serial(
  .clk(clk),
  .rst(rst),
  .char(char),
  .send(serial_send),
  .out(out),
  .busy(serial_busy)
  );

reg [3:0] state;

assign led[3:0] = state;
assign led[7:4] = digit1;

localparam NEXT = 4'b0, DONE = 4'b1111;
  
wire increment = (state == NEXT) ? 1'b1 : 1'b0;

wire [3:0] digit2, digit1, digit0;
bcd_counter bcd_counter(
  .clk(clk),
  .rst(rst),
  .increment(increment),
  .digit2(digit2),
  .digit1(digit1),
  .digit0(digit0)
);

always @(posedge clk) begin
  serial_send <= 1'b0;
  if (rst) begin
    mod3 <= 2'd0;
    mod5 <= 3'd0;
    state <= NEXT;
  end else if (state == NEXT) begin
    if (digit2 == 1 && digit1 == 0 && digit0 == 0) begin
      state <= DONE;
    end else begin
      // Move to next counter value
      mod3 <= (mod3 == 2) ? 2'b0 : mod3 + 1'b1;
      mod5 <= (mod5 == 4) ? 3'b0 : mod5 + 1'b1;
      state <= 1;
    end
  end else if (!serial_busy && !serial_send && state != DONE) begin
    // Output next character
    state <= state + 1'b1;
    serial_send <= 1'b1;
    if (mod3 == 2'b0 && mod5 == 3'b0) begin
     // Fizzbuzz
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
         state <= NEXT;
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
         state <= NEXT;
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
         state <= NEXT;
         end
      endcase
    end else begin
      // Normal digit
      case (state)
       1: begin
         if (digit2 == 0) begin
           serial_send <= 0; // Suppress leading zero
         end else begin
           char <= {2'b11, digit2[3:0]};
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
