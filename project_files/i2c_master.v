/*************************\
 * Block: i2c Master Controller
 * Author: Peter Kydas
 * Date: 18/04/19
 * Last modified: 18/04/19
\*************************/

module i2c_master
(
	input clock_state, // internal clock used for changing states
	input clock_freq,  // not sure how I want to do this
    input [6:0] dev_id, // address of i2c device (7-bits)
    input [7:0] addr,   // address of register to r/w to
    input [7:0] input_data,
    input read_write,           // r/w bit
	output enable, 	 // just in case
	output [7:0] output_data,
	output sdl, scl    // SDL and SCL output lines
);


/*** State Machine States ***/
parameter begin_state	=	4'b0000;
parameter ready			=	4'b0001;
parameter start			=	4'b0010;
parameter command		=	4'b0011;
parameter slv_ack_1		=	4'b0100;
parameter read			= 	4'b0101;
parameter master_ack	=	4'b0110;
parameter write			=	4'b1000;
parameter slv_ack_2		=	4'b1001;
parameter stop			= 	4'b0111;
parameter error         =   4'b1111;
// Not used: 1010 -> 1110;
parameter unused_begin 	=	4'b1010;
parameter unused_end	= 	4'b1110;

// Registers for state transitions
reg [3:0] current_state	=	begin_state;
reg [3:0] next_state	=	begin_state;
reg en = 1'b0; // active high when needing to send / receive
// reg rw = read_write; // 0 for write, 1 for read
reg [3:0] default_count = 4'b0111;
reg [3:0] bit_count     = 4'b0111;//default_count; //count down from 7->0 (i.e 8)

//reg [6:0] temp_dev      = dev_id; //original device id
//reg dev_change          = 1'b0;   // used to signal if device address has changed

/** Check if device address has changed **/
// if (temp_dev != dev_id)
//     begin
//         dev_change = 1'b1;
//         temp_dev = dev_id;
//     end
// else
//     begin
//         dev_change = 1'b0;
//     end

/*** STATE MEMORY AND TRANSITION ***/
always @(posedge(clock_state))
	begin: state_memory
		current_state = next_state;
	end


/*** NEXT STATE LOGIC ***/
always @(current_state or en or bit_count or read_write) //or any other inputs?
	begin: next_state_logic
		

        
        
        case (current_state)
			begin_state:
				begin
					next_state = ready;
				end
			
			ready:
				begin
					if (en == 1'b1)
						begin
							next_state = start;
						end
					else
						begin
							next_state = ready; //latching?
						end
				end

            start:
                begin
                    next_state = command;
                end
            
            command:
                begin
                    if (bit_count == 1'b0)
                        begin
                            next_state = slv_ack_1;
                        end
                    else
                        begin
                            next_state = command;
                        end
                end

            slv_ack_1:
                begin
                    if (read_write == 1'b1)
                        begin
                            next_state = read;
                        end
                    else
                        begin
                            next_state = write;
                        end
                end

            read:
                begin
                    if (bit_count == 1'b0)
                        begin
                            next_state = master_ack;
                        end
                    else
                        begin
                            next_state = read;
                        end
                end

            master_ack:
                begin
                    // if (en == 1'b1 and read_write == 1'b1)
                    next_state = stop;
                end
            
            write:
                begin
                    if (bit_count == 1'b0)
                        begin
                            next_state = slv_ack_2;
                        end
                    else
                        begin
                            next_state = write;
                        end
                end

            slv_ack_2:
                begin
                    next_state = stop;
                end

            stop:
                begin
                    next_state = ready;
                end

            default:
                begin
                    next_state = stop;
                end
		endcase
	end


/*** OUTPUT LOGIC ***/
always @(current_state)
	begin: output_logic
		case (current_state)
            begin_state:
                begin
                    // Initialize everything?
                end
            
            ready:
                begin
                    // do nothing as well?
                end

            default:
                begin
                    //nothing
                end
		endcase
	end

endmodule