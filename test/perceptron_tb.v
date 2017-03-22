//==============================================================================
// Testbench name 	 : perceptron_tb
// File name   : perceptron_tb.v
// Function	   : Test for the perceptron module
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes:
//==============================================================================

`timescale 1ns/1ps

module perceptron_tb;


localparam clock_frequency	= 12000000;
localparam clk_pulse_width = 1000000000/clock_frequency;

localparam usart_baud_rate	= 9600;

reg clk, rst_n;

// perceptron interface
reg [15:0] neur_IN1, neur_IN2;
reg [15:0] neur_weight1_new, neur_weight2_new;
reg neur_weight1_ld, neur_weight2_ld;
wire [15:0] neur_weight1_curr, neur_weight2_curr;
wire neur_result;

perceptron perceptron (
	.rst_n(rst_n),
	.clk(clk),
	.IN1(neur_IN1),
	.IN2(neur_IN2),
	.weight1_new(neur_weight1_new),
	.weight2_new(neur_weight2_new),
	.weight1_ld(neur_weight1_ld),
	.weight2_ld(neur_weight2_ld),
	.weight1(neur_weight1_curr),
	.weight2(neur_weight2_curr),
	.result(neur_result)
);


// Dump variables
initial begin
    $dumpvars(0, perceptron);
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
	neur_IN1 = 0;
	neur_IN2 = 0;
	neur_weight1_new = 0; 
	neur_weight2_new = 0;
	neur_weight1_ld = 0; 
	neur_weight2_ld = 0;

	wait( rst_n );
	@(negedge clk);
	$monitor("[Time %d]: Started testbench", $time);
	neur_weight1_new = 8806;	// ~2.15
	neur_weight2_new = 3072;	//  0.75
	neur_weight1_ld = 1;
	neur_weight2_ld = 1;

	@(negedge clk);

	neur_weight1_new = 0;	// ~2.15
	neur_weight2_new = 0;	//  0.75
	neur_weight1_ld = 0;
	neur_weight2_ld = 0;

	@(negedge clk);

	neur_IN1 = 3522;	// ~0.86
	neur_IN2 = 5734;	// ~1.4

	
	// The expected result is weighted_sum = 11871 (~2.89)
	// result = 1

	repeat (clk_pulse_width*50) @(negedge clk);

	neur_weight1_new = 57344;	// -1
	neur_weight2_new = 3072;	//  0.75
	neur_weight1_ld = 1;
	neur_weight2_ld = 1;

	@(negedge clk);

	neur_weight1_new = 0;
	neur_weight2_new = 0;
	neur_weight1_ld = 0;
	neur_weight2_ld = 0;

	@(negedge clk);

	neur_IN1 = 8192;	//  2
	neur_IN2 = 1024;	//  0.25

	repeat (clk_pulse_width*200) @(negedge clk);

	$finish;
end

endmodule // perceptron_tb
