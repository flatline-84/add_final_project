// Lab 04 -- ADD - State Machine
// Author: Craig Robinson - s3488614
// Last Edit Date: 1/5/2019


module SPIStateMachine_2
(
	
	 input  wire  clk,     // 50 Meg clock
    input  wire  reset_n,
    input  wire  start,   // Start master signal from control block

    // system outputs
    output reg   spi_sdi, //Data to the ADC chip
    output wire  spi_scl, // SPI Clock
	 input  wire  spi_sdo,  //Data read from ADC chip (The converted signal)
    output wire  ready,    // ready pin for the control block 
	 output reg   CONVST,
    
    // Frame data
    input  wire [6:0] addr, //Data for the ADC 
    output reg [11:0] data, // Data read from ADC to TLE
	 output reg [11:0] data_1,
	 output reg [11:0] data_2,
	 output reg [11:0] data_3,
	 
	 
    // counter control
    output wire       count_reset,

    // Debug below
    output wire [4:0] o_currentState,
    output wire [4:0] o_nextState
		
);
	
	parameter STATE_IDLE  		 = 8'd0; // Before ADC Startup
	parameter STATE_START       = 8'd1; // Send data
	parameter STATE_START_Reset = 8'd2; // Send dataca
	
	parameter STATE_WRITE       = 8'd3; // wait for first conversion
	parameter STATE_WRITE_Reset = 8'd4; // wait for first conversion
	
	parameter STATE_CONV        = 8'd5; // Wait for secondary conversions 
	parameter STATE_CONV_Reset  = 8'd6; 
	parameter STATE_RW          = 8'd7; // Send data and read ADC 
	parameter STATE_RW_Reset    = 8'd8; 
	
	
	parameter STATE_CONV_1        = 8'd9; // Wait for secondary conversions 
	parameter STATE_CONV_Reset_1  = 8'd10; 
	parameter STATE_RW_1          = 8'd11; // Send data and read ADC 
	parameter STATE_RW_Reset_1    = 8'd12; 
	
	parameter STATE_CONV_2        = 8'd13; // Wait for secondary conversions 
	parameter STATE_CONV_Reset_2  = 8'd14; 
	parameter STATE_RW_2          = 8'd15; // Send data and read ADC 
	parameter STATE_RW_Reset_2    = 8'd16; 
	
	parameter STATE_CONV_3        = 8'd17; // Wait for secondary conversions 
	parameter STATE_CONV_Reset_3  = 8'd18; 
	parameter STATE_RW_3          = 8'd19; // Send data and read ADC 
	parameter STATE_RW_Reset_3    = 8'd20; 
	
	
	
	   
	parameter STATE_STOP        = 8'd21; // Stop condition

	
	reg [4:0] currentState = STATE_IDLE;
	reg [4:0] nextState = STATE_IDLE;
//b100010zzzzzz zzzzzz010001    100010
	reg [11:0] saved_addr   = 12'bzzzzz100010;  //bzzzzz100010  Make this 6 bits and read a 12 counter for SPI
	reg [11:0] saved_addr_1 = 12'bzzzzz110010;  //bzzzzz110010  Make this 6 bits and read a 12 counter for SPI
	reg [11:0] saved_addr_2 = 12'bzzzzz100110;  //bzzzzz100110  Make this 6 bits and read a 12 counter for SPI
	reg [11:0] saved_addr_3 = 12'bzzzzz110110;  //bzzzzz110110  Make this 6 bits and read a 12 counter for SPI
   reg [11:0] saved_data;
	reg [11:0] saved_data_1;
	reg [11:0] saved_data_2;
	reg [11:0] saved_data_3;
	
	wire [3:0] count_val;  //Current value of counter
  	reg  [3:0] count_from; //Number to be passed to counter
	
	wire [3:0] count_val_SPI;  //Current value of SPI counter
  	reg  [3:0] count_from_SPI; //Number to be passed to SPI counter
	
	wire SPI_CLK;
	assign spi_scl = SPI_CLK;
	
	wire reset_spi_counter; 
	
	assign reset_spi_counter = ( (currentState == STATE_START) || 
	                             (currentState == STATE_WRITE) || 
										  (currentState == STATE_CONV ) || 
										  (currentState == STATE_RW   ) ||
										  (currentState == STATE_CONV_1 ) || 
										  (currentState == STATE_RW_1   ) ||
										  (currentState == STATE_CONV_2 ) || 
										  (currentState == STATE_RW_2   ) ||
										  (currentState == STATE_CONV_3 ) || 
										  (currentState == STATE_RW_3   )) ? 1'b1 : 1'b0;
	
	count_down #(4) counter (
		.clk(SPI_CLK),
		.reset_n(reset_spi_counter),
		.count_from(count_from),
		.count_val(count_val)
	);
	
	count_down #(4) counter_SPI (
		.clk(SPI_CLK),
		.reset_n(reset_spi_counter),
		.count_from(count_from_SPI),
		.count_val(count_val_SPI)
	);
	
	//Divide the 50MHz clock by factor of 2. 
	// On 500 = 100kHz 500
	clockDivider #(8, 500) SPI_clock (
	  .ref_clk(clk),
	  .reset_n(reset_n),
	  .output_clk(SPI_CLK)
	 );  
	  
	  
