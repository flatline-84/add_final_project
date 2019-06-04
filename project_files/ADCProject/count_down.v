


module count_down #(parameter number_of_bits) (
	
	input  wire                    clk,
	input  wire                    reset_n,
	input  wire [number_of_bits - 1 : 0] count_from,
	output reg  [number_of_bits - 1 : 0] count_val

);

always @(posedge(clk), negedge(reset_n)) 
  begin

	if (!reset_n)
	  begin
	    count_val <= count_from;
	  end
		
	
	else if (count_val == {number_of_bits{1'b0} } )
	  begin
	    count_val <= {number_of_bits{1'b0}};
	  end
		

	else
	  begin
	    count_val <= count_val - 1'b1;
	  end
		

  end
  
endmodule
