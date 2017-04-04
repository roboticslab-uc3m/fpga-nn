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
	input wire uart_busy,
	input wire [15:0] weight1,
	input wire [15:0] weight2,
	input wire [15:0] result,

	output reg [7:0]  uart_byte,
	output wire [15:0] weight1_new,
	output wire [15:0] weight2_new,
	output wire [15:0] data_in1,
	output wire [15:0] data_in2,
	output reg uart_send,
	output reg uart_clear,
	output reg weight_write,
	output reg input_write
);


parameter clock_frequency	= 12000000;
parameter usart_baud_rate	= 9600;

localparam integer 
	OP_READ 				= 5,
	OP_WRITE_WEIGHTS		= 50,
	OP_WRITE_INPUTS			= 51,
 	OP_READ_RESPONSE		= 100,
 	OP_WRITE_RESPONSE_OK 	= 101,
	OP_WRITE_RESPONSE_ERR	= 102;

localparam integer
	WAIT_COMM_st	= 0,
	INIT_RECV_st	= 1,
	INIT_SEND_st	= 2,
	WAIT_BYTE_st	= 3,
	REG_BYTE_st		= 4,
	SEND_OK_W_st	= 5,
	SEND_OK_IN_st	= 6,
	KEEP_OK_st		= 7,
	SEND_BYTE_st	= 8,
	NEXT_VALUE_st	= 9,
	WAIT_UART_st	= 10;

// State
reg [4:0] state, next_state;

// byte counter
reg [4:0] byte_cnt, byte_cnt_val;
reg byte_cnt_ld;
reg byte_cnt_en;

reg [7:0] operation;
reg operation_ld;

// input data buffer
reg [7:0] data_buffer[3:0];
reg data_buffer_ld;


wire [7:0] curr_data[6:0];

assign curr_data[6] = OP_READ_RESPONSE;
assign curr_data[5] = weight1[15:8];
assign curr_data[4] = weight1[7:0];
assign curr_data[3] = weight2[15:8];
assign curr_data[2] = weight2[7:0];
assign curr_data[1] = result[15:8];
assign curr_data[0] = result[7:0];

assign weight1_new = {data_buffer[3], data_buffer[2]};
assign weight2_new = {data_buffer[1], data_buffer[0]};

assign data_in1 = {data_buffer[3], data_buffer[2]};
assign data_in2 = {data_buffer[1], data_buffer[0]};

// state
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		state <= WAIT_COMM_st;
	end else begin
		state <= next_state;
	end
end

// byte counter
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		byte_cnt <= 0;
	end else if (byte_cnt_ld) begin
		byte_cnt <= byte_cnt_val;
	end else if (byte_cnt_en) begin
		byte_cnt <= byte_cnt - 1;
	end
end

// operation register
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		operation <= 0;
	end else if (operation_ld) begin
		operation <= byte;
	end
end

// input data buffer
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		data_buffer[0] <= 0;
		data_buffer[1] <= 0;
		data_buffer[2] <= 0;
		data_buffer[3] <= 0;
	end else if (data_buffer_ld) begin
		data_buffer[byte_cnt] = byte;
	end
end

// next state
always @(*) begin
	next_state = state;
	case (state)
		WAIT_COMM_st:
			if (byte_ready) begin
				if (byte == OP_WRITE_WEIGHTS || byte == OP_WRITE_INPUTS) begin
					next_state = INIT_RECV_st;
				end else if (byte == OP_READ) begin
					next_state = INIT_SEND_st;
				end
			end
		INIT_RECV_st:
			next_state = WAIT_BYTE_st;
		INIT_SEND_st:
			next_state = SEND_BYTE_st;
		WAIT_BYTE_st:
			if (byte_ready) begin
				next_state = REG_BYTE_st;
			end
		REG_BYTE_st:
			if (byte_cnt > 0) begin
				next_state = WAIT_BYTE_st;
			end else if (byte_cnt == 0) begin
				if (operation == OP_WRITE_INPUTS) begin
					next_state = SEND_OK_IN_st;
				end else begin
					next_state = SEND_OK_W_st;
				end
			end
		SEND_OK_W_st:
			next_state = KEEP_OK_st;
		SEND_OK_IN_st:
			next_state = KEEP_OK_st;
		KEEP_OK_st:
			next_state = WAIT_COMM_st;
		SEND_BYTE_st:
			next_state = NEXT_VALUE_st;
		NEXT_VALUE_st:
			if (byte_cnt > 0) begin
				next_state = WAIT_UART_st;
			end else if (byte_cnt == 0) begin
				next_state = WAIT_COMM_st;
			end
		WAIT_UART_st:
			if (!uart_busy) begin
				next_state = SEND_BYTE_st;
			end
	endcase
end


// output logic
always @(*) begin
	byte_cnt_val = 0;
	byte_cnt_ld = 0;
	byte_cnt_en = 0;

	data_buffer_ld = 0;

	operation_ld = 0;
	uart_byte = 0;
	uart_send = 0;
	uart_clear = 0;

	weight_write = 0;
	input_write = 0;

	case (state)
		//WAIT_COMM_st:
			// nothing
		INIT_RECV_st: begin
			uart_clear = 1;
			operation_ld = 1;
			byte_cnt_val = 3;
			byte_cnt_ld = 1;
		end
		INIT_SEND_st: begin
			uart_clear = 1;
			operation_ld = 1;
			byte_cnt_val = 6;
			byte_cnt_ld = 1;
		end
		//WAIT_BYTE_st: 
			// nothing
		REG_BYTE_st: begin
			uart_clear = 1;
			byte_cnt_en = 1;
			data_buffer_ld = 1;
		end
		SEND_OK_W_st: begin
			weight_write = 1;
			uart_byte = OP_WRITE_RESPONSE_OK;
			uart_send = 1;
		end
		SEND_OK_IN_st: begin
			input_write = 1;
			uart_byte = OP_WRITE_RESPONSE_OK;
			uart_send = 1;
		end
		KEEP_OK_st: begin
			uart_byte = OP_WRITE_RESPONSE_OK;
			uart_send = 1;
		end
		SEND_BYTE_st: begin
			uart_byte = curr_data[byte_cnt]; 
			uart_send = 1;
		end
		NEXT_VALUE_st: begin
			byte_cnt_en = 1;
			uart_byte = curr_data[byte_cnt]; 
			uart_send = 1;
		end
		//WAIT_UART_st:
			// nothing
	endcase
end
endmodule
