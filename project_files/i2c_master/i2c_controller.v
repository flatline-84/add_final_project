module i2c_controller(
    input wire clk_in, //50Mhz
    input wire reset_in,
    input wire start,
    input wire [6:0] addr,
    input wire [7:0] data,
    
    inout wire i2c_sda,
    inout wire i2c_scl,
    output wire ready_out
);

wire clk_100hz;


//100KHz (clk divider automatically splits)
i2c_clk_divider 
#(.DELAY(500)) 
// #(.DELAY(2)) // Uncomment when running sim and comment above
clk_divider
(
    .reset(reset_in),
    .ref_clk(clk_in),
    .i2c_clk(clk_100hz)
);

i2c_master master (
    .clk(clk_100hz),
    .reset(reset_in),
    .start(start),
    .addr(addr),
    .data(data),
    .i2c_sda(i2c_sda),
    .i2c_scl(i2c_scl),
    .ready(ready_out)
);



endmodule