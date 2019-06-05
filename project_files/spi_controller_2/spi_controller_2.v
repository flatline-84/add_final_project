module spi_controller_2 (
	input  ref_clk,
	input  reset_n,
	input  start,
	input  spi_sdo, //MISO

	output  [11:0] data, //Data from SPI to TLE
	output  [11:0] data_1, //Data from SPI to TLE
	output  [11:0] data_2, //Data from SPI to TLE
	output  [11:0] data_3, //Data from SPI to TLE

	output spi_sdi, //MOSI
	output spi_scl, //SCLK
	output ready,  // no idea
	output CONVST,  //slave select

    output reg [7:0] LEDs

);

spi_state_machine state_machine (
    .clk(ref_clk),
    .reset_n(reset_n), 
    // .start(start),
    
    .spi_sdi(spi_sdi),
    .spi_scl(spi_scl),
    .spi_sdo(spi_sdo),
    .ready(ready),
    .CONVST(CONVST),
    
    // .addr(addr),
    .channel_1(data),
    .channel_2(data_1),
    .channel_3(data_2),
    .channel_4(data_3)
);

wire [11:0] copy_Data = data;  
reg [7:0] ScaleDown;

always @(copy_Data) begin

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
    else
        LEDs = 8'h00;
end



endmodule