//==============================================================================
// Design name : uart_rx
// File name   : uart_rx.v
// Function	   : UART receive only module
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes: The driving clock frequency must be 8*baudrate to work properly. 
// Receives first the least significative bit.
//==============================================================================

module uart_rx (
    input wire rst_n,
    input wire clk,
    input wire rx,
    input wire clear,
    output reg [7:0] data,   
    output reg busy,
    output reg error,
    output reg new_value
);

parameter  clock_frequency        = 12000000;
parameter  baud_rate              = 9600;

localparam clock_cycles_per_pulse = clock_frequency / baud_rate;

localparam integer 
    WAIT_START_st   = 3'd0,
    INIT_SYNC_START_st  = 3'd1,
    WAIT_SYNC_START_st  = 3'd2,
    INIT_SYNC_st      = 3'd3,
    WAIT_SYNC_st    = 3'd4,
    FETCH_BIT_st    = 3'd5,
    ERROR_st        = 3'd6,
    SUCCESS_st      = 3'd7;

reg [3:0] state, next_state;

reg data_ld;

// rx sync
reg rx_1, rx_synced;

// data shift register
reg [7:0] data_int, data_int_val;
reg data_int_ld;

// error register
reg error_set;
reg new_value_set;

// bit counter
reg [3:0] bit_cnt;
reg bit_cnt_ld, bit_cnt_en;

// sync counter
reg [15:0] sync_cnt, sync_cnt_val;
reg sync_cnt_ld, sync_cnt_en;


// next state
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state <= WAIT_START_st;
    end else begin
        state <= next_state;
    end
end

// rx sync
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        rx_1 <= 1;
        rx_synced <= 1;
    end else begin
        rx_1 <= rx;
        rx_synced <= rx_1;
    end
end

// data and data_int registers
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        data <= 0;
        data_int <= 0;
    end else begin
        if (data_ld) begin
            data <= data_int;
        end
        if (data_int_ld) begin
            data_int[bit_cnt] <= rx_synced;
        end
    end
end


// new value and error registers
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        error <= 0;
        new_value <= 0;
    end else begin
        if (clear) begin
            error <= 0;
            new_value <= 0;
        end
        if (new_value_set) begin 
            new_value <= 1;
        end
        if (error_set) begin 
            error <= 1;
        end
    end
end

// sync counter
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        sync_cnt <= 0;
    end else if (sync_cnt_ld) begin
        sync_cnt <= sync_cnt_val;
    end else if (sync_cnt_en) begin
        sync_cnt <= sync_cnt - 1;
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


// next state
always @(*) begin
    next_state = state;
    case (state)
        WAIT_START_st:
            if (!rx_synced) begin
                next_state = INIT_SYNC_START_st;
            end

        INIT_SYNC_START_st:
            next_state = WAIT_SYNC_START_st;

        WAIT_SYNC_START_st:
            if (sync_cnt == 0) begin
                if (rx_synced) begin
                    next_state = WAIT_START_st;
                end else begin
                    next_state = INIT_SYNC_st;
                end
            end

        INIT_SYNC_st:
            next_state = WAIT_SYNC_st;
        
        WAIT_SYNC_st:
            if (sync_cnt == 0) begin
                if (bit_cnt < 8) begin
                    next_state = FETCH_BIT_st;
                end else if (bit_cnt == 8 & !rx_synced) begin
                    next_state = ERROR_st;
                end else if (bit_cnt == 8 & rx_synced) begin
                    next_state = SUCCESS_st;
                end
            end

        FETCH_BIT_st:
            next_state = INIT_SYNC_st;

        ERROR_st:
            next_state = WAIT_START_st;

        SUCCESS_st:
            next_state = WAIT_START_st;

    endcase 
end


// output logic
always @(*) begin
    busy = 1;
    data_ld = 0;
    data_int_ld = 0;
    error_set = 0;
    new_value_set = 0;
    bit_cnt_ld = 0;
    bit_cnt_en = 0;
    sync_cnt_val = 0;
    sync_cnt_ld = 0;
    sync_cnt_en = 0;
    
    case (state)
        WAIT_START_st: begin
            busy = 0;
        end
        INIT_SYNC_START_st: begin
            sync_cnt_val = clock_cycles_per_pulse/2; // 1(INIT_SYNC) + 3 = 4 cycles
            sync_cnt_ld = 1;
            bit_cnt_ld = 1;
        end
        WAIT_SYNC_START_st: begin
            sync_cnt_en = 1;
        end
        INIT_SYNC_st: begin
            sync_cnt_val = clock_cycles_per_pulse;  // 6 + 1(FETCH) + 1(INIT_SYNC) = 8 cycles
            sync_cnt_ld = 1;
        end
        WAIT_SYNC_st: begin
            sync_cnt_en = 1;
        end
        FETCH_BIT_st: begin
            bit_cnt_en = 1;
            data_int_ld = 1;
        end
        ERROR_st: begin
            error_set = 1;
        end
        SUCCESS_st: begin
            new_value_set = 1;
            data_ld = 1;
        end
    endcase 
end

endmodule
