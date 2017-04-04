//==============================================================================
// Testbench name 	 : uart_tb
// File name   : uart.v
// Function	   : Test for the UART transmit and receive module
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes:
//==============================================================================


`timescale 1ns/1ps

module uart_tb;

reg clk, rst_n;

reg clear_1;
reg start_transmit_1;
reg [7:0] data_to_send_1;
wire [7:0] received_data_1;
wire error_1, new_value_1, tx_busy_1, rx_busy_1;

reg clear_2;
reg start_transmit_2;
reg [7:0] data_to_send_2;
wire [7:0] received_data_2;
wire error_2, new_value_2, tx_busy_2, rx_busy_2;

wire interface_send_1, interface_send_2;

localparam clock_frequency = 12000000;
localparam clk_pulse_width = 1000000000/clock_frequency;

localparam baud_rate = 9600;

uart #(
	.clock_frequency(clock_frequency),
	.baud_rate(baud_rate)
) uart_1(
    .rst_n(rst_n),
    .clk(clk),
    .rx(interface_send_2),
	.tx(interface_send_1),
    .clear(clear_1),
	.start_transmit(start_transmit_1),
    .rx_busy(rx_busy_1),
	.tx_busy(tx_busy_1),
    .error(error_1),
    .new_value(new_value_1),
	.data_to_send(data_to_send_1),
    .recvd_data(received_data_1)
);

uart #(
	.clock_frequency(clock_frequency),
	.baud_rate(baud_rate) 
) uart_2(
    .rst_n(rst_n),
    .clk(clk),
    .rx(interface_send_1),
	.tx(interface_send_2),
    .clear(clear_2),
	.start_transmit(start_transmit_2),
    .rx_busy(rx_busy_2),
	.tx_busy(tx_busy_2),
    .error(error_2),
    .new_value(new_value_2),
	.data_to_send(data_to_send_2),
    .recvd_data(received_data_2)
);

// Dump variables
initial begin
    //$dumpfile("uart_tb.vcd");
    $dumpvars(0, uart_1, uart_2);
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
	clear_1 = 0;
	start_transmit_1 = 0;
	data_to_send_1 = 0;
	clear_2 = 0;
	start_transmit_2 = 0;
	data_to_send_2 = 0;

	wait( rst_n );
	@(negedge clk);
	$monitor("[Time %d]: Started testbench", $time);

	data_to_send_1 = 8'b10101010;
	start_transmit_1 = 1;
	
	repeat (10) @(negedge clk);
	start_transmit_1 = 0;
	data_to_send_1 = 0;

	wait ( !tx_busy_1 & !rx_busy_1 & !tx_busy_2 & !rx_busy_2);
	repeat (500) @(negedge clk);
	$finish;
end

endmodule // uart_tx_tb
