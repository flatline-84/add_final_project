

module ADC_FFT_Block (

	input  ref_clk,
	input  reset_n,
	input  start,
	input  spi_sdo,

	output  [6:0] addr,
	output  [11:0] data, //Data from SPI to TLE

	output spi_sdi,
	output spi_scl,
	output ready,
	output CONVST,
	
	output spi_sdo_gpio,
	output spi_sdi_gpio,
	output spi_scl_gpio,
	output CONVST_gpio,
	
	output reg [7:0] LEDs,
	

	output [2:0] o_currentState,
	output [2:0] o_nextState

);







endmodule
