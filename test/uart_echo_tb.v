//==============================================================================
// Testbench name 	 : uart_echo_tb
// File name   : uart_echo_tb.v
// Function	   : Test for the UART echo application.
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes:
//==============================================================================

`timescale 1ns/1ps

module uart_echo_tb;

reg clk, rst_n;
reg rx;
wire tx;

localparam clock_frequency = 12000000;
localparam clk_pulse_width = 1000000000/clock_frequency;

localparam baud_rate = 9600;

uart_echo #(
	.clock_frequency(clock_frequency),
	.baud_rate(baud_rate)
) uart_echo (
	.rst_n(rst_n),
	.clk(clk),
	.rx(rx),
	.tx(tx)
);

// Dump variables
initial begin
    $dumpvars(0, uart_echo);
end

// Clock
always #(clk_pulse_width/2) clk = !clk;

// Reset
initial begin
	$monitor("Time %d", $time);
	clk = 0;
    rst_n = 0;
	repeat (5) @(negedge clk);
	rst_n = 1;
end

// testbench
initial begin
	rx = 1;
	wait( rst_n );
	@(negedge clk);
	$monitor("[Time %d]: Started testbench", $time);

    // send START signal
	rx = 0;
	repeat (clock_frequency/baud_rate) @(negedge clk);

    // send 8 bits
    rx = 1;
    repeat (clock_frequency/baud_rate) @(negedge clk);
    rx = 0;
    repeat (clock_frequency/baud_rate) @(negedge clk);
    rx = 1;
    repeat (clock_frequency/baud_rate) @(negedge clk);
    rx = 0;
    repeat (clock_frequency/baud_rate) @(negedge clk);
    rx = 1;
    repeat (clock_frequency/baud_rate) @(negedge clk);
    rx = 0;
    repeat (clock_frequency/baud_rate) @(negedge clk);
    rx = 1;
    repeat (clock_frequency/baud_rate) @(negedge clk);
    rx = 0;
    repeat (clock_frequency/baud_rate) @(negedge clk);

    // send STOP signal
    rx = 1;
    
    repeat (15*(clock_frequency/baud_rate)) @(negedge clk);    

	$finish;
end

endmodule // uart_echo_tb
