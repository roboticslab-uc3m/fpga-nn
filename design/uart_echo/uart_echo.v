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
	
    output reg [7:0] byte_cnt,
    output wire error,
	// External interface
    input wire rx,
	output wire tx
);

parameter  clock_frequency        = 12000000;
parameter  baud_rate              = 9600;

//wire clear;
//wire start_transmit;
wire rx_busy, tx_busy, new_value;
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
    .rx_busy(rx_busy),
	.tx_busy(tx_busy),
    .error(error),
    .new_value(new_value),
	.data_to_send(received_data),
    .recvd_data(received_data)
);


// received bytes counter
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        byte_cnt <= 0;
    end else if (new_value) begin
        byte_cnt <= byte_cnt + 1;
    end
end

endmodule
