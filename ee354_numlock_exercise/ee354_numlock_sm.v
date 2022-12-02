// Author: Simon To
// Create Date: 09/15/2022



`timescale 1ns / 1ps



/*
		.clk(Clk), 
		.reset(reset), 
		.q_I(q_I), 
		.q_G1get(q_G1get), 
		.q_G1(q_G1), 
		.q_G10get(q_G10get), 
		.q_G10(q_G10), 
		.q_G101get(q_G101get), 
		.q_G101(q_G101), 
		.q_G1011get(q_G1011get), 
		.q_G1011(q_G1011), 
		.q_Opening(q_Opening), 
		.q_Bad(q_Bad), 
		.U(U), 
		.Z(Z), 
		.Unlock(Unlock)
*/

module ee354_numlock_sm(clk, reset, q_I, q_G1get, q_G1, q_G10get, q_G10, q_G101get, q_G101,
q_G1011get, q_G1011, q_Opening, q_Bad, U, Z, Unlock);

	/*  INPUTS */
	// Clock & Reset
	input		clk, reset;
	input 	U, Z;
	
	/*  OUTPUTS */
	// store current state
	
	output q_I, q_G1get, q_G1, q_G10get, q_G10, q_G101get, q_G101, q_G1011get, q_G1011, 
	q_Opening, q_Bad;
	reg [10:0] state;
	
	assign { q_Bad, q_Opening, q_G1011, q_G1011get, q_G101, q_G101get, q_G10, q_G10get, q_G1, q_G1get, q_I} = state;
		
	// lets make accessing the state information easier within the state machine code
	// each line aliases the approriate state bits and sets up a 1-hot code
	localparam
		QI			=	11'b00000000001,
		QG1get		=	11'b00000000010,
		QG1			=	11'b00000000100,
		QG10get 	=	11'b00000001000,
		QG10 		=	11'b00000010000,
		QG101get 	=	11'b00000100000,
		QG101 		=	11'b00001000000,
		QG1011get 	= 	11'b00010000000,
		QG1011		=	11'b00100000000,
		QOpening 	=	11'b01000000000,
		QBad		=	11'b10000000000,
		UNK			=	11'bXXXXXXXXXXX;
	
	// our output leds (leftleft, left, right, rightright)
	output Unlock;	
	

	// NSL AND SM
	reg [3:0] DIV_CLK;
	
	always @ (posedge clk, posedge reset)
	begin : CLOCK_DIVIDER
		if (reset)
 			DIV_CLK <= 0;
 		else
 			begin
 				if (state == QOpening)
 					DIV_CLK <= DIV_CLK + 1'b1;
 				else
 					DIV_CLK <= 0;
 			end
 	end
		
	
	always @ (posedge clk, posedge reset)
	begin
		if(reset)
			state <= QI;
		else 
		begin
			case(state)
				QI:
					// dont worry about async reset here because 'if' statement considers this first
					if(U & ~Z)
						state <= QG1get;
				QG1get:
					if(~U)
						state <= QG1;
				QG1:
					if(~U & Z)
						state <= QG10get;
					else if (U)
					   state <= QBad;
				QG10get:
					if(~Z)
						state <= QG10;
				QG10:
					if(U & ~Z)
						state <= QG101get;
					else if (Z)
					   state <= QBad;
				QG101get:
					if(~U)
						state <= QG101;
				QG101:
					if(U & ~Z)
						state <= QG1011get;
					else if (Z)
					   state <= QBad;
				QG1011get:
					if(~U)
						state <= QG1011;
				QG1011:
					if(~U)
						state <= QOpening;
				QBad:
				    if (~U & ~Z)
				        state <= QI;
				QOpening:
					if(DIV_CLK == 4'b1111)
						state <= QI;
				default:
					state <= UNK;
				
			endcase
		end
	end
	
	
	// OFL
	assign Unlock = q_Opening;
	
endmodule
		
	