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
	input wire signed [fp_width-1:0] IN1,
	input wire signed [fp_width-1:0] IN2,
	input wire signed [fp_width-1:0] weight1_new,
	input wire signed [fp_width-1:0] weight2_new,
	input wire weight1_ld,
	input wire weight2_ld,
	output reg signed [fp_width-1:0] weight1,
	output reg signed [fp_width-1:0] weight2,
	output wire result
);

    parameter fp_integer_width = 4;
    parameter fp_fract_width = 12;

    localparam fp_width = fp_integer_width + fp_fract_width;

    // intermediate wires for calculations
	wire signed [fp_width*2-1:0] weighted_in1;
	wire signed [fp_width*2-1:0] weighted_in2;
	wire signed [fp_width-1:0] weighted_sum;

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
	//assign weighted_in1 = ( {{(fp_integer_width+fp_fract_width){IN1[fp_integer_width+fp_fract_width-1]}}, IN1} * {{(fp_integer_width+fp_fract_width){weight1[fp_integer_width+fp_fract_width-1]}}, weight1} ) >> fp_fract_width;
	//assign weighted_in2 = ( {{(fp_integer_width+fp_fract_width){IN2[fp_integer_width+fp_fract_width-1]}}, IN2} * {{(fp_integer_width+fp_fract_width){weight2[fp_integer_width+fp_fract_width-1]}}, weight2} ) >> fp_fract_width;

	assign weighted_in1 = (IN1 * weight1 ) >> fp_fract_width;
	assign weighted_in2 = (IN2 * weight2 ) >> fp_fract_width;


	assign weighted_sum = (weighted_in1[fp_width-1:0]) + (weighted_in2[fp_width-1:0]);

	// threshold activation function
	assign result = !weighted_sum[fp_width-1];

endmodule
