//==============================================================================
// Testbench name 	 : perceptron_comm_controller_tb
// File name   : perceptron_comm_controller_tb.v
// Function	   : Test for the communication controller used for the basic 
//	perceptron module
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes:
//==============================================================================

`timescale 1ns/1ps

module perceptron_comm_controller_tb;


localparam clock_frequency	= 12000000;
localparam clk_pulse_width = 1000000000/clock_frequency;

localparam usart_baud_rate	= 9600;

localparam integer 
	OP_READ 				= 5,
	OP_WRITE_WEIGHTS		= 50,
	OP_WRITE_INPUTS			= 51,
 	OP_READ_RESPONSE		= 100,
 	OP_WRITE_RESPONSE_OK 	= 101,
	OP_WRITE_RESPONSE_ERR	= 102;

reg clk, rst_n;
integer i;

// comm controller interface
reg [7:0] uart_byte_out;
reg uart_byte_ready;
reg uart_busy;
reg [15:0] perceptron_weight1, perceptron_weight2, perceptron_result;

wire [7:0] byte_to_send;
wire [15:0] weight1_new, weight2_new, input1_new, input2_new;
wire send_byte, weight_write, input_write, clear;

comm_controller comm_controller(
    .rst_n(rst_n),
    .clk(clk),
	
	.byte(uart_byte_out),
	.byte_ready(uart_byte_ready),
	.uart_busy(uart_busy),
	.weight1(perceptron_weight1),
	.weight2(perceptron_weight2),
	.result(perceptron_result),

	.uart_byte(byte_to_send),
	.weight1_new(weight1_new),
	.weight2_new(weight2_new),
	.data_in1(input1_new),
	.data_in2(input2_new),
	.uart_send(send_byte),
	.uart_clear(clear),
	.weight_write(weight_write),
	.input_write(input_write)
);


// Dump variables
initial begin
    $dumpvars(0, comm_controller);
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
	uart_byte_out = 0;
	uart_byte_ready = 0;
	uart_busy = 0;
	perceptron_weight1 = 101;
	perceptron_weight2 = 102;
	perceptron_result =  103;

	wait( rst_n );
	@(negedge clk);
	$monitor("[Time %d]: Started testbench", $time);


	// write weights
	// send op (byte OP_WRITE_WEIGHTS)
	$monitor("[Time %d]: Testing write weight operation", $time);
	repeat (8*clock_frequency/usart_baud_rate) @(negedge clk);
	uart_byte_out = OP_WRITE_WEIGHTS;
	uart_byte_ready = 1;
	wait(clear);
	uart_byte_ready = 0;

	for (i = 0; i < 4; i = i+1) begin
		repeat (8*clock_frequency/usart_baud_rate) @(negedge clk);
		uart_byte_out = 50 + i;
		uart_byte_ready = 1;
		wait(clear);
		uart_byte_ready = 0;
	end

	// write inputs
	// send op (byte OP_WRITE_INPUTS)
	$monitor("[Time %d]: Testing write input operation", $time);
	repeat (8*clock_frequency/usart_baud_rate) @(negedge clk);
	uart_byte_out = OP_WRITE_INPUTS;
	uart_byte_ready = 1;
	wait(clear);
	uart_byte_ready = 0;

	for (i = 0; i < 4; i = i+1) begin
		repeat (8*clock_frequency/usart_baud_rate) @(negedge clk);
		uart_byte_out = 70 + i;
		uart_byte_ready = 1;
		wait(clear);
		uart_byte_ready = 0;
	end


	// read values
	// send op (byte OP_READ)
	$monitor("[Time %d]: Testing read", $time);
	repeat (8*clock_frequency/usart_baud_rate) @(negedge clk);
	uart_byte_out = OP_READ;
	uart_byte_ready = 1;
	wait(clear);
	uart_byte_ready = 0;	

	for (i = 0; i < 6; i = i+1) begin
		wait(send_byte);
		uart_busy = 1;
		repeat (8*clock_frequency/usart_baud_rate) @(negedge clk);
		uart_busy = 0;
	end

	repeat (8*clock_frequency/usart_baud_rate) @(negedge clk);

	$finish;
end

endmodule // perceptron_tb
