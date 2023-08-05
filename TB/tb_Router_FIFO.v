module tb_Router_FIFO();

parameter DEPTH=16, WIDTH=9, ADDR_SIZE=5;
reg clk, resetn, write, read, lfd_state, soft_reset;
reg [7:0]data_in;
wire full, empty;	
wire [7:0]data_out;

// Instantiation
Router_FIFO DUT    (.clk(clk),
					.resetn(resetn),
					.soft_reset(soft_reset),
					.write(write),
					.read(read),
					.lfd_state(lfd_state),
					.data_in(data_in),
					.full(full),
					.empty(empty),
					.data_out(data_out));

	//clock generation
	initial 
	begin
	clk = 1;
	forever 
	#5 clk=~clk;
	end 
initial 
	begin
	resetn=1'b0;
	#10;
	resetn=1'b1;
	soft_reset=1'b1;
	#30;
	soft_reset=1'b0;
	
	lfd_state=1'b1;
	write=1'b1;
	#10;
	repeat(17)
		begin
			data_in={$random}%256;
			#10;
		end
	write=1'b0;
	#5;
	
	read=1'b1;
	#250;
	$finish; 
	end
endmodule
  
  