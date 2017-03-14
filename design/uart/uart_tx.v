//==============================================================================
// Design name : uart_tx
// File name   : uart_tx.v
// Function	   : UART transmit only module
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//==============================================================================

module uart_tx (
    input wire rst_n,
    input wire clk,
    input wire start,
    input wire [7:0] data_in,   
    output wire tx,
    output wire busy
);

typedef enum reg {IDLE_ST, SEND_START_ST, SEND_BIT_ST} state_t;

state_t state, next_state;

reg [7:0] data_reg;
reg [2:0] cnt_value;
wire [2:0] cnt_initial;
wire cnt_ld, cnt_en;
wire data_ld;

// next state
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE_ST;
        data_reg <= 0;
    end else begin
        state <= next_state:
        if (data_ld) begin
            data_reg <= data_in;
        end
    end
end


// bit counter
always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        cnt_value <= 0;
    end else if (cnt_ld) begin
        cnt_value <= cnt_initial;
    end else if (cnt_en) begin
        cnt_value <= data_cnt + 1;
    end
end


// next state
always @(*) begin
    next_state <= state;
    case (state)
        IDLE_ST:
            if (start) begin
                next_state <= SEND_START_ST;
            end
        SEND_START_ST:
            next_state <= SEND_BIT_ST;
        SEND_BIT_ST:
            if (bit_cnt == 8) begin
                next_state <= IDLE;
            end
    endcase 
end


// output logic
always @(*) begin
    tx <= 1;
    busy <= 0;
    data_ld = 0;
    cnt_initial <= 3'd1;
    cnt_ld <= 0;
    cnt_en <= 0;
    case (state)
        IDLE_ST:
            tx <= 1;
            busy <= 1;
            if (start) begin
                data_ld = 1;
            end
        SEND_START_ST:
            tx <= 0;
            busy <= 1;
            cnt_ld <= 1;
        SEND_BIT_ST:
            tx <= data_empty[data_cnt];
            busy <= 1;
            cnt_en <= 1;
    endcase 
end


endmodule;
