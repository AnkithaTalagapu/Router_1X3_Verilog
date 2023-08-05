module Router_FSM(input clk,resetn,pkt_valid,
				  input [1:0] data_in,
				  input fifo_full,fifo_empty_0,fifo_empty_1,fifo_empty_2,soft_reset_0,soft_reset_1,soft_reset_2,parity_done, low_pkt_valid, 
				  output write_enb_reg,detect_addr,ld_state,laf_state,lfd_state,full_state,rst_int_reg,busy);
				  
 parameter  DECODE_ADDR		=	3'b000,
			WAIT_TILL_EMPTY		=	3'b001,
			LOAD_FIRST_DATA		=	3'b010,
			LOAD_DATA			=	3'b011,
			LOAD_PARITY			=	3'b100,
			FIFO_FULL_STATE		=	3'b101,
			LOAD_AFT_FULL		=	3'b100,
			CHECK_PARITY_ERROR	=	3'b111;
			
reg [2:0] present_state, next_state;
reg [1:0] addr;

//addr logic
always@(posedge clk)
	begin
		if(~resetn)
			addr<=2'b0;
		else if(detect_addr)          // decides the address of out channel
		 	addr<=data_in;
	end
	
// reset logic for states
always@(posedge clk)
	begin
		if(!resetn)
				present_state<=DECODE_ADDR;  // hard reset
		else if (((soft_reset_0) && (addr==2'b00)) || ((soft_reset_1) && (addr==2'b01)) || ((soft_reset_2) && (addr==2'b10)))		//if there is soft_reset and also using same channel so we do here and opertion
				 
				present_state<=DECODE_ADDR;

		else
				present_state<=next_state;
			
	end
	
// FSM logic

always@(*)
	begin
		case(present_state)
      // decode address state -------------------------------------------------------------------------------------------------------------------------------------
		
		DECODE_ADDR:   
		begin
			if((pkt_valid && (data_in==2'b00) && fifo_empty_0)|| (pkt_valid && (data_in==2'b01) && fifo_empty_1)|| (pkt_valid && (data_in==2'b10) && fifo_empty_2))

					next_state<=LOAD_FIRST_DATA;   //lfd_state

			else if((pkt_valid && (data_in==2'b00) && !fifo_empty_0)||(pkt_valid && (data_in==2'b01) && !fifo_empty_1)||(pkt_valid && (data_in==2'b10) && !fifo_empty_2))
					next_state<=WAIT_TILL_EMPTY;  
				
			else 
				next_state<=DECODE_ADDR;	   
		end
		
     //load first data state ----------------------------------------------------------------------------------------------------------------------------------------
		LOAD_FIRST_DATA: 			
		begin	
			next_state<=LOAD_DATA;
		end

        // wait till empty state ---------------------------------------------------------------------------------------------------------------------------------------
		WAIT_TILL_EMPTY:         
		begin
			if((fifo_empty_0 && (addr==2'b00))||(fifo_empty_1 && (addr==2'b01))||(fifo_empty_2 && (addr==2'b10))) //fifo is empty and were using same fifo
					next_state<=LOAD_FIRST_DATA;  //lfd state
	
				else
					next_state<=WAIT_TILL_EMPTY;
			end
		
       // load data state --------------------------------------------------------------------------------------------------------------------------------------------		
		LOAD_DATA:                   
		begin
			if(fifo_full==1'b1) 
					next_state<=FIFO_FULL_STATE;
			else 
					begin
						if (!fifo_full && !pkt_valid)
							next_state<=LOAD_PARITY;
						else
							next_state<=LOAD_DATA;   //ld state
					end
		end
		
	//fifo full state ------------------------------------------------------------------------------------------------------------------------------------------
			FIFO_FULL_STATE:			
			begin
				if(fifo_full==0)
					next_state<=LOAD_AFT_FULL;     //laf state
				else 
					next_state<=FIFO_FULL_STATE;
			end
         
	 // load after full state -----------------------------------------------------------------------------------------------------------------------------------
			LOAD_AFT_FULL:         
			begin
				if(!parity_done && low_pkt_valid)
					next_state<=LOAD_PARITY;
				else if(!parity_done && !low_pkt_valid)
					next_state<=LOAD_DATA;           //ld state
	
				else 
					begin 
						if(parity_done==1'b1)
							next_state<=DECODE_ADDR;
						else
							next_state<=LOAD_AFT_FULL;   ///laf state
					end
				
			end
			
	 //load parity state -------------------------------------------------------------------------------------------------------------------------------------
			LOAD_PARITY:                 
				next_state<=CHECK_PARITY_ERROR;
			
	 //check parity error state -------------------------------------------------------------------------------------------------------------------
			CHECK_PARITY_ERROR:			
			begin
				if(!fifo_full)
					next_state<=DECODE_ADDR;
				else
					next_state<=FIFO_FULL_STATE;
			end
			
			default:					//default state
				next_state<=DECODE_ADDR; 

		endcase																					// state machine completed
	end
	
// output logic


assign busy=((present_state==LOAD_FIRST_DATA)||(present_state==LOAD_PARITY)||(present_state==FIFO_FULL_STATE)||(present_state==LOAD_AFT_FULL)||(present_state==WAIT_TILL_EMPTY)||(present_state==CHECK_PARITY_ERROR))?1:0;
assign detect_addr=((present_state==DECODE_ADDR))?1:0;
assign lfd_state=((present_state==LOAD_FIRST_DATA))?1:0;
assign ld_state=((present_state==LOAD_DATA))?1:0;
assign write_enb_reg=((present_state==LOAD_DATA)||(present_state==LOAD_AFT_FULL)||(present_state==LOAD_PARITY))?1:0;
assign full_state=((present_state==FIFO_FULL_STATE))?1:0;
assign laf_state=((present_state==LOAD_AFT_FULL))?1:0;
assign rst_int_reg=((present_state==CHECK_PARITY_ERROR))?1:0;
endmodule














