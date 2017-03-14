module perceptron_iceZUM_alhambra (
	input wire [3:0] A_IO,
	input wire [3:0] B_IO,
	output wire [3:0] RES_IO	
);

	perceptron i_perceptron(
		.a(A_IO),
		.b(B_IO),
		.res(RES_IO)
	);

endmodule
