`timescale 1ns / 1ps

// Testbench for bcd_counter.
// Ken Shirriff  http://righto.com

module bcd_counter_tb;

   // Inputs
   reg clk;
   reg rst;
   reg increment;

   // Outputs
   wire [3:0] digit2, digit1, digit0;

   // Instantiate the Unit Under Test (UUT)
   bcd_counter uut (
      .clk(clk), 
      .rst(rst), 
      .increment(increment), 
      .digit2(digit2),
      .digit1(digit1),
      .digit0(digit0)
   );

   initial begin
      clk = 1'b0;
      rst = 1'b1;
      repeat(4) #10 clk = ~clk;
      rst = 1'b0;
      forever #10 clk = ~clk;
   end
   
   initial begin
     # 20; // Wait for reset
     // Increment 120 times
     repeat(120) begin
       #20 increment = 1'b1;
       #20 increment = 1'b0;
     end
     $finish;
   end
      
endmodule

