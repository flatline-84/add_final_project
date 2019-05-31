module i2c_master  (
    input  				reset ,
	input      		  	clk,
	input      		  	start,
	input      [15:0]   reg_data,
	input      [7:0] 	dev_address,	
	input            	sda_input,
	output reg       	i2c_sda,
	output reg       	i2c_scl,
	output reg       	finish,
	
	//--for test 
	output reg [7:0] 	state ,
	output reg [7:0] 	count,
	output reg [7:0] 	command_index,
	output reg       	ack
    // input      [7:0]    num_commands  // 4 : 4 byte 	
);

localparam STATE_INIT       = 0;
localparam STATE_START_1    = 1; //do start bit
localparam STATE_START_2    = 2; //start lull (i.e SDA low)
localparam STATE_DATA_1     = 3;
localparam STATE_DATA_2     = 4; //scl low
localparam STATE_WRITE_LOOP = 5;
localparam STATE_STOP_1     = 6;
localparam STATE_STOP_2     = 7;
localparam STATE_STOP_3     = 8;
localparam STATE_FIN        = 9;
localparam STATE_START_LATCH= 10;
localparam STATE_START_BOOT = 11;

reg   [8:0] current_data;
reg   [1:0] num_commands = 2; //maybe 3?

always @( posedge(reset) or posedge(clk) )begin
    if (reset) begin
        state <= STATE_INIT;
    end

    else begin
        case (state)
            STATE_INIT: begin  // INITIALIZE	      
                i2c_sda         <= 1; 
                i2c_scl         <= 1;
                ack             <= 0;
                count           <= 0;
                finish          <= 1;
                command_index   <= 0;

                if (start) begin
                    state  <= STATE_START_LATCH; // inital                
                end 
            end

            // START BIT
            STATE_START_1: begin  //start 
                state <= STATE_START_2; 
                { i2c_sda,  i2c_scl } <= 2'b01; 
                current_data <= {dev_address ,1'b1 }; //add write command to address
            end

            //START LULL
            STATE_START_2: begin  //start 
                state <= STATE_DATA_1; 
                { i2c_sda,  i2c_scl } <= 2'b00; 
            end
        
            //DATA?
            STATE_DATA_1: begin  
                state <= STATE_DATA_2; 
                { i2c_sda, current_data } <= { current_data, 1'b0 }; 
            end

            STATE_DATA_2: begin  
                state <= STATE_WRITE_LOOP; 
                i2c_scl <= 1'b1; 
                count <= count + 1'b1;
            end
        
            STATE_WRITE_LOOP: begin  
                i2c_scl <= 1'b0 ; 

                if (count==9) begin

                    if ( command_index == num_commands )  begin 
                        state <= STATE_STOP_1;
                    end
                    
                    else  begin 
                        count <= 0; 
                        state <= 2 ;
                        if (command_index == 0) begin 
                            command_index <= 1; 
                            current_data <= {reg_data[15:8] ,1'b1 }; 
                        end 
                        else if ( command_index ==1 ) begin 
                            command_index <= 2; 
                            current_data <= {reg_data[7:0] ,1'b1 }; 
                        end 
                    end

                    if (sda_input == 1'b0) begin
                        ack <= 1;
                    end 
                end

                else begin
                    state <= STATE_START_2;
                end
            end

            /* STOP BITS */
            STATE_STOP_1: begin          //stop
                state <= STATE_STOP_2; 
                { i2c_sda,  i2c_scl } <= 2'b00; 
            end

            STATE_STOP_2: begin          //stop
                state <= STATE_STOP_3; 
                { i2c_sda,  i2c_scl } <= 2'b01; 
            end

            STATE_STOP_3: begin          //stop
                state <= STATE_FIN; 
                { i2c_sda,  i2c_scl } <= 2'b11;     
            end 

            STATE_FIN:	begin
                state           <= STATE_INIT; 
                i2c_sda         <= 1; 
                i2c_scl         <= 1;
                count           <= 0;
                finish          <= 1;
                command_index   <= 0;
            end

            //--- END ---
            STATE_START_LATCH: begin
                if (!start) begin //START IS A TRIGGER
                    state  <= STATE_START_BOOT;
                end
            end		

            STATE_START_BOOT: begin  //
                finish <= 0;
                ack <= 0;
                state <= 1;	
            end	
        endcase 
    end
end

endmodule
