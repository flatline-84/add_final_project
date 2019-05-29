//`default net_type none

module i2c_master(
	input wire clk,
	input wire reset,
	input wire start,
	input wire [7:0] dev_id,
	input wire [7:0] reg_id,
	input wire [7:0] data,
	inout wire i2c_sda,
	output wire i2c_scl,
	output wire ready,
	output wire[7:0] states
);

localparam STATE_IDLE = 0;
localparam STATE_START = 1;
localparam STATE_ADDR = 2;
localparam STATE_RW = 3;
localparam STATE_WACK = 4;
localparam STATE_REG_ADDR = 5;
localparam STATE_STOP = 6;
localparam STATE_WACK2 = 7;
localparam STATE_DATA = 8;
localparam STATE_WACK3 = 9;
localparam STATE_PRE_STOP = 10;

reg [7:0] state = STATE_IDLE;
reg [7:0] count;

assign states = state;

reg [7:0] saved_dev_id;
reg [7:0] saved_reg_id;
reg [7:0] saved_data;

reg i2c_scl_enable = 0;
reg i2c_sda_val = 0;
reg ack_check = 0;

assign i2c_sda = i2c_sda_val; //PERFORM ACK HERE

// assign i2c_sda = ack_check ? 1'bz : i2c_sda_val; //PERFORM ACK HERE
assign i2c_scl = (i2c_scl_enable == 0) ? 1 : ~clk;
assign ready = ((reset == 0) && (state == STATE_IDLE)) ? 1 : 0;

// SCL Logic
always @(negedge(clk)) begin
	if (reset == 1'b1) begin
		i2c_scl_enable <= 0;
	end
	
	else begin
		if((state == STATE_IDLE) || (state == STATE_START) || (state == STATE_STOP) || (state == STATE_PRE_STOP)) begin
			i2c_scl_enable <= 0;
		end
		else begin
			i2c_scl_enable <= 1;
		end
	end
end

// SDA Logic
always @(posedge(clk)) begin
	
	if (reset == 1'b1) begin
		state <= STATE_IDLE;
		i2c_sda_val <= 1;
		ack_check <= 0;
//		i2c_scl <= 1;

		// dev_id <= 7'h50;
		count <= 8'd6;
		// data <= 8'haa; //test send aa?
	end

	else begin
		case (state)

			STATE_IDLE: begin
				i2c_sda_val <= 1;
				if ((start == 1'b1)) begin
					state <= STATE_START;
					saved_dev_id <= dev_id;
					saved_reg_id <= reg_id;
					saved_data <= data;
				end
				else state <= STATE_IDLE;
			end

			STATE_START: begin
				i2c_sda_val <= 0;
				state <= STATE_ADDR;
				count <= 8'd6;
			end

			STATE_ADDR: begin
				i2c_sda_val <= saved_dev_id[count];
				
				if (count == 0) begin
					// state <= STATE_RW;
					state <= STATE_WACK;
					ack_check <= 1;
				end
				else count <= count - 1;
			end

			STATE_RW: begin
				i2c_sda_val = 1;
				ack_check <= 1;				
				state <= STATE_WACK;
			end

			STATE_WACK: begin //needs fixing
				// if (i2c_sda == 1'b0) begin //slave has pulled SDA low
					i2c_sda_val <= 1'bz;
					state <= STATE_REG_ADDR;
					count <= 8'd7;
					ack_check <= 0;
				// end
				// else begin
				// 	state <= STATE_PRE_STOP;
				// end
				
			end

			STATE_REG_ADDR: begin
				i2c_sda_val <= saved_reg_id[count];
				if (count == 0) begin
					state <= STATE_WACK2;	
					ack_check <= 1;
				end 
				else count <= count - 1;
			end

			STATE_WACK2: begin
				// if (i2c_sda == 1'b0) begin //slave has pulled SDA low
					i2c_sda_val <= 1'bz;
					state <= STATE_DATA;
					count <= 8'd7;
					ack_check <= 0;
				// end
				// else begin
				// 	state <= STATE_PRE_STOP;
				// end
			end

			STATE_DATA: begin
				i2c_sda_val <= saved_data[count];
				if (count == 0) begin
					state <= STATE_WACK3;
					ack_check <= 1; //unnecessary
				end
				else count <= count - 1;
			end

			STATE_WACK3: begin
				state <= STATE_PRE_STOP;
//				state <= STATE_STOP;
				i2c_sda_val <= 1'bz;
				ack_check <= 0;
			end

			STATE_PRE_STOP: begin
				state <= STATE_STOP;
				i2c_sda_val <= 0;
			end

			STATE_STOP: begin
				i2c_sda_val <= 1;
				state <= STATE_IDLE;
			end

			default: begin
				i2c_sda_val <= 1;
//				i2c_scl <= 1;
				state <= STATE_START;
			end
		endcase
	end
	
end

endmodule