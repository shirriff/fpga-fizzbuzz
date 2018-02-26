`timescale 1ns / 1ps

// Testbench for the serial output module
// Ken Shirriff  http://righto.com
module serial_tb;

   reg clk, rst, send;
   reg [7:0] char;
   wire out, busy;

   // Instantiate the Unit Under Test (UUT)
   serial uut (
     .clk(clk),
     .rst(rst),
     .char(char),
     .send(send),
     .out(out),
     .busy(busy)
   );

   initial begin
      clk = 1'b0;
      rst = 1'b1;
      repeat(4) #10 clk = ~clk;
      rst = 1'b0;
      forever #10 clk = ~clk;
   end
   
   initial begin
     send = 0;
     # 10000; // Wait for reset
     char = 8'b01000010; // ASCII 'B'
     send = 1;
     #20;
     send = 0;
     #20
     while (busy) #10;
     char = 8'b10101010;
     send = 1;
     #20
     send = 0;
     while (busy) #10;
     # 100
     $finish;
   end

endmodule

