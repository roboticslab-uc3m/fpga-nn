//==============================================================================
// Design name : perceptron_top
// File name   : perceptron_top.v
// Function	   : Top file for the perceptron application
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes: Communication is made though UART, at 9600bauds, 8bit + 1stop.
//==============================================================================

module perceptron_top (

    input wire rst_n,
    input wire clk,
	
    input wire rx,
	output wire tx
);


parameter clock_frequency	= 12000000;
parameter usart_baud_rate	= 9600;

// uart interface
reg uart_clear;
reg uart_transmit;
reg [7:0] uart_data_to_send;
wire uart_busy, uart_error, uart_new_value;
wire [7:0] uart_received_data;

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
	.weight2(neur_weight2_cur),
	.result(neur_result)
);

uart #(
	.clock_frequency(clock_frequency),
	.baud_rate(usart_baud_rate)
) uart (
    .rst_n(rst_n),
    .clk(clk),
    .rx(rx),
	.tx(tx),
    .clear(uart_clear),
	.start_transmit(uart_start_transmit),
    .busy(uart_busy),
    .error(uart_error),
    .new_value(uart_new_value),
	.data_to_send(uart_data_to_send),
    .recvd_data(uart_received_data)
);





endmodule
