
module pattern_vg
#(
    parameter B=8, // number of bits per channel
    X_BITS=13,
    Y_BITS=13,
    FRACTIONAL_BITS = 12
)

(
    input reset, clk_in, clock60,
    input wire [X_BITS-1:0] x,
    input wire [Y_BITS-1:0] y,
    input wire vn_in, hn_in, dn_in,
    input wire [B-1:0] r_in, g_in, b_in,
    
    input wire[11:0] channel_1,
    input wire[11:0] channel_2,
    input wire[11:0] channel_3,
    input wire[11:0] channel_4,
    
    output reg vn_out, hn_out, den_out,
    output reg [B-1:0] r_out, g_out, b_out,
    input wire [X_BITS-1:0] total_active_pix,
    input wire [Y_BITS-1:0] total_active_lines,
    input wire [7:0] pattern,
    input wire [B+FRACTIONAL_BITS-1:0] ramp_step
);

reg [B+FRACTIONAL_BITS-1:0] ramp_values; // 12-bit fractional end for ramp values

reg [X_BITS-1:0] x1 = 0;
reg [X_BITS-1:0] x2 = 1000;
reg [Y_BITS-1:0] y1 = 144;
reg [Y_BITS-1:0] y2 = 288;
reg [Y_BITS-1:0] y3 = 432;
reg [Y_BITS-1:0] y4 = 576;

reg which_way = 1;

// Scale correctly here
always @(posedge(vn_in)) begin
    if (x2 >= total_active_pix) begin 
        which_way <= 0;
        x2 <= total_active_pix;
    end
    else if (x2 <= 0) begin
        which_way <= 1;
        x2 <= 0;
    end
    
    if (which_way)
        x2 <= x2 + 1;
    else
        x2 <= x2 - 1;
end

wire square_1_draw;
wire square_2_draw;
wire square_3_draw;
wire square_4_draw;

square square_1 (
    .value(channel_1),
    .y1(y1),
    .vsync(vn_in),
    .total_active_pix(total_active_pix),
    .x(x),
    .y(y),
    .draw(square_1_draw)
);

square square_2 (
    .value(channel_1),
    .y1(y2),
    .vsync(vn_in),
    .total_active_pix(total_active_pix),
    .x(x),
    .y(y),
    .draw(square_2_draw)
);

square square_3 (
    .value(channel_1),
    .y1(y3),
    .vsync(vn_in),
    .total_active_pix(total_active_pix),
    .x(x),
    .y(y),
    .draw(square_3_draw)
);

square square_4 (
    .value(channel_1),
    .y1(y4),
    .vsync(vn_in),
    .total_active_pix(total_active_pix),
    .x(x),
    .y(y),
    .draw(square_4_draw)
);

reg square_draw;

always @(posedge clk_in) begin
    vn_out <= vn_in;
    hn_out <= hn_in;
    den_out <= dn_in;
    
    if (reset)
        ramp_values <= 0;
    
    else if (pattern == 8'b0) begin //custom box pattern

        square_draw <= (square_1_draw || square_2_draw || square_3_draw || square_4_draw);

        if (square_draw) begin
            if (square_1_draw) begin
                r_out <= 8'd255;
                g_out <= 8'd255;
                b_out <= 8'd128;
            end

            if (square_2_draw) begin
                r_out <= 8'd128;
                g_out <= 8'd128;
                b_out <= 8'd255;
            end

            if (square_3_draw) begin
                r_out <= 8'd255;
                g_out <= 8'd128;
                b_out <= 8'd128;
            end

            if (square_4_draw) begin
                r_out <= 8'd128;
                g_out <= 8'd255;
                b_out <= 8'd128;
            end
        end

        else begin
            r_out <= r_in;
            g_out <= g_in;
            b_out <= b_in;    
        end
        
        

        //else begin 
        //     r_out <= r_in;
        //     g_out <= g_in;
        //     b_out <= b_in;
        // end
    end

    else if (pattern == 8'b1) begin //border
        if (dn_in && ((y == 12'b0) || (x == 12'b0) || (x == total_active_pix - 1) || (y == total_active_lines - 1))) begin
            r_out <= 8'hFF;
            g_out <= 8'hFF;
            b_out <= 8'hFF;
        end

        else begin
            r_out <= r_in;
            g_out <= g_in;
            b_out <= b_in;
        end
    end

    else if (pattern == 8'd2) begin // moireX
        if ((dn_in) && x[0] == 1'b1) begin
            r_out <= 8'hFF;
            g_out <= 8'hFF;
            b_out <= 8'hFF;
        end
        else begin
            r_out <= 8'b0;
            g_out <= 8'b0;
            b_out <= 8'b0;
        end
    end

    else if (pattern == 8'd3) begin // moireY
        if ((dn_in) && y[0] == 1'b1) begin
            r_out <= 8'hFF;
            g_out <= 8'hFF;
            b_out <= 8'hFF;
        end
        else begin
            r_out <= 8'b0;
            g_out <= 8'b0;
            b_out <= 8'b0;
        end
    end

    else if (pattern == 8'd4) begin // Simple RAMP
        r_out <= ramp_values[B+FRACTIONAL_BITS-1:FRACTIONAL_BITS];
        g_out <= ramp_values[B+FRACTIONAL_BITS-1:FRACTIONAL_BITS];
        b_out <= ramp_values[B+FRACTIONAL_BITS-1:FRACTIONAL_BITS];
        
        if ((x == total_active_pix - 1) && (dn_in))
            ramp_values <= 0;
        else if ((x == 0) && (dn_in))
            ramp_values <= ramp_step;
        else if (dn_in)
            ramp_values <= ramp_values + ramp_step;
    end

    else begin
        r_out <= r_in;
        g_out <= g_in;
        b_out <= b_in;
    end
end

endmodule