//==============================================================================
// Design name : uart_echo
// File name   : uart_echo.v
// Function	   : UART echo project to test the UART module on FPGA
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes:
//==============================================================================

module uart_echo (
    input wire rst_n,
    input wire clk,
	
	// External interface
    input wire rx,
	output wire tx
);

parameter  clock_frequency        = 12000000;
parameter  baud_rate              = 9600;

//wire clear;
//wire start_transmit;
wire busy, error, new_value;
//wire [7:0] data_to_send;
wire [7:0] received_data;

uart #(
	.clock_frequency(clock_frequency),
	.baud_rate(baud_rate)
) uart(
    .rst_n(rst_n),
    .clk(clk),
    .rx(rx),
	.tx(tx),
    .clear(new_value),
	.start_transmit(new_value),
    .busy(busy),
    .error(error),
    .new_value(new_value),
	.data_to_send(received_data),
    .recvd_data(received_data)
);

endmodule
