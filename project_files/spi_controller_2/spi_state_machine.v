module spi_state_machine (
    input wire clk,
    input wire reset_n, 

    input wire spi_sdo, //MISO (read)

    output wire spi_sdi, //MOSI (write)
    output wire spi_scl, //SCLK
    output wire ready,
    output wire CONVST, //SS -> active low
    
    output wire[11:0] channel_1,
    output wire[11:0] channel_2,
    output wire[11:0] channel_3,
    output wire[11:0] channel_4
);

localparam STATE_INIT       = 0;
localparam STATE_IDLE       = 1;
localparam STATE_WRITE_0    = 2;
localparam STATE_WRITE_1    = 3;
localparam STATE_READ_0     = 4;
localparam STATE_READ_1     = 5;

reg [3:0] current_state = 0;

wire spi_clk = clk; //change to use a different clock eh

reg sclk;
reg ss_n;
reg mosi;
reg miso;

assign spi_sdo              = miso;
assign spi_sdi              = mosi;
assign CONST                = ss_n;
assign spi_scl              = sclk;

reg [3:0] count_limit       = 4'd7;
reg [7:0] count_limit       = 8'h00;

reg [7:0] current_addr      = 8'h00;
reg [2:0] current_channel   = 3'b000; // which channel to read from

// reg [11:0] channel_1_addr    = 8'h00;
// reg [11:0] channel_2_addr    = 8'h00;
// reg [11:0] channel_3_addr    = 8'h00;
// reg [11:0] channel_4_addr    = 8'h00;

reg [11:0] channel_1_addr   = 12'bzzzzz100010;  //bzzzzz100010  Make this 6 bits and read a 12 counter for SPI
reg [11:0] channel_2_addr   = 12'bzzzzz110010;  //bzzzzz110010  Make this 6 bits and read a 12 counter for SPI
reg [11:0] channel_3_addr   = 12'bzzzzz100110;  //bzzzzz100110  Make this 6 bits and read a 12 counter for SPI
reg [11:0] channel_4_addr   = 12'bzzzzz110110;  //bzzzzz110110  Make this 6 bits and read a 12 counter for SPI

reg [11:0] data_1           = 0;
reg [11:0] data_2           = 0;
reg [11:0] data_3           = 0;
reg [11:0] data_4           = 0;

always @(posedge(spi_clk) or negedge(spi_clk) or negedge(reset_n)) begin
    
    // Reset everything
    if (reset_n == 1'b0) begin
        count_limit       = 4'd7;
        count_limit       = 8'h00;
        current_addr      = 8'h00;
        current_channel   = 3'b000;

        data_1 = 0;
        data_2 = 0;
        data_3 = 0;
        data_4 = 0;
    end

    else if (spi_clk == 1'b1) begin //posedge of clock
        
    end


end