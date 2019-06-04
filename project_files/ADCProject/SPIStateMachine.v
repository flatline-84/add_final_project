// ADC Project-- ADD - SPI Controller
// Author: Craig Robinson - s3488614
// 		  Peter Kydas - s34xxxxx
// Last Edit Date: 16/5/2019


//`default_nettype none
module SPIStateMachine
(
	 input  wire  clk,     // 50 Meg clock
    input  wire  reset_n,
    input  wire  start,   // Start master signal from control block

    // system outputs
    output reg   spi_sdi, //Data to the ADC chip
    output wire  spi_scl, // SPI Clock
	 output reg   spi_sdo,  //Data read from ADC chip (The converted signal)
    output wire  ready,    // ready pin for the control block 
	 output reg   CONVST,
    
    // Frame data
    input  wire [6:0] addr, //Data for the ADC 
    input  wire [11:0] data, // Data read from ADC

    // counter control
    input  wire [2:0] count_val, 
    output reg  [3:0] count_from,
    output wire       count_reset,

    // Debug below
    output wire [2:0] o_currentState,
    output wire [2:0] o_nextState
 	
);


localparam STATE_IDLE  = 8'd0; // Before ADC Startup
localparam STATE_START = 8'd1; // Send data
localparam STATE_WRITE = 8'd2; // wait for first conversion
localparam STATE_RW    = 8'd3; // Send data and read ADC 
localparam STATE_CONV  = 8'd4; // Wait for secondary conversions 
localparam STATE_STOP  = 8'd5; // Stop condition


reg [2:0] currentState = STATE_IDLE;
reg [2:0] nextState = STATE_IDLE;

reg spi_scl_enable = 1'b0;

reg [6:0] saved_addr;
reg [7:0] saved_data;

// Pulse the clock only when enabled
assign spi_scl = (spi_scl_enable == 1'b0) ? 1'b1 : ~clk;

//// Reset the coutners when not in transmission states
//assign count_reset = ( (currentState == STATE_WRITE) || (currentState == STATE_CONV) ) ? 1'b1 : 1'b0;
//
//assign ready = ( (currentState == STATE_IDLE) && (reset_n) )? 1'b1 : 1'b0;

assign o_currentState = currentState;
assign o_nextState = nextState;



//always @(negedge(clk), negedge(reset_n)) 
//  begin: spi_clock_logic
//	if (!reset_n) 
//	  begin
//		spi_scl_enable <= 1'b0;
//	  end	
//	
////	else 
////	 begin
////		if ( (nextState == STATE_IDLE) || (nextState == STATE_START) || (nextState == STATE_STOP)) begin
////			spi_scl_enable <= 1'b0;
////		end	
////		
////		else 
////		  begin
////			spi_scl_enable <= 1'b1;
////		  end
////	end
//end



always @(posedge(clk), negedge(reset_n)) 
  begin: stateMemory
    if (!reset_n)
	   begin
		  currentState <= STATE_IDLE;
		end
        
    else
	   begin
		  currentState <= nextState;
		end
        
end

always @(currentState, count_val, start) 
  begin: nextStateLogic
    case(currentState)
        STATE_IDLE: 
		  begin
            count_from <= 3'b0;
            if (start) 
				  begin
                saved_addr <= addr;
                saved_data <= data;
                nextState  <= STATE_START;
              end 
				else 
				  begin
                nextState <= STATE_IDLE;  //Wait in this state until start is triggered
              end
        end
        
		  STATE_START: 
		  begin
            count_from <= 3'd12; 
				  if (count_val == 0)
				    nextState   <= STATE_WRITE; //Count the 12 clocks of the SPI
				  
        end
		  
        STATE_WRITE: 
		  begin
            count_from <= 3'd6;  //Write command to ADC 
            if (count_val == 0)
                nextState <= STATE_CONV; 
        end
		  
		  
        STATE_CONV: 
		  begin
            count_from <= 3'd6;
				  if (count_val == 0)
                nextState <= STATE_RW;  //Wait for the conversion of the ADC
				 // else if(reset_n == 0)
				   // nextState <= STATE_STOP; 
        end
		  
		  STATE_RW: 
		  begin
            count_from <= 3'd12;
				if (count_val == 0)
              nextState <= STATE_CONV; // Read and write to the ADC
        end
		  
        STATE_STOP: 
		  begin
            count_from <= 3'b0;
            nextState <= STATE_IDLE;
        end
		  
        default: 
		  begin
            count_from <= 3'b0;
            nextState <= STATE_IDLE;
        end
    endcase
end

always @(currentState, count_val) 
  begin: outputLogic
    case(currentState)
        
		  STATE_IDLE: 
		  begin
            CONVST  <= 1'b0;
				spi_sdi <= 1'b1;
				spi_sdo <= 1'bz;
        end
		  
        STATE_START: 
		  begin
            
				CONVST  <= 1'b1;
				spi_sdi <= 1'b0;
        end
		  
        STATE_WRITE: 
		  begin
		      CONVST  <= 1'b0;
				spi_sdi <= saved_addr[count_val];
        end
		  
        
		  STATE_CONV: 
		  begin
		      CONVST  <= 1'b1;
            spi_sdi <= 1'b0;

        end
		  
		  STATE_RW: 
		  begin
            CONVST  <= 1'b0;
				spi_sdi <= saved_addr[count_val];
        end
		  
        STATE_STOP: 
		  begin
            CONVST  <= 1'b0;
				spi_sdi <= 1'b0;
        end
		  
        default: 
		  begin
            CONVST  <= 1'b0;
				spi_sdi <= 1'b0;
        end
    endcase
end

endmodule
 