//==============================================================================
// Design name : perceptron
// File name   : perceptron.v
// Function	   : perceptron implementation
// Engineer    : Dennis Pinto Rivero danielpintoriv@gmail.com
//
// Notes:
//==============================================================================

module perceptron (
	input wire rst_n,
	input wire clk,
	input wire [15:0] IN1,
	input wire [15:0] IN2,
	input wire [15:0] weight1_new,
	input wire [15:0] weight2_new,
	input wire weight1_ld,
	input wire weight2_ld,
	output reg [15:0] weight1,
	output reg [15:0] weight2,
	output wire result
);

	wire [15:0] weighted_in1;	// intermediate wires for calculations
	wire [15:0] weighted_in2;
	wire [15:0] weighted_sum;

	// weight registers
	always @(posedge clk, negedge rst_n) begin
		if (!rst_n) begin
			weight1 <= 0;
			weight2 <= 0;
		end else begin
			if (weight1_ld) begin
				weight1 <= weight1_new;
			end 
			if (weight2_ld) begin
				weight2 <= weight2_new;
			end
		end
	end


	// When multiplying fixed-point numbers, the number fo bits of the decimal
	// part is the sum of the number of deciman bits of the operands, in this 
	// case, 12+12=24. As the result register only has 12 decimal bits, it
	// has to be truncated to maintain the 16MSBs
	assign weighted_in1 = ( {{16{IN1[15]}}, IN1} * {{16{weight1[15]}}, weight1} ) >> 12;
	assign weighted_in2 = ( {{16{IN2[15]}}, IN2} * {{16{weight2[15]}}, weight2} ) >> 12;

	assign weighted_sum = weighted_in1 + weighted_in2;

	// threshold activation function
	assign result = !weighted_sum[15];

endmodule
