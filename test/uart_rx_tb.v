`timescale 1ns/1ps

module uart_rx_tb;

reg clk, rst_n;
reg rx, clear;
wire [7:0] data;
wire busy, error, new_value;

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
always #41.667 clk = !clk;

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
	repeat (8*(12000000/9600)) @(negedge clk);

    // send 8 bits
    rx = 1;
    repeat (8*(12000000/9600)) @(negedge clk);
    rx = 0;
    repeat (8*(12000000/9600)) @(negedge clk);
    rx = 1;
    repeat (8*(12000000/9600)) @(negedge clk);
    rx = 0;
    repeat (8*(12000000/9600)) @(negedge clk);
    rx = 1;
    repeat (8*(12000000/9600)) @(negedge clk);
    rx = 0;
    repeat (8*(12000000/9600)) @(negedge clk);
    rx = 1;
    repeat (8*(12000000/9600)) @(negedge clk);
    rx = 0;
    repeat (8*(12000000/9600)) @(negedge clk);

    // send STOP signal
    rx = 1;
    
    repeat (8*(12000000/9600)) @(negedge clk);
    
	$finish;
end

endmodule // uart_rx_tb
