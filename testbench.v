module testbench();
//registers for inputs
reg reset, clk, in_seq;

//bit stream register
reg [15:0] data;

//bit shift indicator and output wire
integer shift;
wire out_seq;

//create source module
source seq_detector(reset, clk, in_seq, out_seq);

//reset and initial data setup
initial
	begin
		shift = 0;
		data = 16'b0010100110101010;
		reset = 1'b0;
		#1200;
		reset = 1'b1;
		#60000;
		$display("\n");
		$finish;
	end
	
//generate clock
initial
	begin
		clk = 1'b0;
		forever begin
			#600;
			clk = ~clk;
		end
	end
	
//handle sequence shift
always @(posedge clk)
	begin
		in_seq = data >> shift;
		shift = shift + 1;
		
		#50 //wait 50 nanoseconds
		
		//print information
		$write(in_seq);
		if(out_seq == 1'b1) 
			$display("\nSequence with or without overlap detected\n");
	end
endmodule