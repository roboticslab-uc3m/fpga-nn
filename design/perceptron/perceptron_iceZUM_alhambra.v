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

    output wire LED0,
    output wire LED1,
    output wire LED2,
    output wire LED3,
    output wire LED4,
    output wire LED5,
    output wire LED6,
    output wire LED7,
	
    input wire FTDI_RX,		// UART tx line
	output wire FTDI_TX		// UART rx line
);

localparam fp_integer_width = 4;
localparam fp_fract_width = 4;

localparam clock_frequency	= 12000000;
localparam uart_baud_rate	= 9600;

wire rst_n;
wire [4:0] cont_state;

assign rst_n = !SW1;

perceptron_top #(
    .fp_integer_width(fp_integer_width),
    .fp_fract_width(fp_fract_width),
	.clock_frequency(clock_frequency),
	.uart_baud_rate(uart_baud_rate)
) perceptron_top (
	.rst_n(rst_n),
	.clk(CLK12MHZ),
    .cont_state(cont_state),
	.rx(FTDI_RX),
	.tx(FTDI_TX)
);

assign {LED7, LED6, LED5, LED4, LED3, LED2, LED1, LED0} = {3'b0, cont_state};



endmodule
