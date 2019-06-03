// Peter
// https://warmcat.com/2015/10/21/hdmi-capture-and-analysis-fpga-project-2.html
// https://timetoexplore.net/blog/video-timings-vga-720p-1080p

/* 720p specs
Name         1280x720p60 
Standard       CTA-770.3
VIC                    4
Short Name          720p
Aspect Ratio        16:9

Pixel Clock       74.250 MHz
TMDS Clock       742.500 MHz
Pixel Time          13.5 ns ±0.5%
Horizontal Freq.  45.000 kHz
Line Time           22.2 μs
Vertical Freq.    60.000 Hz
Frame Time          16.7 ms

Horizontal Timings
Active Pixels       1280
Front Porch          110
Sync Width            40
Back Porch           220
Blanking Total       370
Total Pixels        1650
Sync Polarity        pos

Vertical Timings
Active Lines         720
Front Porch            5
Sync Width             5
Back Porch            20
Blanking Total        30
Total Lines          750
Sync Polarity        pos

Active Pixels    921,600
Data Rate           1.78 Gbps

Frame Memory (Kbits)
 8-bit Memory      7,200
12-bit Memory     10,800
24-bit Memory     21,600 
32-bit Memory     28,800

https://www.fpga4fun.com/HDMI.html
*/


module hdmi_controller (

    input clock50,
    input reset,

    // Output wires
    output wire hsync, //horizontal sync
    output wire vsync, //vertical sync
    output reg v_clk, //clock for video -> 148.5MHz for 1920x1080@60Hz
                                            // 25MHz -> 640x480@60P
    output wire data_enable, //activate HDMI controller
    output wire [23:0] rgb_data //Video data bus
);

wire locked;
wire clock74;

pll ( //74.25MHz for 720p
		.refclk(clock50),   //  refclk.clk
		.rst(reset),      //   reset.reset
		.outclk_0(clock74), // outclk0.clk
		.locked(locked)    //  locked.export
);

// Constants
reg [10:0] res_h_limit = 1649; //with porches: 1650 || 1280 without
reg [10:0] res_v_limit = 749;  //with porches: 750  ||  720 without
// reg [

// Variables
reg [10:0] res_h = 0;
reg [10:0] res_v = 0;

always @(posedge(clock74) or posedge(reset)) begin
    
	if (reset) begin
        res_h <= 0;
        res_v <= 0;
    end

    else begin
        res_h <= (res_h == res_h_limit) ? 0 : res_h + 1;

        if (res_h == res_h_limit) begin
            res_v <= (res_v==res_v_limit) ? 0 : res_v + 1;
        end
    end

end

//after front porch but before back porch
// so front porch + sync width
assign hsync = (res_h >= 1390) && (res_h < 1430);
assign vsync = (res_v >= 725) && (res_v < 730);
assign data_enable = (res_h < 1280) && (res_v < 720); //our valid data area

// always @(posedge(reset)) begin
//     // Handle reset

// end

assign rgb_data[23:16] = 8'd255; // RED channel
assign rgb_data[15:8] = 8'd100; // BLUE channel
assign rgb_data[7:0] = 8'd050; // RED channel



// Enabling Data for when we're actually transmitting stuff
// always @(posedge(clock50) or posedge(reset)) begin
//     if (reset) begin
//         data_enable <= 0;
//     end

//     else begin
//         //Means we're transmitting data to HDMI
//         if (res_v >= 0 && res_v < res_v_limit && res_h >= 0 && res_h < res_h_limit) begin
//             data_enable <= 1;
//         end

//         // No es bueno signal mama mia linguini per favore
//         else begin
//             data_enable <= 0;
//         end
//     end

// end 

// HSync and VSync scanning
//Should be slower clock -> 25MHz?




endmodule