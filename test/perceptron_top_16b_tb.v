//==============================================================================
// Testbench name 	 : perceptron_top_tb
// File name   : perceptron_top_tb.v
// Function	   : Test for the perceptron module with uart and communication 
//				 controller.
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes:
//==============================================================================

`timescale 1ns/1ps

module perceptron_top_16b_tb;

localparam fp_integer_width = 4;
localparam fp_fract_width = 12;

localparam clock_frequency	= 12000000;
localparam clk_pulse_width = 1000000000/clock_frequency;

localparam uart_baud_rate	= 9600;

localparam integer 
	OP_READ 				= 5,
	OP_WRITE_WEIGHTS		= 50,
	OP_WRITE_INPUTS			= 51,
 	OP_READ_RESPONSE		= 100,
 	OP_WRITE_RESPONSE_OK 	= 101,
	OP_WRITE_RESPONSE_ERR	= 102;


`define assert(cond, msg) if(cond) begin $display(" ASSERT FAILED: %s", msg); #(1000*clk_pulse_width) $finish; end

integer i;

reg clk, rst_n;

// perceptron interface
wire perceptron_rx, perceptron_tx;

// uart interface
reg uart_clear;
reg uart_transmit;
reg [7:0] uart_data_to_send;
wire uart_tx_busy, uart_rx_busy, uart_error, uart_new_value;
wire [7:0] uart_received_data;

reg [7:0] packet_inputs [0:4];
reg [7:0] packet_weights [0:4];
reg [7:0] packet_readings [0:6];

perceptron_top #(
    .fp_integer_width(fp_integer_width),
    .fp_fract_width(fp_fract_width),
	.clock_frequency(clock_frequency),
	.uart_baud_rate(uart_baud_rate)
    ) perceptron_top (
    .rst_n(rst_n),
    .clk(clk),
    .rx(perceptron_rx),
	.tx(perceptron_tx)
);

uart #(
	.clock_frequency(clock_frequency),
	.baud_rate(uart_baud_rate)
) uart (
    .rst_n(rst_n),
    .clk(clk),
    .rx(perceptron_tx),
	.tx(perceptron_rx),
    .clear(uart_clear),
	.start_transmit(uart_transmit),
    .tx_busy(uart_tx_busy),
	.rx_busy(uart_rx_busy),
    .error(uart_error),
    .new_value(uart_new_value),
	.data_to_send(uart_data_to_send),
    .recvd_data(uart_received_data)
);

