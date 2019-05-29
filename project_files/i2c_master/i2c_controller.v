module i2c_controller(
    input wire clk_in, //50Mhz
    input wire reset,
    input wire start,
    input wire [7:0] dev_addr,
    input wire [7:0] reg_addr,
    input wire [7:0] data,

    output wire[7:0] states, //not necessary
    
    inout wire i2c_sda,
    output wire i2c_scl,
    output wire ready_out
);

wire clk_100hz;


//100KHz (clk divider automatically splits)
i2c_clk_divider 
#(.DELAY(500)) 
// #(.DELAY(2)) // Uncomment when running sim and comment above
clk_divider
(
    .reset(reset),
    .ref_clk(clk_in),
    .i2c_clk(clk_100hz)
);

i2c_master master (
    .clk(clk_100hz),
    .reset(reset),
    .start(start),
    .dev_id(dev_addr),
    .reg_id(reg_addr),
    .data(data),
    .i2c_sda(i2c_sda),
    .i2c_scl(i2c_scl),
    .ready(ready_out),
    .states(states)
);



endmodule