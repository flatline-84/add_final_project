module hdmi_init (
    input wire select,      //KEY0 -> AH17
    input wire clk_ref,     //50MHz -> V11
	output wire[3:0] state_out,
    output wire i2c_sda,    //W15
    output wire i2c_scl     //AA24
);

localparam STATE_BEGIN      = 0;
localparam STATE_IDLE       = 1;
localparam STATE_WRITE      = 2;
localparam STATE_CHECK      = 3;
localparam STATE_STOP       = 4;

reg [3:0] current_state     = STATE_BEGIN;
assign state_out 		    = current_state;

reg i2c_sda_wire;
reg i2c_scl_wire;

assign i2c_sda              = i2c_sda_wire;
assign i2c_scl              = i2c_scl_wire;

reg reset_toggle            = 1;
wire reset;
wire reset_n;

wire clk_100hz;

i2c_clk_divider clk_divider(
	.reset(reset),
	.ref_clk(clk_ref),
	.i2c_clk(clk_100hz)
);

sr_latch sr_latch_n(
	.S_n(select),
	.R_n(reset_toggle),
	.Q(reset),
	.Qn(reset_n)
);

always @(negedge(clk_100hz)) begin
    if (reset == 1'b1) begin
        reset_toggle <= 0;
    end
    else begin
        reset_toggle <= 1;
    end
end

always @(posedge(clk_100hz)) begin: main_state_machine_loop

    if (reset == 1'b1) begin
        current_state <= STATE_BEGIN;
    end

    else begin
            case(current_state)
                STATE_BEGIN: begin
                    i2c_sda_wire <= 1;
                    i2c_scl_wire <= 1;

                    current_state <= STATE_IDLE;
                end

                STATE_IDLE: begin
                    i2c_sda_wire <= 0;
                    i2c_scl_wire <= 1;
                    current_state <= STATE_WRITE;
                end

                STATE_WRITE: begin
                    i2c_sda_wire <= 0;
                    i2c_scl_wire <= 0;
                    current_state <= STATE_CHECK;
                end

                STATE_CHECK: begin
                    i2c_sda_wire <= 1;
                    i2c_scl_wire <= 0;
                    current_state <= STATE_STOP;
                end

                STATE_STOP: begin
                    i2c_sda_wire <= ~i2c_sda_wire;
                    i2c_scl_wire <= ~i2c_scl_wire;
                    current_state <= STATE_STOP;
                end

                default: begin
                    current_state <= STATE_STOP;
                end

        endcase
    end
end

endmodule