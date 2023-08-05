module tb_Router_Register();

reg clk, resetn, pkt_valid,fifo_full, detect_addr, ld_state, laf_state, full_state, lfd_state, rst_int_reg;
reg [7:0] data_in;
wire error, parity_done, low_pkt_valid;
wire [7:0]data_out;
integer i;
parameter CYCLE=10;
//Instantiation 
Router_Register DUT( clk,resetn,pkt_valid,data_in,                          // order based
				     fifo_full,detect_addr,ld_state,laf_state,full_state,lfd_state,rst_int_reg,
				     error,parity_done,low_pkt_valid,data_out);   

//clock generation
  always 
	begin
	#(CYCLE/2)
	clk = 1;
	#(CYCLE/2)
	clk=~clk;
	end
	
//task for reset	
	task reset;
		begin
			resetn=1'b0;
			#10;
			resetn=1'b1;
		end
	endtask
	
//task for loading data in the form of packet i.e., header, payload, parity
	task packet1();
	
			reg [7:0]header, payload_data, parity;
			reg [5:0]payloadlen;
			begin
				@(negedge clk);
				payloadlen=8;
				parity=0;
				detect_addr=1'b1;
				pkt_valid=1'b1;
				header={payloadlen,2'b10};
				data_in=header;
				parity=parity^data_in;

				@(negedge clk);
				detect_addr=1'b0;
				lfd_state=1'b1;
		
				for(i=0;i<payloadlen;i=i+1)	
					begin
					@(negedge clk);	
					lfd_state=0;
					ld_state=1;
	
					payload_data={$random}%256;
					data_in=payload_data;
					parity=parity^data_in;				
					end

					@(negedge clk);	
					pkt_valid=0;
					data_in=parity;
				
					@(negedge clk);
					ld_state=0;
					end
		
     endtask
     
	 task packet2();
	
			reg [7:0]header, payload_data, parity;
			reg [5:0]payloadlen;
			begin
				@(negedge clk);
				payloadlen=8;
				parity=0;
				detect_addr=1'b1;
				pkt_valid=1'b1;
				header={payloadlen,2'b10};
				data_in=header;
				parity=parity^data_in;

				@(negedge clk);
				detect_addr=1'b0;
				lfd_state=1'b1;
		
				for(i=0;i<payloadlen;i=i+1)	
					begin
					@(negedge clk);	
					lfd_state=0;
					ld_state=1;
	
					payload_data={$random}%256;
					data_in=payload_data;
					parity=parity^data_in;				
					end

					@(negedge clk);	
					pkt_valid=0;
					data_in=!parity;
				
					@(negedge clk);
					ld_state=0;
					end
	  endtask
   // calling tasks 
   initial
	  begin
		reset;
		fifo_full=1'b0;
		laf_state=1'b0;
	        full_state=1'b0;
		#20;
		packet1();
		#105;
		packet2();
		$finish;
	 end
	
 endmodule 



