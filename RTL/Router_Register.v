module Router_Register(input clk,resetn,pkt_valid,
				  input [7:0] data_in,
				  input fifo_full,detect_addr,ld_state,laf_state,full_state,lfd_state,rst_int_reg,
				  output reg error,parity_done,low_pkt_valid,
				  output reg [7:0] data_out);
				  
reg [7:0] hold_header_byte,fifo_full_state_byte,internal_parity,packet_parity_byte;
//--------------------------------------------------------------------------------------------------------------
//parity done
always@(posedge clk)
	begin
		if(!resetn)
			begin
				parity_done<=1'b0;
			end
	
		else 
			begin
				if(ld_state && !fifo_full && !pkt_valid)
						parity_done<=1'b1;
				else if(laf_state && low_pkt_valid && !parity_done)
						parity_done<=1'b1;
				else
					begin
						if(detect_addr)
							parity_done<=1'b0;
					end
			end
	end
//--------------------------------------------------------------------------------------------------------------------
//low_packet valid
always@(posedge clk)
	begin
		if(!resetn)
			low_pkt_valid<=1'b0;
		else 
			begin
				if(rst_int_reg)
					low_pkt_valid<=1'b0;
				if(ld_state==1'b1 && pkt_valid==1'b0)
					low_pkt_valid<=1'b1;
			end
	end
//----------------------------------------------------------------------------------------------------------
//dout
always@(posedge clk)

	begin
		if(!resetn)
			data_out<=8'b0;
		else
		begin
			if(detect_addr && pkt_valid)
				hold_header_byte<=data_in;
			else if(lfd_state)
				data_out<=hold_header_byte;
			else if(ld_state && !fifo_full)
				data_out<=data_in;
			else if(ld_state && fifo_full)
				fifo_full_state_byte<=data_in;
			else 
				begin
					if(laf_state)
						data_out<=fifo_full_state_byte;
				end
		end
	end
//-----------------------------------------------------------------------------------------------------
// internal parity
always@(posedge clk)
	begin
		if(!resetn)
			internal_parity<=8'b0;
		else if(lfd_state)
			internal_parity<=internal_parity ^ hold_header_byte;
		else if(ld_state && pkt_valid && !full_state)
			internal_parity<=internal_parity ^ data_in;
		else 
			begin	
				if (detect_addr)
					internal_parity<=8'b0;
			end
	end
//--------------------------------------------------------------------------------------------------------	
//error and packet_
always@(posedge clk)
	begin
		if(!resetn)
			packet_parity_byte<=8'b0;
		else 
			begin
				if(!pkt_valid && ld_state)
					packet_parity_byte<=data_in;
			end
	end
//-------------------------------------------------------------------------------------------------------------------------------------
//error
always@(posedge clk)
	begin
		if(!resetn)
			error<=1'b0;
		else 
			begin
				if(parity_done)
				begin
					if(internal_parity!=packet_parity_byte)
						error<=1'b1;
					else
						error<=1'b0;
				end
			end
	end

endmodule 
