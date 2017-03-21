//==============================================================================
// Design name : uart_echo_iceZUM alhambra
// File name   : uart_echo_iceZUM_alhambra.v
// Function	   : Top file for the uart_echo application for iceZUM alhambra board.
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes:
//==============================================================================

module uart_echo_iceZUM_alhambra (
    input wire SW1,
    input wire CLK12MHZ,
	
    input wire FTDI_RX,
	output wire FTDI_TX
);

parameter  clock_frequency        = 12000000;
parameter  baud_rate              = 9600;

wire rst_n;

assign rst_n = !SW1;

uart_echo #(
	.clock_frequency(clock_frequency),
	.baud_rate(baud_rate)
) uart_echo(
    .rst_n(rst_n),
    .clk(CLK12MHZ),
    .rx(FTDI_RX),
	.tx(FTDI_TX),
);

endmodule
