// Example of FFT Project

`timescale 1 ps / 1 ps
	
	
module fftSpectrumAnalyser(
	input clock50,						// 50 MHz Reference clock from FPGA
	input reset_n,						// Active low reset.
	
	
	input  wire        core_clk_clk,              //    core_clk.clk
	input  wire        core_rst_reset_n,          //    core_rst.reset_n
	input  wire        core_sink_valid,           //   core_sink.valid
	output wire        core_sink_ready,           //            .ready
	input  wire [1:0]  core_sink_error,           //            .error
	input  wire        core_sink_startofpacket,   //            .startofpacket
	input  wire        core_sink_endofpacket,     //            .endofpacket
	input  wire [47:0] core_sink_data,            //            .data
	output wire        core_source_valid,         // core_source.valid
	input  wire        core_source_ready,         //            .ready
	output wire [1:0]  core_source_error,         //            .error
	output wire        core_source_startofpacket, //            .startofpacket
	output wire        core_source_endofpacket,   //            .endofpacket
	output wire [68:0] core_source_data           //            .data

);


wire HPSClock;
wire reset = !reset_n;

	wire  [28:0] core_source_imag; // port fragment
	wire  [28:0] core_source_real; // port fragment
	wire  [10:0] core_fftpts_out;  // port fragment


	assign core_source_data = { core_source_real[28:0], core_source_imag[28:0], core_fftpts_out[10:0] };
	

fftSpectrum adcFFT (
		.clk(clock50),         // 133.33MHz reference clock.
		.reset_n(reset_n),      // Active low reset.
		
		// Input.
		. sink_valid(core_sink_valid),   //   sink.sink_valid
		.sink_ready(core_sink_ready),   //       .sink_ready
		.sink_error(core_sink_error),   //       .sink_error
		.sink_sop(core_sink_startofpacket),     //       .sink_sop
		.sink_eop(core_sink_endofpacket),     //       .sink_eop
		.sink_real(core_sink_data[47:30]),    //       .sink_real
		.sink_imag(core_sink_data[29:12]),    //       .sink_imag
		.fftpts_in(core_sink_data[11:1]),    //       .fftpts_in
		.inverse(core_sink_data[0]),      //       .inverse
		
		// Outputs
		.source_valid(core_source_valid), // source.source_valid
		.source_ready(core_source_ready), //       .source_ready
		.source_error(core_source_error), //       .source_error
		.source_sop(core_source_startofpacket),   //       .source_sop
		.source_eop(core_source_endofpacket),   //       .source_eop
		.source_real(core_source_real[28:0]),  //       .source_real
		.source_imag(core_source_imag[28:0]),  //       .source_imag
		.fftpts_out(core_fftpts_out[10:0])    //       .fftpts_out
	);
	
	
endmodule

