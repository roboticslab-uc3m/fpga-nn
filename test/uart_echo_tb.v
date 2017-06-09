//==============================================================================
// Testbench name 	 : uart_echo_tb
// File name   : uart_echo_tb.v
// Function	   : Test for the UART echo application.
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes:
//==============================================================================

`timescale 1ns/1ps

module uart_echo_tb;


localparam clock_frequency = 12000000;
localparam clk_pulse_width = 1000000000/clock_frequency;
localparam baud_rate = 9600;

// common signals
reg clk, rst_n;

// dut uart_echo interface
wire dut_rx;
wire dut_tx;
wire [7:0] dut_num_recv_bytes;

// probe uart interface
reg probe_clear;
reg probe_transmit;
wire probe_tx_busy;
wire probe_rx_busy;
wire probe_error;
wire probe_new_data;
reg [7:0] probe_data_to_send;
wire [7:0] probe_received_data;

// test data
reg [7:0] data [0:7];
integer i;

`define assert(cond, msg) if(cond) begin $display(" ASSERT FAILED: %s", msg); #(1000*clk_pulse_width) $finish; end

uart_echo #(
	.clock_frequency(clock_frequency),
	.baud_rate(baud_rate)
) dut (
	.rst_n(rst_n),
	.clk(clk),
    .byte_cnt(dut_num_recv_bytes),
	.rx(dut_rx),
	.tx(dut_tx)
);

uart #(
	.clock_frequency(clock_frequency),
	.baud_rate(baud_rate)
) uart_probe (
    .rst_n(rst_n),
    .clk(clk),
    .rx(dut_tx),
	.tx(dut_rx),
    .clear(probe_clear),
	.start_transmit(probe_transmit),
    .tx_busy(probe_tx_busy),
	.rx_busy(probe_rx_busy),
    .error(probe_error),
    .new_value(probe_new_data),
	.data_to_send(probe_data_to_send),
    .recvd_data(probe_received_data)
);

// Dump variables
initial begin
    $dumpvars(0, dut);
    $dumpvars(0, uart_probe);
end

// Clock
always #(clk_pulse_width/2) clk = !clk;

// Reset
initial begin
	$display("Time %d", $time);
	clk = 0;
    rst_n = 0;
	repeat (5) @(negedge clk);
	rst_n = 1;
end


// test data initialization
initial begin
    data[0] = 8'hAB;
    data[1] = 8'hCD;
    data[2] = 8'hEF;
    data[3] = 8'h15;
    data[4] = 8'h77;
    data[5] = 8'h34;
    data[6] = 8'h43;
    data[7] = 8'h6B;
end

// testbench RECEIVE
initial begin
    probe_clear = 1;

	wait( rst_n );
    
	$display("[Time %d]: Started testbench RECEIVE", $time);

    while (1) begin
        @(posedge clk);
        @(negedge clk);
        wait(probe_new_data);
        $display("Received value: %h", probe_received_data);
    end
end

// testbench SEND
initial begin
    probe_transmit = 0;
    probe_data_to_send = 0;
	wait( rst_n );
    
	$display("[Time %d]: Started testbench SEND", $time);

    for (i = 0; i < 8; i = i+1) begin
        `assert(probe_error, "Probe UART error.")
    
        @(negedge clk);
        probe_data_to_send = data[i];
        probe_transmit = 1;
        $display("[Time %d]: Send data %d", $time, i);
        wait(probe_tx_busy);
        $display("[Time %d]: Started sending data %d", $time, i);
        probe_transmit = 0;
        wait(!probe_tx_busy);
        $display("[Time %d]: Finished sending data %d", $time, i);
    end

	$finish;
end

endmodule // uart_echo_tb
