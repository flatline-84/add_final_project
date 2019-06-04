module hdmi_init (
    input wire select,      //KEY0 -> AH17
	input wire reset_toggle, //KEY1 -> AH16
	input wire reset_not,
    input wire clk_ref,     //50MHz -> V11
	input wire hdmi_tx_int, //PIN_AF11
	output wire[3:0] state_out,
	output wire clk_100hz_out,
	output wire ready_out,
	output wire reset_out,
    output wire[7:0] i2c_states,
    // LED4 -> AF26
    // LED5 -> AE26
    // LED6 -> Y16
    // LED7 -> AA23
	output wire ack_out,
    inout wire i2c_sda,    //AA24
    output wire i2c_scl,     //W15
	output wire i2c_sda_test,
	output wire i2c_scl_test
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

reg [3:0] state     = STATE_BEGIN;
assign state_out 		    = state;

reg initialized             = 0;
reg [5:0] count             = 0;
reg [15:0] data             = 8'h00;
reg [2:0] delay				= 0;
reg [5:0] limit				= 6'd25;
//reg [15:0] i2c_data			= 0;

reg i2c_sda_wire;
reg i2c_scl_wire;

assign i2c_scl_test = i2c_scl;
assign i2c_sda_test = i2c_sda;

//assign i2c_sda              = i2c_sda_wire;
//assign i2c_scl              = i2c_scl_wire;

// reg reset_toggle            = 1;
wire reset = ~reset_not;
// wire reset_n;

assign reset_out = reset;

wire clk_100hz;
assign clk_100hz_out = clk_100hz;

reg [7:0] current_dev_id    = 8'h72;
// reg [7:0] current_reg_id    = 8'h00;
//reg [15:0] current_data      = 8'h00;

reg start = 0;
wire ready;
assign ready_out = initialized;

i2c_clk_divider 
// #(.DELAY(5000))
#(.DELAY(250)) //for sim
clk_divider
(
	.reset(reset),
	.ref_clk(clk_ref),
	.i2c_clk(clk_100hz)
);

i2c_controller i2c(
	.clk_in(clk_100hz),
	.reset(reset),
	.start(start),
	.dev_addr(current_dev_id),
	.reg_data(data),
	.states(i2c_states),
	.ack(ack_out),
	.i2c_sda(i2c_sda),
	.i2c_scl(i2c_scl),
	.ready_out(ready)
);

// sr_latch sr_latch_n(
// 	.S_n(select),
// 	.R_n(reset_toggle),
// 	.Q(reset),
// 	.Qn(reset_n)
// );

/*
always @(posedge(clk_100hz) or posedge(reset)) begin
	if (reset) begin
		initialized 	<= 0;
		count			<= 0;
		state			<= 0;
		start			<= 0;
	end
	else begin
		if (count < 31) begin
			initialized <= 0;

			case (state)
				0: begin
					i2c_data <= data;
					start <= 1;
					state <= 1;
				end

				1: begin
					if (ready) begin
						if (!ack_out) begin //drop this to not
							state <= 2;
						end

						else begin
							state <= 0;
							start <= 0;
						end
					end
				end
				
				2: begin	
					count <= count + 1'b1;
					state <= 0;
				end
			endcase
		end

		else begin
			initialized <= 1;
			if (!hdmi_tx_int) begin
				count <= 0;
			end
			else begin
				count <= count;
			end
		end
	end
end*/
// always @(negedge(clk_100hz)) begin
//     if (reset == 1'b1) begin
//         reset_toggle <= 0;
//     end
//     else begin
//         reset_toggle <= 1;
//     end
// end


always @(posedge(clk_100hz) or negedge(reset_not)) begin: main_state_machine_loop

    if (reset_not == 1'b0) begin
        state <= STATE_BEGIN;
    end

    else begin
            case(state)
                STATE_BEGIN: begin //actually the reset state
                    start 			<= 0;
                    count 			<= 0;
                    initialized 	<= 0;
					delay 			<= 0;
					state 	<= STATE_IDLE;
                end

                STATE_IDLE: begin
					if (delay < 4) begin //stop it from cooking
						delay = delay + 1;
					end

					// else if (initialized) begin
					// 	state <= STATE_BEGIN;
					// end

                    else if (count == limit && initialized == 1'b0) begin
                        initialized <= 1;
                        start <= 0;

                    end

                    else if (ready == 1'b1 /*) begin*/ && initialized == 1'b0) begin
                        state <= STATE_WRITE;
                    end
					
					// else if (ready == 1'b1 && initialized == 1'b1) begin //just fucking spam the shit out of it
					// 	state <= STATE_WRITE;
					// end
					
                    else begin
                        state <= STATE_IDLE;                    
                    end
                end

                STATE_WRITE: begin
                    start <= 1;
                    state <= STATE_CHECK;
                end

                STATE_CHECK: begin //buffer
                    state <= STATE_STOP;
                end

                STATE_STOP: begin
                    start <= 0;
					/*if (initialized && ready_out) begin
						state <= STATE_IDLE;
					end*/
					if (ready_out) begin
						// if (!ack_out) begin //no acknowledge from device
						// 	state <= STATE_BEGIN;
						// end
						// else begin
							if (!initialized) begin
								delay <= 0;
								count <= count + 1;	
							end
							state <= STATE_IDLE;
						// end
						// else begin
							// state <= STATE_IDLE;
						// end
					end

					// else begin
					// 	state <= STATE_IDLE;
					// end
                end

                default: begin
                    state <= STATE_STOP;
                end

        endcase
    end
end

// From spec sheet
always @(*) begin
	case (count)
		0	:	data	<=	16'h0000; 
		1	:	data	<=	16'h0100;  //Set 'N' value at 6144
		2	:	data	<=	16'h0218;  //Set 'N' value at 6144
		3	:	data	<=	16'h0300;  //Set 'N' value at 6144
		4	:	data	<=	16'h1500; 
		5	:	data	<=	16'h1661;  
		6	:	data	<=	16'h1846;  
		7	:	data	<=	16'h4080;  
		8	:	data	<=	16'h4110;  
		9	:	data	<=	16'h4848;  
		10	:	data	<=	16'h48a8;  
		11	:	data	<=	16'h4c06;  
		12	:	data	<=	16'h5500;  
		13	:	data	<=	16'h5508;  
		14	:	data	<=	16'h9620;  
		15	:	data	<=	16'h9803;  
		16	:	data	<=	16'h9802;  
		17	:	data	<=	16'h9c30;  
		18	:	data	<=	16'h9d61;  
		19	:	data	<=	16'ha2a4;  
		20	:	data	<=	16'h43a4;  
		21	:	data	<=	16'haf16;  
		22	:	data	<=	16'hba60;  
		23	:	data	<=	16'hde9c;  
		24	:	data	<=	16'he460;  
		25	:	data	<=	16'hfa7d;  

		default:
			data <= 16'hfa7d;
	endcase
end

/*
always @(*)
begin
	case(count)
		
		//	Video Config Data
		// 0	: 	data 	<=  16'haaaa;   // This is the broken state. I can't fix shit
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
		13	:	data	<=	16'h96F6;  //Set interrup
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

		default:		data	<=	16'h0000;
	endcase

//	current_reg_id 	<= data[15:8];
	// current_data 	<= data[15:0];
	
end*/

/*
always @(*)
begin
	case(count)
		
		//	Video Config Data
		0	: 	data 	<=  16'h0000;   // This is the broken state. I can't fix shit
		1	:	data	<=	16'h9803;  //Must be set to 0x03 for proper operation
		2	:	data	<=	16'h0100;  //Set 'N' value at 6144
		3	:	data	<=	16'h0218;  //Set 'N' value at 6144
		4	:	data	<=	16'h0300;  //Set 'N' value at 6144
		5	:	data	<=	16'h1470;  // Set Ch count in the channel status to 8.
		6	:	data	<=	16'h1520;  //Input 444 (RGB or YCrCb) with Separate Syncs, 48kHz fs
		7	:	data	<=	16'h1630;  //Output format 444, 24-bit input
		8	:	data	<=	16'h1846;  //Disable CSC
		9	:	data	<=	16'h4080;  //General control packet enable
		10	:	data	<=	16'h4110;  //Power down control
		11	:	data	<=	16'h49A8;  //Set dither mode - 12-to-10 bit
		12	:	data	<=	16'h5510;  //Set RGB in AVI infoframe
		13	:	data	<=	16'h5608;  //Set active format aspect
		14	:	data	<=	16'h96F6;  //Set interrup
		15	:	data	<=	16'h7307;  //Info frame Ch count to 8
		16	:	data	<=	16'h761f;  //Set speaker allocation for 8 channels
		17	:	data	<=	16'h9803;  //Must be set to 0x03 for proper operation
		18	:	data	<=	16'h9902;  //Must be set to Default Value
		19	:	data	<=	16'h9ae0;  //Must be set to 0b1110000
		20	:	data	<=	16'h9c30;  //PLL filter R1 value
		21	:	data	<=	16'h9d61;  //Set clock divide
		22	:	data	<=	16'ha2a4;  //Must be set to 0xA4 for proper operation
		23	:	data	<=	16'ha3a4;  //Must be set to 0xA4 for proper operation
		24	:	data	<=	16'ha504;  //Must be set to Default Value
		25	:	data	<=	16'hab40;  //Must be set to Default Value
		26	:	data	<=	16'haf16;  //Select HDMI mode
		27	:	data	<=	16'hba60;  //No clock delay
		28	:	data	<=	16'hd1ff;  //Must be set to Default Value
		29	:	data	<=	16'hde10;  //Must be set to Default for proper operation
		30	:	data	<=	16'he460;  //Must be set to Default Value
		31	:	data	<=	16'hfa7d;  //Nbr of times to look for good phase

		default:		data	<=	16'h0000;
	endcase

//	current_reg_id 	<= data[15:8];
	// current_data 	<= data[15:0];
	
end
*/



endmodule