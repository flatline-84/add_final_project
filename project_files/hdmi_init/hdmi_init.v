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
    inout wire i2c_sda,    //AA24
    output wire i2c_scl     //W15
     //PINOUT -> AA4 (HDMI_SDA)
     //PINOUT -> U10 (HDMI_SCL)
	  //GPIO BANK 1 (right side, ethernet port facing down)
	  //PIN1 -> Y15 (SDA)
	  //PIN2 -> AC24 (SCL)
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

reg initialized             = 0;
reg [4:0] count             = 0;
reg [15:0] data             = 0;

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
reg [7:0] current_reg_id    = 8'h00;
reg [7:0] current_data      = 8'h00;

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

always @(negedge(clk_ref)) begin
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
                STATE_BEGIN: begin //actually the reset state
                    start <= 0;
                    count <= 0;
                    initialized <= 0;
					current_state <= STATE_IDLE;
                end

                STATE_IDLE: begin
                    if (count == 31) begin
                        initialized <= 1;
                        start <= 0;
                    end

                    if (ready == 1'b1 && initialized == 1'b0) begin
                        current_state <= STATE_WRITE;
                    end
                    else begin
                        current_state <= STATE_IDLE;                    
                    end
                end

                STATE_WRITE: begin
                    start <= 1;
                    current_state <= STATE_STOP;
                end

                STATE_CHECK: begin
                    current_state <= STATE_STOP;
                end

                STATE_STOP: begin
                    count <= count + 1;
                    current_state <= STATE_IDLE;
                end

                default: begin
                    current_state <= STATE_STOP;
                end

        endcase
    end
end

always @(*)
begin
	case(count)
		
		//	Video Config Data
		0	:	data	<=	16'h9803;  //Must be set to 0x03 for proper operation
		1	:	data	<=	16'h0100;  //Set 'N' value at 6144
		2	:	data	<=	16'h0218;  //Set 'N' value at 6144
		3	:	data	<=	16'h0300;  //Set 'N' value at 6144
		4	:	data	<=	16'h1470;  // Set Ch count in the channel status to 8.
		5	:	data	<=	16'h1520;  //Input 444 (RGB or YCrCb) with Separate Syncs, 48kHz fs
		6	:	data	<=	16'h1630;  //Output format 444, 24-bit input
		7	:	data	<=	16'h1846;  //Disable CSC
		8	:	data	<=	16'h4080;  //General control packet enable
		9	:	data	<=	16'h4110;  //Power down control
		10	:	data	<=	16'h49A8;  //Set dither mode - 12-to-10 bit
		11	:	data	<=	16'h5510;  //Set RGB in AVI infoframe
		12	:	data	<=	16'h5608;  //Set active format aspect
		13	:	data	<=	16'h96F6;  //Set interrupt
		14	:	data	<=	16'h7307;  //Info frame Ch count to 8
		15	:	data	<=	16'h761f;  //Set speaker allocation for 8 channels
		16	:	data	<=	16'h9803;  //Must be set to 0x03 for proper operation
		17	:	data	<=	16'h9902;  //Must be set to Default Value
		18	:	data	<=	16'h9ae0;  //Must be set to 0b1110000
		19	:	data	<=	16'h9c30;  //PLL filter R1 value
		20	:	data	<=	16'h9d61;  //Set clock divide
		21	:	data	<=	16'ha2a4;  //Must be set to 0xA4 for proper operation
		22	:	data	<=	16'ha3a4;  //Must be set to 0xA4 for proper operation
		23	:	data	<=	16'ha504;  //Must be set to Default Value
		24	:	data	<=	16'hab40;  //Must be set to Default Value
		25	:	data	<=	16'haf16;  //Select HDMI mode
		26	:	data	<=	16'hba60;  //No clock delay
		27	:	data	<=	16'hd1ff;  //Must be set to Default Value
		28	:	data	<=	16'hde10;  //Must be set to Default for proper operation
		29	:	data	<=	16'he460;  //Must be set to Default Value
		30	:	data	<=	16'hfa7d;  //Nbr of times to look for good phase

		default:		data	<=	16'h9803;
	endcase

	current_reg_id 	<= data[15:8];
	current_data 	<= data[7:0];
	
end



endmodule