/*      StateMemory Block            */		

	always @(posedge(SPI_CLK))
	
		begin: stateMemory
			currentState <= nextState;
		end
		
/*      Next Stage Logic Block            */		
	always @(currentState, spi_sdo, count_val, start )
		begin: nextStateLogic
			
		case(currentState)
        STATE_IDLE: 
		    begin
            count_from <= 4'd12;
				count_from_SPI <= 4'd5;
            if (start) 
				  begin
//                saved_addr <= addr;
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
			  count_from <= 4'd12; //Count length for state
			  count_from_SPI <= 4'd5; //Count length for data output on line 
			  if (count_val == 0)
				 begin
					nextState   <= STATE_START_Reset; //Count the 6 clocks of the SPI
				 end
			  else
				 nextState <= STATE_START;
        end
		  
		  
		  
		  STATE_START_Reset: 
		  begin   
 			nextState   <= STATE_WRITE; //Resets all the counters 
        end
		  
		  
		  
        STATE_WRITE: 
		  begin
            count_from <= 4'd12;  //Write command to ADC 
				count_from_SPI <= 4'd5;
            if (count_val == 0)
				  begin
				    nextState <= STATE_WRITE_Reset; 
					 count_from <= 4'd12;
					
				  end
                
				else
				    nextState   <= STATE_WRITE;	 
        end
		  
		  STATE_WRITE_Reset: 
		  begin
		    nextState <= STATE_CONV; 	//Reset all the counters 
        end
		  

        STATE_CONV: 
		  begin
            count_from <= 4'd12;
				count_from_SPI <= 4'd5;
				  if (count_val == 0)
				    begin
					   nextState <= STATE_CONV_Reset;  //Wait for the conversion of the ADC
					   count_from <= 4'd12;
					 end
				  else	
				    nextState <= STATE_CONV;  
					 
        end
		  
		  STATE_CONV_Reset:
		  begin
			 nextState <= STATE_RW;  //Wait for the conversion of the ADC
		  end
		  
		  STATE_RW: 
		  begin
            count_from <= 4'd12;
				count_from_SPI <= 4'd5;
				if (count_val == 0)
				  begin
				    nextState <= STATE_RW_Reset; // Read and write to the ADC
				    count_from <= 4'd12;
				  end
              
				else
				   nextState <= STATE_RW;
					saved_data[count_val] <= spi_sdo; //Write data from the line into the reg
					data[count_val] <= spi_sdo; 
        end
		  
		  STATE_RW_Reset: 
		  begin
		    nextState <= STATE_CONV; // Read and write to the ADC		
        end
		  
		  
		  
		  STATE_CONV_1: 
		  begin
            count_from <= 4'd12;
				count_from_SPI <= 4'd5;
				  if (count_val == 0)
				    begin
					   nextState <= STATE_CONV_Reset_1;  //Wait for the conversion of the ADC
					   count_from <= 4'd12;
					 end
				  else	
				    nextState <= STATE_CONV_1;  
					 
        end
		  
		  STATE_CONV_Reset_1:
		  begin
			 nextState <= STATE_RW_1;  //Wait for the conversion of the ADC
		  end
		  
		  STATE_RW_1: 
		  begin
            count_from <= 4'd12;
				count_from_SPI <= 4'd5;
				if (count_val == 0)
				  begin
				    nextState <= STATE_RW_Reset_1; // Read and write to the ADC
				    count_from <= 4'd12;
				  end
              
				else
				   nextState <= STATE_RW_1;
					saved_data_1[count_val] <= spi_sdo; //Write data from the line into the reg
					data_1[count_val] <= spi_sdo; 
        end
		  
		  STATE_RW_Reset_1: 
		  begin
		    nextState <= STATE_CONV_2; // Read and write to the ADC		
        end
		  
		  
		  STATE_CONV_2: 
		  begin
            count_from <= 4'd12;
				count_from_SPI <= 4'd5;
				  if (count_val == 0)
				    begin
					   nextState <= STATE_CONV_Reset_2;  //Wait for the conversion of the ADC
					   count_from <= 4'd12;
					 end
				  else	
				    nextState <= STATE_CONV_2;  
					 
        end
		  
		  STATE_CONV_Reset_2:
		  begin
			 nextState <= STATE_RW_2;  //Wait for the conversion of the ADC
		  end
		  
		  STATE_RW_2: 
		  begin
            count_from <= 4'd12;
				count_from_SPI <= 4'd5;
				if (count_val == 0)
				  begin
				    nextState <= STATE_RW_Reset_2; // Read and write to the ADC
				    count_from <= 4'd12;
				  end
              
				else
				   nextState <= STATE_RW_2;
					saved_data_2[count_val] <= spi_sdo; //Write data from the line into the reg
					data_2[count_val] <= spi_sdo; 
        end
		  
		  STATE_RW_Reset_2: 
		  begin
		    nextState <= STATE_CONV_3; // Read and write to the ADC		
        end
		  
		  
		  
		  
		  STATE_CONV_3: 
		  begin
            count_from <= 4'd12;
				count_from_SPI <= 4'd5;
				  if (count_val == 0)
				    begin
					   nextState <= STATE_CONV_Reset_3;  //Wait for the conversion of the ADC
					   count_from <= 4'd12;
					 end
				  else	
				    nextState <= STATE_CONV_3;  
					 
        end
		  
		  STATE_CONV_Reset_3:
		  begin
			 nextState <= STATE_RW_3;  //Wait for the conversion of the ADC
		  end
		  
		  STATE_RW_3: 
		  begin
            count_from <= 4'd12;
				count_from_SPI <= 4'd5;
				if (count_val == 0)
				  begin
				    nextState <= STATE_RW_Reset_3; // Read and write to the ADC
				    count_from <= 4'd12;
				  end
              
				else
				   nextState <= STATE_RW_3;
					saved_data_3[count_val] <= spi_sdo; //Write data from the line into the reg
					data_3[count_val] <= spi_sdo; 
        end
		  
		  STATE_RW_Reset_3: 
		  begin
		    nextState <= STATE_CONV; // Read and write to the ADC		
        end
		  
		  
		  
		  
		  
		  
        STATE_STOP: 
		  begin
            nextState <= STATE_IDLE;
        end
		  
        default: 
		    begin
            nextState <= STATE_IDLE;
          end
		  
		endcase
	 end
		
		
		
