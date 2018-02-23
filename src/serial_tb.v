`timescale 1ns / 1ps

module serial_tb;

   reg clk, rst, send;
   reg [6:0] char;
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
     char = 7'b1000010; // ASCII 'B'
     send = 1;
     #20;
     send = 0;
     # 1000000
     $finish;
   end

endmodule

