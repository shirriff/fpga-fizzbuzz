`timescale 1ns / 1ps
// Testbench for fizzbuzz
module fizzbuzz_tb;

   // Inputs
   reg clk;
   reg rst;

   // Outputs
   wire out;

   // Instantiate the Unit Under Test (UUT)
   fizzbuzz uut (
      .clk(clk), 
      .rst(rst), 
      .out(out)
   );

   initial begin
      clk = 1'b0;
      rst = 1'b1;
      repeat(4) #10 clk = ~clk;
      rst = 1'b0;
      forever #10 clk = ~clk;
   end
   
   initial begin
     # 10000000;
     $finish;
   end
      
endmodule

