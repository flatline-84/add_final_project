module hdmi_init (
    input wire select,      //KEY0 -> AH17
    input wire clk_ref,     //50MHz -> V11
	output wire[3:0] state_out,
	output wire clk_100hz_out,
	output wire ready_out,
    output wire[7:0] i2c_states,
    // LED4 -> AF26
    // LED5 -> AE26
    // LED6 -> Y16
    // LED7 -> AA23
    output wire i2c_sda,    //AA24
    output wire i2c_scl     //W15
);

// localparam STATE_BEGIN      = 0;
// localparam STATE_IDLE       = 1;
// localparam STATE_WRITE      = 2;
// localparam STATE_CHECK      = 3;
// localparam STATE_STOP       = 4;
localparam STATE_BEGIN      = 4'b0001;
localparam STATE_IDLE       = 4'b0010;
localparam STATE_WRITE      = 4'b0100;
localparam STATE_CHECK      = 4'b1000;
localparam STATE_STOP       = 4'b1111;

reg [3:0] current_state     = STATE_BEGIN;
assign state_out 		    = current_state;

reg i2c_sda_wire;
reg i2c_scl_wire;

//assign i2c_sda              = i2c_sda_wire;
//assign i2c_scl              = i2c_scl_wire;

reg reset_toggle            = 1;
wire reset;
wire reset_n;

wire clk_100hz;
assign clk_100hz_out = clk_100hz;

reg [7:0] current_dev_id    = 8'h72;
reg [7:0] current_reg_id    = 8'ha5;
reg [7:0] current_data      = 8'h33;

reg start = 0;
wire ready;
assign ready_out = ready;

i2c_clk_divider clk_divider(
	.reset(reset),
	.ref_clk(clk_ref),
	.i2c_clk(clk_100hz)
);

i2c_controller i2c(
	.clk_in(clk_ref),
	.reset(reset),
	.start(start),
	.dev_addr(current_dev_id),
	.reg_addr(current_reg_id),
	.data(current_data),
	.states(i2c_states),
	.i2c_sda(i2c_sda),
	.i2c_scl(i2c_scl),
	.ready_out(ready)
);

sr_latch sr_latch_n(
	.S_n(select),
	.R_n(reset_toggle),
	.Q(reset),
	.Qn(reset_n)
);

// always @(posedge(ready)) begin
//     start = 0;    
// end

always @(negedge(clk_ref)) begin
    if (reset == 1'b1) begin
        reset_toggle <= 0;
    end
    else begin
        reset_toggle <= 1;
    end
end

always @(posedge(clk_ref)) begin: main_state_machine_loop

    if (reset == 1'b1) begin
        current_state <= STATE_BEGIN;
    end

    else begin
            case(current_state)
                STATE_BEGIN: begin
                    start <= 0;
						  current_state <= STATE_IDLE;
                end

                STATE_IDLE: begin
                    if (ready) begin
                        current_state <= STATE_WRITE;
                    end

                    else begin
                        current_state <= STATE_IDLE;                    
                    end
                end

                STATE_WRITE: begin
                    start <= 1;
                    current_state <= STATE_CHECK;
                end

                STATE_CHECK: begin

                    current_state <= STATE_STOP;
                end

                STATE_STOP: begin

                    current_state <= STATE_IDLE;
                end

                default: begin
                    current_state <= STATE_STOP;
                end

        endcase
    end
end

endmodule