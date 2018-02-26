//
// Top-level routine for FizzBuzz problem.
// This simply instantiates the fizzbuzz module, which does all the work.
// Ken Shirriff  http://righto.com

// FizzBuzz: loop from 1 to 100. Print Fizz for multiples of 3,
// Buzz for multiples of 5, FizzBuzz for multiples of both.

module mojo_top(
    // 50MHz clock input
    input clk,
    // Input from reset button (active low)
    input rst_n,
    // cclk input from AVR, high when AVR is ready
    input cclk,
    // Outputs to the 8 onboard LEDs
    output[7:0]led,
    // AVR SPI connections
    output spi_miso,
    input spi_ss,
    input spi_mosi,
    input spi_sck,
    // AVR ADC channel select
    output [3:0] spi_channel,
    // Serial connections
    input avr_tx, // AVR Tx => FPGA Rx
    output avr_rx, // AVR Rx => FPGA Tx
    input avr_rx_busy, // AVR Rx buffer full
	 output pin50
    );

wire rst = ~rst_n; // make reset active high

// these signals should be high-z when not used
assign spi_miso = 1'bz;
assign avr_rx = 1'bz;
assign spi_channel = 4'bzzzz;

// Main loop for FizzBuzz
fizzbuzz fizzbuzz(
  .clk(clk),
  .rst(rst),
  .led(led),
  .out(pin50)
  );

endmodule
