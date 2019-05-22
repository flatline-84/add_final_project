module hdmi_init(
	input wire clk_ref, //50MHz clock
	input wire reset,
	output wire [7:0] current_value
);

wire clk_100hz;

reg [7:0] count = 0;
reg [7:0] limit = 8'd74; //75 values to be read from ROM
reg [1:0] three_count = 0; // For pulling three values at a time from ROM

reg [7:0] current_value_r = 0;
reg [7:0] current_dev_id = 0;
reg [7:0] current_reg_id = 0;
reg [7:0] current_data = 0;

assign current_value = current_value_r;

/*** STATES ***/

localparam STATE_START		= 0;
localparam STATE_IDLE		= 1;
localparam STATE_READ		= 2;
localparam STATE_WRITE		= 3;
localparam STATE_STOP		= 4;

reg [4:0] current_state		= STATE_START;
reg [4:0] next_state		= STATE_START;

i2c_clk_divider clk_divider(
	.reset(reset),
	.ref_clk(clk_ref),
	.i2c_clk(clk_100hz)
);

rom_hdmi rom (
	.address(count),
	.clock(clk_100hz),
	.q()
	
);

always @(posedge(clk_100hz)) begin: state_memory
	current_state <= next_state;
end

always @(current_state) begin: next_state_logic

	
end

always @(current_state) begin: output_logic
	
end

endmodule