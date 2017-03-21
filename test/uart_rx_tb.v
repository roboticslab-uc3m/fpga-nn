`timescale 1ns/1ps

module uart_rx_tb;

reg clk, rst_n;
reg rx, clear;
wire [7:0] data;
wire busy, error, new_value;

localparam clock_frequency = 12000000;
localparam clk_pulse_width = 1000000000/clock_frequency;

localparam baud_rate = 9600;

uart_rx uart_rx(
	.rst_n(rst_n),
	.clk(clk),
	.rx(rx),
	.clear(clear),
	.data(data),
	.busy(busy),
    .error(error),
    .new_value(new_value)
);

// Dump variables
initial begin
    $dumpvars(0,uart_rx);
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
    clear = 0;
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
    
    repeat (clock_frequency/baud_rate) @(negedge clk);
    
	$finish;
end

endmodule // uart_rx_tb