// Dump variables
initial begin
    $dumpvars(0, perceptron_top, uart);
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
	uart_clear = 1;		// It reads the value as it comes, so no need to 
						// preserve the "data ready" state
	uart_transmit = 0;
	uart_data_to_send = 0;

	wait( rst_n );
	@(negedge clk);


	////////////////////////////////////////////////////////////////////////////
	// Read perceptron
	////////////////////////////////////////////////////////////////////////////
	uart_data_to_send = OP_READ;
	uart_transmit = 1;

	repeat (2) @(negedge clk);
	uart_transmit = 0;

	for (i = 0; i < 7 ; i = i+1) begin
		wait (uart_new_value);	// wait until response's first byte
		packet_readings[i] = uart_received_data;
		repeat (2) @(negedge clk);
	end
	
	$display(" - Finished reading from perceptron");

	// Weights = 0, result = 1
	`assert(packet_readings[0] != OP_READ_RESPONSE, "Operation CODE not correct")
	`assert(packet_readings[1] != 0 || packet_readings[2] != 0, "Weight 1 not correct")
	`assert(packet_readings[3] != 0 || packet_readings[4] != 0, "Weight 2 not correct")
	`assert(packet_readings[5] != 0 || packet_readings[6] != 1, "Result not correct")
 
	$display(" - Value check OK");

	repeat (5000) @(negedge clk);


	////////////////////////////////////////////////////////////////////////////
	// Write weights
	////////////////////////////////////////////////////////////////////////////
	packet_weights[0] = OP_WRITE_WEIGHTS;
	packet_weights[1] =	8'b00010101;	//
	packet_weights[2] =	8'b10101010;    // 1.35
	packet_weights[3] =	8'b11111100;    //
	packet_weights[4] =	8'b00110011;    // -0.23

	for (i = 0; i < 5 ; i = i+1) begin
		uart_data_to_send = packet_weights[i];
		uart_transmit = 1;
		wait(uart_tx_busy);
		uart_transmit = 0;
		wait(!uart_tx_busy);
	end
	$display(" - Finished writing weights to perceptron");

	// Wait for confirmation
	wait (uart_new_value);
	`assert(uart_received_data != OP_WRITE_RESPONSE_OK, "Confirmation CODE not correct")
	
	$display(" - Confirmation received OK");

	repeat (5000) @(negedge clk);

	////////////////////////////////////////////////////////////////////////////
	// Read perceptron
	////////////////////////////////////////////////////////////////////////////
	uart_data_to_send = OP_READ;
	uart_transmit = 1;

	repeat (2) @(negedge clk);
	uart_transmit = 0;

	for (i = 0; i < 7 ; i = i+1) begin
		wait (uart_new_value);	// wait until response's first byte
		packet_readings[i] = uart_received_data;
		repeat (2) @(negedge clk);
	end

	$display(" - Finished reading from perceptron");

	// Weights = 0, result = 1
	`assert(packet_readings[0] != OP_READ_RESPONSE, "Operation CODE not correct")
	`assert(packet_readings[1] != packet_weights[1] || packet_readings[2] != packet_weights[2], "Weight 1 not correct")
	`assert(packet_readings[3] != packet_weights[3] || packet_readings[4] != packet_weights[4], "Weight 2 not correct")
	`assert(packet_readings[5] != 0 || packet_readings[6] != 1, "Result not correct")

	$display(" - Value check OK");

	////////////////////////////////////////////////////////////////////////////
	// Write Inputs
	////////////////////////////////////////////////////////////////////////////
	packet_inputs[0] = OP_WRITE_INPUTS;
	packet_inputs[1] =	8'b11100000;
	packet_inputs[2] =	8'b00000000;    // -2
	packet_inputs[3] =	8'b00100000;
	packet_inputs[4] =	8'b00001111;    // 2.037

	for (i = 0; i < 5 ; i = i+1) begin
		uart_data_to_send = packet_inputs[i];
		uart_transmit = 1;
		wait(uart_tx_busy);
		uart_transmit = 0;
		wait(!uart_tx_busy);
	end
	$display(" - Finished writing inputs to perceptron");

	// Wait for confirmation
	wait (uart_new_value);
	`assert(uart_received_data != OP_WRITE_RESPONSE_OK, "Confirmation CODE not correct")
	
	$display(" - Confirmation received OK");

	repeat (5000) @(negedge clk);

	////////////////////////////////////////////////////////////////////////////
	// Read perceptron
	////////////////////////////////////////////////////////////////////////////
	uart_data_to_send = OP_READ;
	uart_transmit = 1;

	repeat (2) @(negedge clk);
	uart_transmit = 0;

	for (i = 0; i < 7 ; i = i+1) begin
		wait (uart_new_value);	// wait until response's first byte
		packet_readings[i] = uart_received_data;
		repeat (2) @(negedge clk);
	end

	$display(" - Finished reading from perceptron");

	// Weights = 0, result = 1
	`assert(packet_readings[0] != OP_READ_RESPONSE, "Operation CODE not correct")
	`assert(packet_readings[1] != packet_weights[1] || packet_readings[2] != packet_weights[2], "Weight 1 not correct")
	`assert(packet_readings[3] != packet_weights[3] || packet_readings[4] != packet_weights[4], "Weight 2 not correct")
	`assert(packet_readings[5] != 0 || packet_readings[6] != 0, "Result not correct")

    // The perceptron value should be (8'1100 1101 0000 1110) = -3.1840
    // result is evaluated after the step function [step(q) = (q >= 0)]
    // result = 0

	$display(" - Value check OK");

	$display(" - All test CORRECT");
	$finish;
end

endmodule // perceptron_top_16b_tb
