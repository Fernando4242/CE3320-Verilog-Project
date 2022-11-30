`define CK2Q 5 // Defines the Clock - to - Q Delay of the flip flop.
module source(reset, clk, in_seq, out_seq);
input reset;
input clk;
input in_seq;
output out_seq;
 
reg out_seq;
reg in_seq_reg;
 
//--------------- Defining State machine states ---------------
parameter SIZE = 2;
parameter S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;
 
//--------------- Internal Variables ---------------
reg [SIZE - 1 : 0] state;
reg [SIZE - 1 : 0] next_state;
 
//--------------- Register the in_seq ---------------
always @(posedge clk)
	begin
		if (reset == 1'b0) 
		begin
			in_seq_reg <= #`CK2Q 1'b0;
		end
		else
		begin
			in_seq_reg <= #`CK2Q in_seq;
		end
	end
 
 //--------------- Mealy State machined Code Starts Here ------------------------------
 //Determine the next state for each state in the state machine using the input
 //sequence given to it. 'next_state' is combinatorial in nature. 1010
 //------------------------------------------------------------------------------------
 always @(state or in_seq_reg)
	begin
		next_state = 2'b00;
		case(state)
			S0 : 
				if (in_seq_reg == 1'b1) 
				begin
					next_state = S1;
				end
				else
				begin
					next_state = S0;
				end
			S1 : 
				if (in_seq_reg == 1'b0)
				begin
					next_state = S2;
				end
				else
				begin
					next_state = S1;
				end
			S2 : 
				if (in_seq_reg == 1'b1)
				begin
					next_state = S3;
				end
				else
				begin
					next_state = S1;
				end
			S3 : 
				if (in_seq_reg == 1'b0)
				begin
					next_state = S2;
				end
				else
				begin
					next_state = S1;
				end
		endcase
	end

 //------------------------------------------------------------------------------------------
 //register the combinatorial next_state variable.
 //------------------------------------------------------------------------------------------
 always @(posedge clk)
	begin
		if (reset == 1'b0)
		begin
			state <= #`CK2Q S0;
		end
		else
		begin
			state <= #`CK2Q next_state;
		end
	end
 
 //------------------------------------------------------------------------------------------
 //Based on the combinatorial next_state signal and the input sequence, determine the output
 //out_seq of the finite state machine.
 //------------------------------------------------------------------------------------------
 always @(state or in_seq_reg or reset)
	begin
		if (reset == 1'b0)
		begin
			out_seq <= 1'b0;
		end
		else
		begin
			case(state)
				S3 : 
					begin
						if (in_seq_reg == 1'b0)
						begin
							out_seq <= 1'b1;
						end
						else
							out_seq <= 1'b0;
						end
				default : 
					begin
						out_seq <= 1'b0;
					end
			endcase
		end
	end
 endmodule // end of Module Mealy state machine