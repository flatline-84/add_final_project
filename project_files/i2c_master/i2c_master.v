module i2c_master(
	input wire clk,
	input wire reset,
	output reg i2c_sda,
	output wire i2c_scl
);

localparam STATE_IDLE = 0;
localparam STATE_START = 1;
localparam STATE_ADDR = 2;
localparam STATE_RW = 3;
localparam STATE_WACK = 4;
localparam STATE_DATA = 5;
localparam STATE_STOP = 6;
localparam STATE_WACK2 = 7;

reg [7:0] state;
reg [6:0] addr;
reg [7:0] count;
reg [7:0] data;

reg i2c_scl_enable = 0;

assign i2c_scl = (i2c_scl_enable == 0) ? 1 : ~clk;

// SCL Logic
always @(negedge(clk)) begin
	if (reset == 1) begin
		i2c_scl_enable <= 0;
	end
	
	else begin
		if((state == STATE_IDLE) || (state == STATE_START) || (state == STATE_STOP)) begin
			i2c_scl_enable <= 0;
		end
		else begin
			i2c_scl_enable <= 1;
		end
	end
end

// SDA Logic
always @(posedge(clk)) begin
	
	if (reset == 1) begin
		state <= 0;
		i2c_sda <= 1;
//		i2c_scl <= 1;

		addr <= 7'h50;
		count <= 8'd0;
		data <= 8'haa; //test send aa?
	end

	else begin
		case (state)

			STATE_IDLE: begin
				i2c_sda <= 1;
				state <= STATE_START;
			end

			STATE_START: begin
				i2c_sda <= 0;
				state <= STATE_ADDR;
				count <= 6;
			end

			STATE_ADDR: begin
				i2c_sda <= addr[count];
				
				if (count == 0) state <= STATE_RW;
				else count <= count - 1;
			end

			STATE_RW: begin
				i2c_sda <= 1;
				state <= STATE_WACK;
			end

			STATE_WACK: begin //needs fixing
				state <= STATE_DATA;
				count <= 7;
			end

			STATE_DATA: begin
				i2c_sda <= data[count];
				if (count == 0) state <= STATE_WACK2;
				else count <= count - 1;
			end

			STATE_WACK2: begin
				state <= STATE_STOP;
			end

			STATE_STOP: begin
				i2c_sda <= 1;
				state <= STATE_IDLE;
			end

			default: begin
				i2c_sda <= 1;
//				i2c_scl <= 1;
				state <= STATE_START;
			end
		endcase
	end
	
end

endmodule