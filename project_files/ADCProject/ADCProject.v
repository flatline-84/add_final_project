// ADC Project-- ADD - TLE
// Author: Craig Robinson - s3488614
// 			Peter Kydas - s34xxxxx
// Last Edit Date: 13/5/2019



module ADCProject
(

	input CLOCK_50, //Input Clocl
	output [7:0] LED,
	input [1:0] KEY,
	input [3:0] SW,
	
	//I2C Bus 
	output I2C_SCLK,
	inout I2C_SDAT
	
//	//Tests
//	output [5:0] SD_COUNTER,
//	output [9:0] COUNT
 	
);


wire reset_n; //Active low reset signal

reg GO; //Flag to start i2C wire
reg [6:0] SD_COUNTER; //Counter to track I2C
reg SDI; //reg value for SDATA - Slave data input

reg SCLK; //Register for SCLK
reg [9:0] COUNT; //Clock




//Structure 

assign reset_n = KEY[0];




always @(posedge(CLOCK_50)) 
  begin
    COUNT <= COUNT + 1; //On every clock cycle, increment the counter 
  end
	

	//Whenever the 9 bit reg overflows, run this block 
always @(posedge(COUNT[9]), negedge(reset_n))
begin
  if(!reset_n)
    GO <= 0;
  else
  if(!KEY[1])
    GO <= 1;
end


//I2C counter

always @(posedge(COUNT[9]), negedge(reset_n))
  begin 
    if(!reset_n)
      SD_COUNTER <= 6'b0;
     else
	  begin
	    if(!GO)
		   SD_COUNTER <= 0;
		 else
		   if(SD_COUNTER < 33)
			  SD_COUNTER <= SD_COUNTER+1;
	  end
end

//I2C lookup table, operations
always @(posedge(COUNT[9]), negedge(reset_n))
begin
  if(!reset_n)
    begin 
	   SCLK <=1;
		SDI <=1;
	 end
  else
    case (SD_COUNTER)
  
    //Initial Condition before start
    6'd0 : begin SDI<=1; SCLK<=1; end
	 
	 //Start
	 6'd1 : SDI<=0;
	 6'd2 : SCLK <=0;
	 
	 //Slave ADDR
	 
	 6'd3 : SDI <=1;
    6'd4 : SDI <=0;
    6'd5 : SDI <=0;
    6'd6 : SDI <=1;
    6'd7 : SDI <=0;
    6'd8 : SDI <=0;
    6'd9 : SDI <=1;
    6'd10 : SDI <=0;
    6'd11 : SDI <=1'bz; //Slave ACK
    	 
	 //	SUB ADDR
	
    6'd12 : SDI <=1;
    6'd13 : SDI <=0;	
	 6'd14 : SDI <=1;	
	 6'd15 : SDI <=0;	
	 6'd16 : SDI <=1;	
	 6'd17 : SDI <=0;	
	 6'd18 : SDI <=1;	
	 6'd19 : SDI <=0;	
	 6'd20 : SDI <=1'bz;	  //Slave ACK
 

   //	Data
	
    6'd21 : SDI <=1;
    6'd22 : SDI <=0;	
	 6'd23 : SDI <=1;	
	 6'd24 : SDI <=0;	
	 6'd25 : SDI <=1;	
	 6'd26 : SDI <=0;	
	 6'd27 : SDI <=1;	
	 6'd28 : SDI <=0;	
	 6'd29 : SDI <=1'b1;	 //Slave ACK

	 
	 // Stop
	 6'd30 : begin  SDI <= 1'b0; SCLK <= 1'b1; end
	 6'd31 : SDI <= 1'b1;
 
 endcase
end

assign I2C_SCLK = ((SD_COUNTER >= 4) & (SD_COUNTER <= 31)) ? ~COUNT[9] : SCLK;
assign I2C_SDAT = SDI;

	 
		 
endmodule