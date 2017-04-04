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
parameter uart_baud_rate	= 9600;

// uart interface
wire uart_clear;
wire uart_transmit;
wire [7:0] uart_data_to_send;
wire uart_tx_busy, uart_rx_busy, uart_error, uart_new_value;
wire [7:0] uart_received_data;

// perceptron interface
wire neur_IN_ld;
reg [15:0] neur_IN1, neur_IN2;
wire [15:0] neur_IN1_new, neur_IN2_new;
wire [15:0] neur_weight1_new, neur_weight2_new;
wire neur_weight1_ld, neur_weight2_ld;
wire neur_weight_ld;
wire [15:0] neur_weight1_curr, neur_weight2_curr;
wire [15:0] neur_result;


always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		neur_IN1 <= 0;
		neur_IN2 <= 0;
	end else if (neur_IN_ld) begin
		neur_IN1 <= neur_IN1_new;
		neur_IN2 <= neur_IN2_new;		
	end
end


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
	.result(neur_result[0])
);

assign neur_result[15:1] = 0;

uart #(
	.clock_frequency(clock_frequency),
	.baud_rate(uart_baud_rate)
) uart (
    .rst_n(rst_n),
    .clk(clk),
    .rx(rx),
	.tx(tx),
    .clear(uart_clear),
	.start_transmit(uart_transmit),
    .tx_busy(uart_tx_busy),
	.rx_busy(uart_rx_busy),
    .error(uart_error),
    .new_value(uart_new_value),
	.data_to_send(uart_data_to_send),
    .recvd_data(uart_received_data)
);

comm_controller comm_controller (
    .rst_n(rst_n),
    .clk(clk),
	
	.byte(uart_received_data),
	.byte_ready(uart_new_value),
	.uart_busy(uart_rx_busy | uart_tx_busy),
	.weight1(neur_weight1_curr),
	.weight2(neur_weight2_curr),
	.result(neur_result),

	.uart_byte(uart_data_to_send),
	.weight1_new(neur_weight1_new),
	.weight2_new(neur_weight2_new),
	.data_in1(neur_IN1_new),
	.data_in2(neur_IN2_new),
	.uart_send(uart_transmit),
	.uart_clear(uart_clear),
	.weight_write(neur_weight_ld),
	.input_write(neur_IN_ld)
);

assign neur_weight1_ld = neur_weight_ld;
assign neur_weight2_ld = neur_weight_ld;


endmodule
