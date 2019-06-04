module square 
#(
    parameter B=8, // number of bits per channel
    X_BITS=13,
    Y_BITS=13,
    FRACTIONAL_BITS = 12
)

(

    input wire [X_BITS-1:0] value,
    input wire [Y_BITS-1:0] y1,
    input wire vsync, //will be 60Hz

    input wire [X_BITS-1:0] total_active_pix,
    input wire [X_BITS-1:0] x,
    input wire [Y_BITS-1:0] y,

    output wire draw // tells the pattern_vg to draw some shit. Might need colours coming in too
);

reg [4:0] size = 20; //size of rect
reg draw_wire;
reg which_way = 0; //spooky
// reg [X_BITS-1:0] value_reg = 0;
// wire [X_BITS-1:0] value_wire;
// assign value_wire = value_reg;



reg [Y_BITS-1:0] y2;

// always @(posedge(vsync)) begin
// //always @(*) begin

//     y2 = (y1 + size);

// 	if (value_reg == 0) begin
//         which_way = 1;
//     end
//     else if (value_reg == total_active_pix) begin
//         which_way = 0;
//     end
    
//     if (which_way) begin
//         value_reg = value_reg + 1;
// 	end

//     else begin
//         value_reg = value_reg - 1;
//     end

//     // draw_wire = ( (x >= 0) && (x <= value) && (y >= y1) && (y <= y2) ); //for actual value shit
//     // draw_wire = ( (x >= 0) && (x <= value_reg) && (y >= y1) && (y <= (y1+size)) );
// end

always @(*) begin
    draw_wire = ( (x >= 0) && (x <= value) && (y >= y1) && (y <= (y1 + size)) ); //for actual value shit
end

assign draw = draw_wire;

endmodule

//https://timetoexplore.net/blog/arty-fpga-vga-verilog-01