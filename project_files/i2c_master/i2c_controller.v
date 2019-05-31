module i2c_controller(
    input wire clk_in, //50Mhz
    input wire reset,
    input wire start,
    input wire [7:0] dev_addr,
    input wire [15:0] reg_data,
    // input wire [7:0] data,

    output wire ack,
    output wire[7:0] states, //not necessary
    inout wire i2c_sda,
    output wire i2c_scl,
    output wire ready_out
);

wire clk_100hz;

wire i2c_sda_wire;

//assign i2c_sda = i2c_sda_wire ? 1'bz : 1'b0;
assign i2c_sda = i2c_sda_wire ? 1'bz : 1'b0;

//100KHz (clk divider automatically splits)
// i2c_clk_divider 
// #(.DELAY(2500)) 
// // #(.DELAY(2)) // Uncomment when running sim and comment above
// clk_divider
// (
//     .reset(reset),
//     .ref_clk(clk_in),
//     .i2c_clk(clk_100hz)
// );

i2c_master master (
    .clk(clk_in),
    .reset(reset),
    .start(start),
    .dev_address(dev_addr),
    // .reg_id(reg_addr),
    .reg_data(reg_data),
    .ack(ack),
    .sda_input(i2c_sda), //for checking acknowledge
    .i2c_sda(i2c_sda_wire),
    .i2c_scl(i2c_scl),
    .finish(ready_out),
    .state(states)
);



endmodule