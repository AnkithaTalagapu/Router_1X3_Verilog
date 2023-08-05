module tb_Router_FSM();     
   reg clk,resetn,pkt_valid,fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done, low_pkt_valid;
   reg [1:0]data_in;     
   wire write_enb_reg,detect_addr,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy;
   
   parameter CYCLE=10;   
   
   Router_FSM DUT(clk,resetn,pkt_valid,data_in,
				  fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,               //order based 
				  soft_reset_0,soft_reset_1,soft_reset_2,parity_done, low_pkt_valid, 
				  write_enb_reg,detect_addr,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);
    
  //clock generation    
	always
    begin     
	#(CYCLE/2);
      clk = 1'b0;     
	  #(CYCLE/2);
      clk=~clk;   
	end
       
   //task for reset
   task reset();
     begin     
      resetn = 1'b0;
	  #10;
      resetn = 1'b1;    
	 end
   endtask 
   
   task intialize();    
     begin
      data_in=2'b00;    
	 end
   endtask  
   
   task stimulus(input [1:0]k, input l, input m, input n,input a, input b, input c, input d, input e, input f, input g);    
     begin
      @(negedge clk)     
	  data_in = k;
     soft_reset_0 = l;     
	 soft_reset_1 = m;
     soft_reset_2 = n;     
	 pkt_valid = a;
     low_pkt_valid = b;     
	 fifo_empty_0 = c;
     fifo_empty_1 = d;
     fifo_empty_2 = e;     
	 fifo_full = f;
     parity_done =g;    
	end
   endtask   
  
  initial    
    begin
     reset;     
	 intialize;
     stimulus({1'b0,1'b0}, 1'b0, 1'b0, 1'b0,1'b1, 1'b0, 1'b1, 1'b1, 1'b1, 1'b0, 1'b0);     
     stimulus({1'b0,1'b0}, 1'b0, 1'b0, 1'b0,1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);     
	 stimulus({1'b0,1'b0}, 1'b0, 1'b0, 1'b0,1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);     
     stimulus({1'b0,1'b0}, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);//0-2-3-4-7-0     
     stimulus({1'b0,1'b1}, 1'b0, 1'b1, 1'b1,1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0);          
	 stimulus({1'b0,1'b1}, 1'b0, 1'b0, 1'b0,1'b1, 1'b0, 1'b1, 1'b1, 1'b0, 1'b0, 1'b0);
     stimulus({1'b0,1'b1}, 1'b0, 1'b0, 1'b0,1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);          
	 stimulus({1'b0,1'b1}, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
     stimulus({1'b0,1'b1}, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);     
	 stimulus({1'b0,1'b1}, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0);
     stimulus({1'b0,1'b1}, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1);//0-2-3-5-6-3-4-7-0     
     stimulus({1'b1,1'b0}, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);     
	 stimulus({1'b1,1'b0}, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
     stimulus({1'b1,1'b0}, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);     
	 stimulus({1'b1,1'b0}, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0);
     stimulus({1'b1,1'b0}, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);     
	 stimulus({1'b1,1'b0}, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);
     stimulus({1'b1,1'b0}, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0);     
	 stimulus({1'b1,1'b0}, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
     stimulus({1'b1,1'b0}, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);     
	 stimulus({1'b1,1'b0}, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);
     stimulus({1'b1,1'b0}, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);     
	 stimulus({1'b1,1'b0}, 1'b0, 1'b0, 1'b0, 1'b0, 1'b1, 1'b0, 1'b0, 1'b0, 1'b0, 1'b0);//0-1-2-3-4-7-5-6-4-7-0
     #10 $finish;    
   end
   always@(DUT.present_state)    
      begin
         $display("present state", DUT.present_state);    
	 end
endmodule