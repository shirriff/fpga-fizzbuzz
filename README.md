# FizzBuzz implemented on an FPGA

Just for fun, I implemented the FizzBuzz problem on an FPGA using Verilog.

This is implemented for the Mojo board, using "mojo-base-project" as the framework.

The code is in `src`, in the `fizzbuzz.v`, `bcd_counter.v` and `serial.v` files.

The FizzBuzz problem is to output the numbers from 1 to 100, but for multiples of 3 output "Fizz" instead of the number.
For multiples of 5 output "Buzz", and for multiples of both output "FizzBuzz".
