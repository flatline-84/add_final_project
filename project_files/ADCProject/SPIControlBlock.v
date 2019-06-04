module SPIControlBlock (

	input  ref_clk,
	input  reset_n,
	input  start,
	input  spi_sdo,

	output  [6:0] addr,
	output  [11:0] data, //Data from SPI to TLE
	output  [11:0] data_1, //Data from SPI to TLE
	output  [11:0] data_2, //Data from SPI to TLE
	output  [11:0] data_3, //Data from SPI to TLE

	output spi_sdi,
	output spi_scl,
	output ready,
	output CONVST,
	
	output spi_sdo_gpio,
	output spi_sdi_gpio,
	output spi_scl_gpio,
	output CONVST_gpio,
	
	output reg [7:0] LEDs,
	

	output [2:0] o_currentState,
	output [2:0] o_nextState

);


SPIStateMachine_2 SPI_State_Machine
(
  .clk(ref_clk),
  .reset_n(reset_n), 
  .start(start),
  
  .spi_sdi(spi_sdi),
  .spi_scl(spi_scl),
  .spi_sdo(spi_sdo),
  .ready(ready),
  .CONVST(CONVST),
  
  .addr(addr),
  .data(data)
//  .data_1(data_1),
//  .data_2(data_2),
//  .data_3(data_3)
  
);

 wire spi_sdi_gpio_w = spi_sdi;
 wire spi_scl_gpio_w = spi_scl;
 wire spi_sdo_gpio_w = spi_sdo;
 wire CONVST_gpio_w = CONVST;
 
 assign spi_sdi_gpio = spi_sdi_gpio_w; 
 assign spi_scl_gpio = spi_scl_gpio_w;
 assign spi_sdo_gpio = spi_sdo_gpio_w;
 assign CONVST_gpio  = CONVST_gpio_w;

 
 
 
 
 
 
 wire [11:0] copy_Data = data;  
 
 reg [7:0] ScaleDown;
 
 always @(copy_Data)
   begin
	
   ScaleDown = copy_Data / 512;
	
	if(ScaleDown == 1)
      LEDs = 8'b00000001;
	else if (ScaleDown == 2)
	  LEDs = 8'b00000010;
	else if (ScaleDown == 3)
	  LEDs = 8'b00000100;
	else if (ScaleDown == 4)
	  LEDs = 8'b00001000;
	else if (ScaleDown == 5)
	  LEDs = 8'b00010000;
	else if (ScaleDown == 6)
	  LEDs = 8'b00100000;
	else if (ScaleDown == 7)
	  LEDs = 8'b01000000;
	else if (ScaleDown == 8)
	  LEDs = 8'b10000000;
 end
	
  

endmodule
