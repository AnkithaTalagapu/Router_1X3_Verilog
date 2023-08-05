module Router_FIFO#(parameter WIDTH=8,DEPTH=16,ADDR=5)   // parameterized module 
   
   (input clk,resetn,soft_reset,write,read,lfd_state,input [WIDTH-1:0]data_in,
   output reg [WIDTH-1:0]data_out,output full,empty);
   
   integer i;
   reg lfd_state_s;
   reg [WIDTH:0]fifo_mem[DEPTH-1:0];
   reg [ADDR-1:0]read_ptr,write_ptr;
   reg [WIDTH-1:0]fifo_counter;
   
   // fifo down counter 
   always@(posedge clk)
     begin
	   if(!resetn)  
	     fifo_counter <= 8'b0;
	   else if(soft_reset)
	     fifo_counter <= 8'bz;
	   else if(read && ~empty)
	     begin  
		   if(fifo_mem[read_ptr[3:0]][8]==1'b1)
		    fifo_counter <= fifo_mem[read_ptr[3:0]][7:2] + 1'b1;
		   else if(fifo_counter !=0)
		     fifo_counter <= fifo_counter - 1'b1;
		 end
     end
	 
	 // lfd delay logic 
	 always@(posedge clk)
	   begin 
	   if(~resetn)
	     lfd_state_s <= 0;
	   else 
	     lfd_state_s <= lfd_state;
	   end
	   
  // read operation 
  wire w1=(fifo_counter ==0 && data_out!=0)? 1'b1:1'b0;
  always@(posedge clk)
    begin 
	  if(!resetn)
	    data_out <= 8'b0;
	  else if(soft_reset)
	    data_out <= 8'bz;
	  else
	    begin 
		  if(w1)
		    data_out <= 8'bz;
		  else if(read && ~empty)
		    data_out <= fifo_mem[read_ptr[3:0]];
	    end
    end
  
  // write operation
  always@(posedge clk)
    begin 
	  if(!resetn)
	    begin
		 for(i=0;i<16;i=i+1)
		   begin 
		     fifo_mem[i] <=0;
		   end
	    end
	  else if(soft_reset)
	    begin
		  for(i=0;i<16;i=i+1)
		    begin 
			  fifo_mem[i] <= 0;
			end
		end
	else 
	  begin 
	    if(write && ~full)
		  {fifo_mem[write_ptr[3:0]][8],fifo_mem[write_ptr[3:0]][7:0]} = {lfd_state,data_in};
	  end
    end
	
	// incrementing pointers
  always@(posedge clk)
    begin
	if(~resetn)
	  begin
	  write_ptr <= 5'b0;
	  read_ptr <= 5'b0;
	  end
	else if(soft_reset)
	  begin 
	  write_ptr <= 5'b0;
	  read_ptr <= 5'b0;
	  end
	else
	  begin
	    if(write && !full)
		  write_ptr <= write_ptr +1;
		else
		  write_ptr <= write_ptr;
	    if(read && !empty)
		  read_ptr <= read_ptr + 1;
		else
		read_ptr <= read_ptr;
	  end
    end

assign full = (write_ptr =={~read_ptr[4],read_ptr[3:0]})?1'b1:1'b0;
assign empty = (write_ptr == read_ptr)?1'b1:1'b0;
endmodule 
		  
	
		

		   
   
   
		  
	
		

		   
   
   
