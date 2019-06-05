module top_sync_vg_pattern
(
    input wire clk_in, //74.25MHz
    // input wire clock60, //60Hz
    input wire reset,
    input wire[11:0] channel_1,
    input wire[11:0] channel_2,
    input wire[11:0] channel_3,
    input wire[11:0] channel_4,

    output reg hsync,          // HS output to ADV7511
    output reg vsync,          // VS output to ADV7511
    output wire v_clk,        // ADV7511: CLK
    output reg [23:0] rgb_data,    // data
    output reg data_enable          // ADV7511: DE
);

/* ************************************* */
/* SELECT ONE OF MODES: */
//`define MODE_1080p
//`define MODE_1080i
`define MODE_720p

`ifdef MODE_1080p /* FORMAT 16 */
parameter INTERLACED    = 1'b0;
parameter V_TOTAL_0     = 12'd1125;
parameter V_FP_0        = 12'd4;
parameter V_BP_0        = 12'd36;
parameter V_SYNC_0      = 12'd5;
parameter V_TOTAL_1     = 12'd0;
parameter V_FP_1        = 12'd0;
parameter V_BP_1        = 12'd0;
parameter V_SYNC_1      = 12'd0;
parameter H_TOTAL       = 12'd2200;
parameter H_FP          = 12'd88;
parameter H_BP          = 12'd148;
parameter H_SYNC        = 12'd44;
parameter HV_OFFSET_0   = 12'd0;
parameter HV_OFFSET_1   = 12'd0;
parameter PATTERN_RAMP_STEP = 20'h0222;
parameter PATTERN_TYPE  = 8'd4; // RAMP
//parameter PATTERN_TYPE = 8'd1; // OUTLINE
`endif

`ifdef MODE_1080i /* FORMAT 5 */
parameter INTERLACED    = 1'b1;
parameter V_TOTAL_0     = 12'd562;
parameter V_FP_0        = 12'd2;
parameter V_BP_0        = 12'd15;
parameter V_SYNC_0      = 12'd5;
parameter V_TOTAL_1     = 12'd563;
parameter V_FP_1        = 12'd2;
parameter V_BP_1        = 12'd16;
parameter V_SYNC_1      = 12'd5;
parameter H_TOTAL       = 12'd2200;
parameter H_FP          = 12'd88;
parameter H_BP          = 12'd148;
parameter H_SYNC        = 12'd44;
parameter HV_OFFSET_0   = 12'd0;
parameter HV_OFFSET_1   = 12'd1100;
parameter PATTERN_RAMP_STEP = 20'h0222; // 20'hFFFFF
parameter PATTERN_TYPE  = 8'd4; // RAMP
//parameter PATTERN_TYPE = 8'd1; // OUTLINE
`endif

`ifdef MODE_720p /* FORMAT 4 */
parameter INTERLACED    = 1'b0;
parameter V_TOTAL_0     = 12'd750;
parameter V_FP_0        = 12'd5;
parameter V_BP_0        = 12'd20;
parameter V_SYNC_0      = 12'd5;
parameter V_TOTAL_1     = 12'd0;
parameter V_FP_1        = 12'd0;
parameter V_BP_1        = 12'd0;
parameter V_SYNC_1      = 12'd0;
parameter H_TOTAL       = 12'd1650;
parameter H_FP          = 12'd110;
parameter H_BP          = 12'd220;
parameter H_SYNC        = 12'd40;
parameter HV_OFFSET_0   = 12'd0;
parameter HV_OFFSET_1   = 12'd0;
parameter PATTERN_RAMP_STEP = 20'h0333; // 20'hFFFFF//
// parameter PATTERN_TYPE  = 8'd1; // BORDER.
parameter PATTERN_TYPE  = 8'd0; // custom squares
`endif

// wire reset;
// assign reset = !reset_n;

wire [11:0] x_out;
wire [12:0] y_out;
wire [7:0] r_out;
wire [7:0] g_out;
wire [7:0] b_out;

//parameter PATTERN_TYPE  = 8'd2;

/* ********************* */
sync_vg #(.X_BITS(12), .Y_BITS(12)) sync_vg
(
    .clk(clk_in),
    .reset(reset),
    .interlaced(INTERLACED),
    .clk_out(), // inverted output clock - unconnected
    .v_total_0(V_TOTAL_0),
    .v_fp_0(V_FP_0),
    .v_bp_0(V_BP_0),
    .v_sync_0(V_SYNC_0),
    .v_total_1(V_TOTAL_1),
    .v_fp_1(V_FP_1),
    .v_bp_1(V_BP_1),
    .v_sync_1(V_SYNC_1),
    .h_total(H_TOTAL),
    .h_fp(H_FP),
    .h_bp(H_BP),
    .h_sync(H_SYNC),
    .hv_offset_0(HV_OFFSET_0),
    .hv_offset_1(HV_OFFSET_1),
    .de_out(de),
    .vs_out(vs),
    .v_count_out(),
    .h_count_out(),
    .x_out(x_out),
    .y_out(y_out),
    .hs_out(hs),
    .field_out(field)
);

pattern_vg #(
    .B(8), // Bits per channel
    .X_BITS(12),
    .Y_BITS(12),
    .FRACTIONAL_BITS(12)) 

pattern_vg (
    .reset(reset),
    .clk_in(clk_in),
    // .clock60(clock60),
    .x(x_out),
    .y(y_out[11:0]),
    .vn_in(vs),
    .hn_in(hs),
    .dn_in(de),
    .channel_1(channel_1),
    .channel_2(channel_2),
    .channel_3(channel_3),
    .channel_4(channel_4),
    .r_in(8'd134), // default red channel value
    .g_in(8'd137), // default green channel value
    .b_in(8'd144), // default blue channel value
    .vn_out(vs_out),
    .hn_out(hs_out),
    .den_out(de_out),
    .r_out(r_out),
    .g_out(g_out),
    .b_out(b_out),
    .total_active_pix(H_TOTAL - (H_FP + H_BP + H_SYNC)), // (1920) // h_total - (h_fp+h_bp+h_sync)
    .total_active_lines(INTERLACED ? (V_TOTAL_0 - (V_FP_0 + V_BP_0 + V_SYNC_0)) + (V_TOTAL_1 - (V_FP_1 +V_SYNC_1)) : (V_TOTAL_0 - (V_FP_0 + V_BP_0 + V_SYNC_0))),
    // originally: 13'd480
    .pattern(PATTERN_TYPE),
    .ramp_step(PATTERN_RAMP_STEP)
);

assign v_clk = ~clk_in;

always @(posedge clk_in) begin
    rgb_data[23:16] <= r_out;
    rgb_data[15:8] <= g_out;
    rgb_data[7:0] <= b_out;
    hsync <= hs_out;
    vsync <= vs_out;
    data_enable <= de_out;
end

endmodule