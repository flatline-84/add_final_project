module i2c_clk_divider(
    input wire reset,
    input wire ref_clk, //50MHz
    output reg i2c_clk
);

parameter DELAY = 500; // CHANGE THIS FOR 100kHz from 50MHz

reg [8:0] count = 0; //can go to 512 MAX

always @(posedge(ref_clk)) begin
    if (reset == 1) begin
        i2c_clk <= 0;
        count <= 0;
    end

    else begin
        if (count == ((DELAY/2)-1)) begin
            i2c_clk <= ~i2c_clk;
            count <= 0;
        end
        else begin
            count <= count + 1;
        end
    end
    
end

endmodule