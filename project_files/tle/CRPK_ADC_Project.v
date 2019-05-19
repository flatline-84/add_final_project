module CRPK_ADC_Project
(
	output sdl_a,
	output scl_a,
	output ena,
	output [7:0] out
);

reg en;
wire [7:0] output_wire;
wire sdl;
wire scl;
wire clk;
wire reset;

i2c_test i2c_test(
	.clk(clk),
	.reset(reset),
	.i2c_sda(sdl),
	.i2c_scl(scl)
);




//i2c_master i2c(
//	.clock_freq(1'b1),
//	.dev_id(7'b0000000),
//	.addr(8'b11111111),
//	.input_data(8'b11111111),
//	.read_write(1'b1),
////	.enable(ena),
//	.output_data(out),
//	.sdl(sdl_a),
//	.scl(scl_a)
//);

assign test = 1'b0;
 assign sdl_a = sdl;
 assign scl_a = scl;
// assign out = output_wire;

endmodule