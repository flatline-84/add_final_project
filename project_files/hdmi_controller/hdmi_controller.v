//TLE

module hdmi_controller (
	input wire clock50,       	// 50MHz -> V11
	input wire select,        	// KEY0 -> AH17
	input wire reset_toggle,  	// KEY1 -> AH16
	
	input wire hdmi_tx_int,   	// PIN_AF11
	output wire hsync,			// PIN T8
	output wire vsync,			// PIN V13
	output wire v_clk,			// PIN AG5 //idk what this does, TMDS clock needs to 10x vid clock
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
	
	output wire i2c_scl,      // U10 (HDMI_SCL)
	inout wire i2c_sda        // AA4 (HDMI_SDA)
);

wire reset;
wire reset_n;

sr_latch sr_latch_n(
	.S_n(select),
	.R_n(reset_toggle),
	.Q(reset),
	.Qn(reset_n)
);

hdmi_init hdmit_init_mod (
	.reset_not(reset_n),
	.clk_ref(clock50),
	.hdmi_tx_int(hdmi_tx_int),
	.i2c_sda(i2c_sda),
	.i2c_scl(i2c_scl)
);


hdmi_controller_display display (

    .clock50(clock50),
    .reset(reset),

    // Output wires
    .hsync(hsync), 
    .vsync(vsync), 
    .v_clk(v_clk), 
    .data_enable(data_enable), 
    .rgb_data(rgb_data) 
);


endmodule