

module clockDivider #(parameter bits, parameter factor) (

	input  wire ref_clk,
	input  wire reset_n,
	output reg  output_clk

);

reg [bits-1:0] count = 0;

always @(posedge(ref_clk), negedge(reset_n)) 
  begin
	
	if (!reset_n) 
	begin
		output_clk = 1'b0;
		count = 0;	
		//Reset Counter
	end 
	
	else if (count == (factor/2) - 1) 
	  begin
		//Switch for second half of counter 
		count = 0;
		output_clk = ~output_clk;
		
	  end 
	
	else //Increment Counter
	 begin
		count = count + 1'b1;	
	 end

  end

endmodule