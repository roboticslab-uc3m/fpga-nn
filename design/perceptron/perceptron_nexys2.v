//==============================================================================
// Design name : perceptron nexys2
// File name   : perceptron_nexys2.v
// Function	   : Top file for the perceptron application for nexys2 board.
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes: Communication is made though UART, at 9600bauds, 8bit + 1stop.
//==============================================================================

module perceptron_nexys2 (

    input wire BTN0, 		// reset button
    input wire CLK50MHZ,	// 50 MHz clock
	
    input wire RS232_RX,		// UART tx line
	output wire RS232_TX		// UART rx line
);


parameter clock_frequency	= 12000000;
parameter uart_baud_rate	= 9600;

wire rst_n;

assign rst_n = !BTN0;

perceptron_top #(
	.clock_frequency(clock_frequency),
	.uart_baud_rate(uart_baud_rate)
) perceptron_top (
	.rst_n(rst_n),
	.clk(CLK50MHZ),
	.rx(RS232_RX),
	.tx(RS232_TX)
);

endmodule
