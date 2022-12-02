
//////////////////////////////////////////////////
// Course: EE354L                               // 
// File: parity_ones_count.v counting 1's in X  //
// Gandhi Puvvada 1/29/2019                     //
////////////////////////////////////////////////// 

`timescale 1ns / 100ps

module parity (X, p);

	//inputs
	input[7:0] X;
	
	//outputs
	output p; // p for parity
	
	//declarations
	reg p;      // Notice the "reg" declaration,
				// This is because p is on the LHS of a statement 
				// in a begin..end block in an always construct 
				
	reg [3:0] ones_count;  // to count 1's in X
	integer i;  // "for" loop iteration control
	
//************** // TO DO // COMPLETE THE "for" LOOP BELOW	******************************	
	//parity generation 
	always @(X) begin
		ones_count = 4'b0000;     // Notice the need for starting with zero before the "for" loop
		for (i = 0; i <= 7; i = i+1)                     
			begin 
				if (X[i])
				    begin                 
						ones_count = ones_count + 1;
					end		  
			end
		p = ones_count[0];		//
	end


endmodule
