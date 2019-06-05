//TLE

module hdmi_controller (
	input wire clock50,       	// 50MHz -> V11
	input wire select,        	// KEY0 -> AH17
	input wire reset_toggle,  	// KEY1 -> AH16
	
	input wire hdmi_tx_int,   	// PIN_AF11
	output wire hsync,			// PIN T8
	output wire vsync,			// PIN V13
	output wire v_clk,			// PIN AG5 
	output wire data_enable,	// PIN AD19
	output wire [23:0] rgb_data,
	/* DATA PINS (0->23)
		AD12
		AE12
		W8
		Y8
		AD11
		AD10
		AE11
		Y5
		AF10
		Y4
		AE9
		AB4
		AE7
		AF6
		AF8
		AF5
		AE4
		AH2
		AH4
		AH5
		AH6
		AG6
		AF9
		AE8
	*/
	//Output LED shit
	output wire led_reset,		// LED4 -> AF26
	output wire led_ack,		// LED7 -> AA23
	
	// SPI shit
	output wire spi_scl,		// V10 		|| PIN_AC24
	output wire spi_sdi,		// AC4		|| PIN_AA15
	input wire spi_sdo,		// AD4		|| PIN_AD4
	output wire CONVST,			// U9		|| PIN_Y15

	output wire [7:0] leds,
	/* LEDS(7->0)
		AA23
		Y16
		AE26
		AF26
		V15
		V16
		AA24
		W15
	*/

	// I2C Shit
	output wire i2c_scl,      // U10 (HDMI_SCL)
	inout wire i2c_sda        // AA4 (HDMI_SDA)
);

wire reset;
wire reset_n;
assign led_reset = reset;

sr_latch sr_latch_n(
	.S_n(select),
	.R_n(reset_toggle),
	.Q(reset),
	.Qn(reset_n)
);


hdmi_init hdmit_init_mod (
	.reset_not(reset_n),
	.clk_ref(clock50),
	.ready_out(led_ack),
	.hdmi_tx_int(hdmi_tx_int),
	.i2c_sda(i2c_sda),
	.i2c_scl(i2c_scl)
);

wire locked;
wire clock74;

pll pll74 ( //74.25MHz for 720p
		.refclk(clock50),   //  refclk.clk
		.rst(reset),      //   reset.reset
		.outclk_0(clock74), // outclk0.clk
		.locked(locked)    //  locked.export
);

wire clock60;

// i2c_clk_divider 
// #(.DELAY(8333333)) //close enough to 60Hz
// clk_divider_60
// (
// 	.reset(reset),
// 	.ref_clk(clock50),
// 	.i2c_clk(clock60)
// );

//ADC Channel Reading (12 bits)
wire [11:0] channel_1;
wire [11:0] channel_2;
wire [11:0] channel_3;
wire [11:0] channel_4;

top_sync_vg_pattern display (
	.clk_in(clock74),
	// .clock60(clock60),
	.reset(reset),
	.hsync(hsync),
	.vsync(vsync),
	.v_clk(v_clk),
	.channel_1(channel_1),
	.channel_2(channel_2),
	.channel_3(channel_3),
	.channel_4(channel_4),
	.data_enable(data_enable),
	.rgb_data(rgb_data)
);



SPIControlBlock spi_control_block (

	.ref_clk(clock50),
	.reset_n(reset_n),
	.start(reset_n),

	.data(channel_1), //Data from SPI to TLE
	.data_1(channel_2), //Data from SPI to TLE
	.data_2(channel_3), //Data from SPI to TLE
	.data_3(channel_4), //Data from SPI to TLE

	.LEDs(leds),

	.spi_sdo(spi_sdo), // PIN_AD4
	.spi_sdi(spi_sdi), // PIND_AC4
	.spi_scl(spi_scl), // PIN_V10
	.CONVST(CONVST)  // PIN_U9

);

// hdmi_controller_display display (

//     .clock50(clock50),
//     .reset(reset),

//     // Output wires
//     .hsync(hsync), 
//     .vsync(vsync), 
//     .v_clk(v_clk), 
//     .data_enable(data_enable), 
//     .rgb_data(rgb_data) 
// );


endmodule