module hdmi_init(
	input wire clk_ref, //50MHz clock -> E11
	input wire select, //KEY0 -> AH17
	// input wire reset,
	output wire [7:0] current_value,
	inout wire i2c_sda, //PINOUT -> AA4 (HDMI_SDA)
	output wire i2c_scl //PINOUT -> U10 (HDMI_SCL)
);

wire clk_100hz;

reg [7:0] count = 0;
reg [7:0] limit = 8'd74; //75 values to be read from ROM
reg [1:0] three_count = 0; // For pulling three values at a time from ROM
reg		  start 		= 0;

wire [7:0] current_value_r;
reg [7:0] current_dev_id = 0;
reg [7:0] current_reg_id = 0;
reg [7:0] current_data = 0;

wire reset_n;
wire reset_n_n;
reg reset_toggle = 1;

reg initialized = 0;

wire [7:0] states;
wire ready;

assign current_value = current_value_r;

/*** STATES ***/

localparam STATE_START		= 0;
localparam STATE_IDLE		= 1;
localparam STATE_READ		= 2;
localparam STATE_WRITE		= 3;
localparam STATE_STOP		= 4;

reg [4:0] current_state		= STATE_START;
reg [4:0] next_state		= STATE_START;

sr_latch sr_latch_n(
	.S_n(select),
	.R_n(reset_toggle),
	.Q(reset_n),
	.Qn(reset_n_n)
);

i2c_clk_divider clk_divider(
	.reset_n(reset_n),
	.ref_clk(clk_ref),
	.i2c_clk(clk_100hz)
);

rom_hdmi rom (
	.address(count),
	.clock(clk_ref),
	.q(current_value_r)
);

i2c_controller i2c(
	.clk_in(clk_100hz),
	.reset_n(reset_n),
	.start(start),
	.dev_addr(current_dev_id),
	.reg_addr(current_reg_id),
	.data(current_data),
	.states(states),
	.i2c_sda(i2c_sda),
	.i2c_scl(i2c_scl),
	.ready_out(ready)
);

always @(posedge(clk_100hz)) begin: state_memory
	current_state <= next_state;
	reset_toggle = ~reset_toggle;
end

always @(current_state or reset_n or ready) begin: next_state_logic
	if (reset_n == 1'b0) begin
		next_state <= STATE_START;
	end

	else begin

		case (current_state)

			STATE_START: begin
				limit <= 8'd74;
				count <= 0;
				three_count <= 0;
				//current_value_r <= 0;
				current_dev_id <= 0;
				current_reg_id <= 0;
				current_data <= 0;
				initialized <= 0;
				// reset <= 1;

				next_state <= STATE_IDLE;

			end

			STATE_IDLE: begin
				if ((ready == 1'b1) && (initialized == 1'b0)) begin
					next_state <= STATE_READ;
				end
				else begin
					next_state <= STATE_IDLE;
				end
			end

			STATE_READ: begin
				case (three_count)
					0:
						begin
							three_count <= three_count + 1;
							current_dev_id = current_value_r;
							count = count + 1;
							next_state <= STATE_READ;
						end
					1:
						begin
							three_count <= three_count + 1;
							current_reg_id = current_value_r;
							count = count + 1;
							next_state <= STATE_READ;
						end
					2:
						begin
							three_count <= 0;
							current_data = current_value_r;
							count = count + 1;
							next_state <= STATE_WRITE;
						end
					default:
						begin
							next_state <= STATE_STOP;
						end
				endcase

			end

			STATE_WRITE: begin
				start <= 1;
				next_state <= STATE_STOP;
			end

			STATE_STOP: begin
				start <= 0;
				// if (count < limit) begin
					next_state <= STATE_IDLE;
				// end
			end

		endcase
	end

	
	
end

always @(current_state) begin: output_logic
	
end

endmodule