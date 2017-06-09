//==============================================================================
// Design name : perceptron_top
// File name   : perceptron_top.v
// Function	   : Top file for the perceptron application
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes: Communication is made though UART, at 9600bauds, 8bit + 1stop.
//  The maximun width of the perceptron values, is: 
//  fp_integer_width + fp_fract_width = 16
//==============================================================================

module perceptron_top (

    input wire rst_n,
    input wire clk,
	
    output wire [4:0] cont_state,
    
    input wire rx,
	output wire tx
);

parameter fp_integer_width = 4;
parameter fp_fract_width = 12;
parameter clock_frequency	= 12000000;
parameter uart_baud_rate	= 9600;

localparam fp_width = fp_integer_width + fp_fract_width;

// uart interface
wire uart_clear;
wire uart_transmit;
wire [7:0] uart_data_to_send;
wire uart_tx_busy, uart_rx_busy, uart_error, uart_new_value;
wire [7:0] uart_received_data;

// perceptron interface
wire neur_IN_ld;
reg [fp_width-1:0] neur_IN1, neur_IN2;
wire [fp_width-1:0] neur_IN1_new, neur_IN2_new;
wire [fp_width-1:0] neur_weight1_new, neur_weight2_new;
wire neur_weight1_ld, neur_weight2_ld;
wire neur_weight_ld;
wire [fp_width-1:0] neur_weight1_curr, neur_weight2_curr;

// Communication controller interface
wire [15:0] cont_IN1, cont_IN2_int;
wire [15:0] cont_IN1_new, cont_IN2_new;
wire [15:0] cont_weight1_new, cont_weight2_new;
wire [15:0] cont_weight1_curr, cont_weight2_curr;
wire [15:0] cont_result;

always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		neur_IN1 <= 0;
		neur_IN2 <= 0;
	end else if (neur_IN_ld) begin
		neur_IN1 <= neur_IN1_new;
		neur_IN2 <= neur_IN2_new;		
	end
end


perceptron #(
    .fp_integer_width(fp_integer_width),
    .fp_fract_width(fp_fract_width)
    ) perceptron (
	.rst_n(rst_n),
	.clk(clk),
	.IN1(neur_IN1[fp_width-1:0]),
	.IN2(neur_IN2[fp_width-1:0]),
	.weight1_new(neur_weight1_new[fp_width-1:0]),
	.weight2_new(neur_weight2_new[fp_width-1:0]),
	.weight1_ld(neur_weight1_ld),
	.weight2_ld(neur_weight2_ld),
	.weight1(neur_weight1_curr[fp_width-1:0]),
	.weight2(neur_weight2_curr[fp_width-1:0]),
	.result(cont_result[0])
);

assign cont_result[15:1] = 0;

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


assign cont_weight1_curr = {{(16-fp_width){1'b0}}, neur_weight1_curr};
assign cont_weight2_curr = {{(16-fp_width){1'b0}}, neur_weight2_curr};

comm_controller comm_controller (
    .rst_n(rst_n),
    .clk(clk),
	
	.byte(uart_received_data),
	.byte_ready(uart_new_value),
	.uart_busy(uart_rx_busy | uart_tx_busy),
	.weight1(cont_weight1_curr),
	.weight2(cont_weight2_curr),
	.result(cont_result),

	.uart_byte(uart_data_to_send),
	.weight1_new(cont_weight1_new),
	.weight2_new(cont_weight2_new),
	.data_in1(cont_IN1_new),
	.data_in2(cont_IN2_new),
    .controller_state(cont_state),
	.uart_send(uart_transmit),
	.uart_clear(uart_clear),
	.weight_write(neur_weight_ld),
	.input_write(neur_IN_ld)
);

assign neur_IN1_new = cont_IN1_new[fp_width-1:0];
assign neur_IN2_new = cont_IN2_new[fp_width-1:0];
assign neur_weight1_new = cont_weight1_new[fp_width-1:0];
assign neur_weight2_new = cont_weight2_new[fp_width-1:0];

assign neur_weight1_ld = neur_weight_ld;
assign neur_weight2_ld = neur_weight_ld;


endmodule
