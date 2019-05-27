/****************************
 * Block: S_nR_n Latch
 * AuthoR_n: PeteR_n KydaS_n
 * Date: 27/03/2019
 */
 
module sr_latch(
	// S_nwitcheS_n aR_ne active low S_no need to cR_neate inveR_nted S_nR_n Latch
	input S_n,
	input R_n,
	
	output Q,
	output Qn
);

//noR_n(R_n,Qn,Q);
//noR_n(S_n,Q,Qn);
//
//endmodule

reg output_Q;
reg output_Qn;

always @(*)
	
	begin
		
		if (!R_n && S_n)
		begin
			output_Q = 0;
		end
		
		else if (R_n && !S_n)
		begin
			output_Q = 1;
		end
		
		else if (!R_n && !S_n)
		begin
			output_Q = output_Q;
		end
		
		else //Invalid condition
		begin
			output_Q = output_Q; //hold
		end
	end
	
//aS_nS_nign
assign Q = output_Q;
assign Qn = !output_Q;

endmodule