/*      Output Logic Block            */		
	always @(currentState, spi_sdo, count_val, start )
		
	
		
		begin: outputLogic
			
			case(currentState)
        
		  STATE_IDLE: 
		  begin
            CONVST  <= 1'b0;
				spi_sdi <= 1'b1;
				
        end
		  
        STATE_START: 
		  begin
            
				CONVST  <= 1'b1;
				spi_sdi <= 1'b0;
        end
		  
        STATE_WRITE: 
		  begin
		      CONVST  <= 1'b0;
				spi_sdi <= saved_addr[count_val_SPI];
        end
		  
        
		  STATE_CONV: 
		  begin
		      CONVST  <= 1'b1;
            spi_sdi <= 1'b0;
				saved_data <= 12'b000000000000;
        end
		  
		  STATE_RW: 
		  begin
            CONVST  <= 1'b0;
				spi_sdi <= saved_addr[count_val_SPI];
        end
		  

		  
        
		  STATE_CONV_1: 
		  begin
		      CONVST  <= 1'b1;
            spi_sdi <= 1'b0;
				saved_data_1 <= 12'b000000000000;
        end
		  
		  STATE_RW_1: 
		  begin
            CONVST  <= 1'b0;
				spi_sdi <= saved_addr_1[count_val_SPI];
        end
		  
		
		  
        
		  STATE_CONV_2: 
		  begin
		      CONVST  <= 1'b1;
            spi_sdi <= 1'b0;
				saved_data_2 <= 12'b000000000000;
        end
		  
		  STATE_RW_2: 
		  begin
            CONVST  <= 1'b0;
				spi_sdi <= saved_addr_2[count_val_SPI];
        end
		
		  
        
		  STATE_CONV_3: 
		  begin
		      CONVST  <= 1'b1;
            spi_sdi <= 1'b0;
				saved_data_3 <= 12'b000000000000;
        end
		  
		  STATE_RW_3: 
		  begin
            CONVST  <= 1'b0;
				spi_sdi <= saved_addr_3[count_val_SPI];
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
				
	 // data = saved_data;	 
  end		
  
		
endmodule