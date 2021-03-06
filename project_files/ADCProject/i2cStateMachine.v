// ADC Project-- ADD - I2C Controller
// Author: Craig Robinson - s3488614
// 		  Peter Kydas - s34xxxxx
// Last Edit Date: 16/5/2019


`default_nettype none
module i2cStateMachine
(
	 input  wire  clk,
    input  wire  reset_n,
    input  wire  start,

    // system outputs
    output reg   i2c_sda,
    output wire  i2c_scl,
    output wire  ready,
    
    // Frame data
    input  wire [6:0] addr,
    input  wire [7:0] data,

    // counter control
    input  wire [2:0] count_val,
    output reg  [2:0] count_from,
    output wire       count_reset,

    // Debug below
    output wire [2:0] o_currentState,
    output wire [2:0] o_nextState
 	
);


localparam STATE_IDLE  = 8'd0;
localparam STATE_START = 8'd1;
localparam STATE_ADDR  = 8'd2;
localparam STATE_RW    = 8'd3;
localparam STATE_WACK  = 8'd4;
localparam STATE_DATA  = 8'd5;
localparam STATE_WACK2 = 8'd6;
localparam STATE_STOP  = 8'd7;

reg [2:0] currentState;
reg [2:0] nextState;

reg i2c_scl_enable = 1'b0;

reg [6:0] saved_addr;
reg [7:0] saved_data;

// Pulse the clock only when enabled
assign i2c_scl = (i2c_scl_enable == 1'b0) ? 1'b1 : ~clk;
// Reset the coutners when not in transmission states
assign count_reset = ( (currentState == STATE_ADDR) || (currentState == STATE_DATA) ) ? 1'b1 : 1'b0;

assign ready = ( (currentState == STATE_IDLE) && (reset_n) )? 1'b1 : 1'b0;

assign o_currentState = currentState;
assign o_nextState = nextState;



always @(negedge(clk), negedge(reset_n)) begin: i2c_clock_logic
	if (!reset_n) begin
		i2c_scl_enable <= 1'b0;
	end	else begin
		if ( (nextState == STATE_IDLE) || (nextState == STATE_START) || (nextState == STATE_STOP)) begin
			i2c_scl_enable <= 1'b0;
		end	else begin
			i2c_scl_enable <= 1'b1;
		end
	end
end

always @(posedge(clk), negedge(reset_n)) begin: stateMemory
    if (!reset_n)
        currentState <= STATE_IDLE;
    else
        currentState <= nextState;
end

always @(currentState, count_val, start) begin: nextStateLogic

    case(currentState)
        STATE_IDLE: begin
            count_from <= 3'b0;
            if (start) begin
                saved_addr <= addr;
                saved_data <= data;
                nextState  <= STATE_START;
            end else begin
                nextState <= STATE_IDLE;
            end
        end
        STATE_START: begin
            count_from <= 3'd6;
            nextState   <= STATE_ADDR;
        end
        STATE_ADDR: begin
            count_from <= 3'd6;
            if (count_val == 0)
                nextState <= STATE_RW;
            else
                nextState <= STATE_ADDR;
        end
        STATE_RW: begin
            count_from <= 3'b0;
            nextState <= STATE_WACK;
        end
        STATE_WACK: begin
            count_from <= 3'd7;
            nextState <= STATE_DATA;
        end
        STATE_DATA: begin
            count_from <= 3'd7;
            if (count_val == 0)
                nextState <= STATE_WACK2;
            else
                nextState <= STATE_DATA;
        end
        STATE_WACK2: begin
            count_from <= 3'b0;
            nextState <= STATE_STOP;
        end
        STATE_STOP: begin
            count_from <= 3'b0;
            nextState <= STATE_IDLE;
        end
        default: begin
            count_from <= 3'b0;
            nextState <= STATE_IDLE;
        end
    endcase
end

always @(currentState, count_val) begin: outputLogic
    case(currentState)
        STATE_IDLE: begin
            i2c_sda <= 1'b1;
        end
        STATE_START: begin
            i2c_sda <= 1'b0;
        end
        STATE_ADDR: begin
            i2c_sda <= saved_addr[count_val];
        end
        STATE_RW: begin
            i2c_sda <= 1'b0;
        end
        STATE_WACK: begin
            i2c_sda <= 1'b0;
        end
        STATE_DATA: begin
            i2c_sda <= saved_data[count_val];
        end
        STATE_WACK2: begin
            i2c_sda <= 1'b0;
        end
        STATE_STOP: begin
            i2c_sda <= 1'b1;
        end
        default: begin
            i2c_sda <= 1'b1;
        end
    endcase
end

endmodule
 