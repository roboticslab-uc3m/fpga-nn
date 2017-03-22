//==============================================================================
// Design name : perceptron_iceZUM alhambra
// File name   : perceptron_iceZUM_alhambra.v
// Function	   : Top file for the perceptron application for iceZUM alhambra board.
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes: Communication is made though UART, at 9600bauds, 8bit + 1stop.
//==============================================================================

module perceptron_iceZUM_alhambra (

    input wire SW1, 		// reset button
    input wire CLK12MHZ,	// 12 MHz clock
	
    input wire FTDI_RX,		// UART tx line
	output wire FTDI_TX		// UART rx line
);


parameter clock_frequency	= 12000000;
parameter usart_baud_rate	= 9600;

perceptron_top #(
	.clock_frequency(clock_frequency),
	.uart_baud_rate(usart_baud_rate)
) perceptron_top (
	.rst_n(rst_n),
	.clk(CLK12MHZ),
	.rx(FTDI_RX),
	.tx(FTDI_TX),
);

endmodule
