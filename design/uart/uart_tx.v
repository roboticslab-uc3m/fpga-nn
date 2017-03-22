//==============================================================================
// Design name : uart_tx
// File name   : uart_tx.v
// Function	   : UART transmit only module
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes: Sends first the least significative bit. Data must be kept 1 cycle 
// more after triggering start.
//==============================================================================

module uart_tx (
    input wire rst_n,
    input wire clk,
    input wire start,
    input wire [7:0] data,   
    output reg tx,
    output reg busy
);

parameter  clock_frequency        = 12000000;
parameter  baud_rate              = 9600;

localparam clock_cycles_per_pulse = clock_frequency / baud_rate;

localparam integer 
    IDLE_st         	= 3'd0,
	INIT_SEND_START_st 	= 3'd1,
	WAIT_SEND_START_st 	= 3'd2,
	INIT_SEND_BIT_st 	= 3'd3,
	WAIT_SEND_BIT_st 	= 3'd4,
	NEXT_BIT_st			= 3'd5;

reg [2:0] state, next_state;

reg [15:0] sync_cnt;
reg sync_cnt_ld, sync_cnt_en;

reg [2:0] bit_cnt;
reg bit_cnt_ld, bit_cnt_en;

reg [7:0] input_data;
reg input_data_ld;


// next state
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE_st;
    end else begin
        state <= next_state;
    end
end


// input data
always @(posedge clk, negedge rst_n) begin
	if (!rst_n) begin
		input_data <= 0;
	end else if (input_data_ld) begin
		input_data <= data;
	end
end


// bit counter
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        bit_cnt <= 0;
    end else if (bit_cnt_ld) begin
        bit_cnt <= 0;
    end else if (bit_cnt_en) begin
        bit_cnt <= bit_cnt + 1;
    end
end


// syncronization counter
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        sync_cnt <= 0;
    end else if (sync_cnt_ld) begin
        sync_cnt <= clock_cycles_per_pulse;
    end else if (sync_cnt_en) begin
        sync_cnt <= sync_cnt - 1;
    end
end


// next state
always @(*) begin
    next_state = state;
    case (state)
	 	IDLE_st:
			if (start) begin
				next_state = INIT_SEND_START_st;
			end
		INIT_SEND_START_st:
			next_state = WAIT_SEND_START_st;
		WAIT_SEND_START_st:
			if (sync_cnt == 0) begin
				next_state = INIT_SEND_BIT_st;
			end
		INIT_SEND_BIT_st:
			next_state = WAIT_SEND_BIT_st;
		WAIT_SEND_BIT_st:
			if (sync_cnt == 0) begin
				if (bit_cnt < 7) begin
					next_state = NEXT_BIT_st;
				end else if (bit_cnt == 7) begin
					next_state = IDLE_st;
				end
			end
		NEXT_BIT_st:
			next_state = INIT_SEND_BIT_st;
    endcase 
end


// output logic
always @(*) begin
	tx = 1;
	busy = 1;
	sync_cnt_ld = 0;
	sync_cnt_en = 0;

	bit_cnt_ld = 0; 
	bit_cnt_en = 0;

	input_data_ld = 0;

    case (state)
	 	IDLE_st: begin
			busy = 0;
		end
		INIT_SEND_START_st: begin
			tx = 0;
			input_data_ld = 1;
			bit_cnt_ld = 1;
			sync_cnt_ld = 1;
		end
		WAIT_SEND_START_st: begin
			tx = 0;
			sync_cnt_en = 1;
		end
		INIT_SEND_BIT_st: begin
			tx = input_data[bit_cnt];
			sync_cnt_ld = 1;
		end
		WAIT_SEND_BIT_st: begin
			tx = input_data[bit_cnt];
			sync_cnt_en = 1;
		end
		NEXT_BIT_st: begin
			bit_cnt_en = 1;
		end
    endcase 
end

endmodule
