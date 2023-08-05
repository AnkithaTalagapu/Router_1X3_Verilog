module tb_Router_TOP();

reg clk, resetn, read_enb_0, read_enb_1, read_enb_2, pkt_valid;
reg [7:0]data_in;
wire [7:0]data_out_0, data_out_1, data_out_2;
wire vld_out_0, vld_out_1, vld_out_2, error, busy;
integer i;

Router_TOP DUT(clk, resetn, pkt_valid, read_enb_0, read_enb_1, read_enb_2,data_in,       //order based
			   vld_out_0, vld_out_1, vld_out_2, error, busy,data_out_0, data_out_1, data_out_2 );			   
			   
//clock generation

initial 
	begin
	clk = 1;
	forever 
	#5 clk=~clk;
	end
	
	
	task reset;
		begin
			resetn=1'b0;
			{read_enb_0, read_enb_1, read_enb_2, pkt_valid, data_in}=0;
			#10;
			resetn=1'b1;
		end
	endtask
	
	task pktm_gen_8;	// packet generation payload 8
			reg [7:0]header, payload_data, parity;
			reg [8:0]payloadlen;
			
			begin
				parity=0;
				wait(!busy)
				begin
				@(negedge clk);
				payloadlen=8;
				pkt_valid=1'b1;
				header={payloadlen,2'b10};
				data_in=header;
				parity=parity^data_in;
				end
				@(negedge clk);
							
				for(i=0;i<payloadlen;i=i+1)
					begin
					wait(!busy)				
					@(negedge clk);
					payload_data={$random}%256;
					data_in=payload_data;
					parity=parity^data_in;				
					end					
								
				wait(!busy)				
					@(negedge clk);
					pkt_valid=0;				
					data_in=parity;
					repeat(30)
			@(negedge clk);
			read_enb_1=1'b1;
			end
endtask
	
	task pktm_gen_5;	// packet generation payload 8
			reg [7:0]header, payload_data, parity;
			reg [4:0]payloadlen;
			
			begin
				parity=0;
				wait(!busy)
				begin
				@(negedge clk);
				payloadlen=5;
				pkt_valid=1'b1;
				header={payloadlen,2'b10};
				data_in=header;
				parity=parity^data_in;
				end
				@(negedge clk);
							
				for(i=0;i<payloadlen;i=i+1)
					begin
					wait(!busy)				
					@(negedge clk);
					payload_data={$random}%256;
					data_in=payload_data;
					parity=parity^data_in;				
					end					
								
				wait(!busy)				
					@(negedge clk);
					pkt_valid=0;				
					data_in=parity;
					repeat(30)
			@(negedge clk);
			read_enb_2=1'b1;
			end
endtask
	
	initial
		begin
			reset;
			#10;
			pktm_gen_8;
			pktm_gen_5;
			#1000;
			$finish;
		end
		
		
endmodule