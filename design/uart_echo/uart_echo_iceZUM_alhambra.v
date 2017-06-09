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
	
    output wire LED0,
    output wire LED1,
    output wire LED2,
    output wire LED3,
    output wire LED4,
    output wire LED5,
    output wire LED6,
    output wire LED7,
    
    input wire FTDI_RX,
	output wire FTDI_TX
);

parameter  clock_frequency        = 12000000;
parameter  baud_rate              = 9600;

wire rst_n;
wire [7:0] num_recv_bytes;
wire error;

assign rst_n = !SW1;

uart_echo #(
	.clock_frequency(clock_frequency),
	.baud_rate(baud_rate)
) uart_echo(
    .rst_n(rst_n),
    .clk(CLK12MHZ),
    .byte_cnt(num_recv_bytes),
    .error(error),
    .rx(FTDI_RX),
	.tx(FTDI_TX),
);

assign {LED6, LED5, LED4, LED3, LED2, LED1, LED0} = num_recv_bytes[6:0];
assign LED7 = error;

endmodule
