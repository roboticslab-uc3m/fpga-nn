//==============================================================================
// Design name : comm_controller
// File name   : comm_controller.v
// Function	   : Controller for the communications between host and perceptron
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes:
//==============================================================================

module comm_controller (

    input wire rst_n,
    input wire clk,
	
	input wire [7:0] byte,
	input wire byte_ready,
	input wire [15:0] weight1,
	input wire [15:0] weight2,
	input wire result,

	output reg [15:0] weight1_new,
	output reg [15:0] weight2_new,
	output reg [15:0] data_in1,
	output reg [15:0] data_in2,
	output reg write_weight,
	output reg write_data_in
);


parameter clock_frequency	= 12000000;
parameter usart_baud_rate	= 9600;



localparam integer
	WAIT_COMM_st	= 0,
	INIT_RECV_st	= 1,
	WAIT_BYTE_st	= 2,
	REG_BYTE_st		= 3,
	SEND_OK_st		= 4,
	KEEP_OK_st		= 5;

// Check when the module is finished
reg [3:0]




endmodule
