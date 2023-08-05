module Router_Synchronizer(input clk,resetn,detect_addr,write_enb_reg,empty_0,empty_1,empty_2,full_0,full_1,full_2,read_enb_0,read_enb_1,read_enb_2,
                           input [1:0]data_in,
						   output vld_out_0,vld_out_1,vld_out_2,
                           output reg fifo_full,soft_reset_0,soft_reset_1,soft_reset_2,
                           output reg [2:0]write_enb);
  reg [1:0]int_addr_reg;
  reg [4:0]timer_0,timer_1,timer_2;
  wire W0,W1,W2;

// Valid out logic
  assign vld_out_0= ~empty_0;
  assign vld_out_1= ~empty_1;
  assign vld_out_2= ~empty_2;

// Timer logic
  assign W0=(timer_0==5'd30)?1'b1:1'b0;
  assign W1=(timer_1==5'd30)?1'b1:1'b0;
  assign W2=(timer_2==5'd30)?1'b1:1'b0;
 
// Soft reset counter
always@(posedge clk)
        begin
                if(!resetn)
                  begin
                    soft_reset_0 <= 1'b0;
                        timer_0<=5'b0;
                  end
                else if(vld_out_0)
                        begin
                                if(!read_enb_0)
                                        begin
                                                if(W0)
                                                        begin
                                                                soft_reset_0<=1'b1;
                                                                timer_0<=1'b0;
                                                        end
                                                else
                                                        begin
                                                                timer_0<=timer_0+1'b1;
                                                                soft_reset_0<=1'b0;
                                                        end
                                        end
                                else timer_0<=5'd0;
                        end
                else timer_0<=5'd0;
        end
always@(posedge clk)
        begin
                if(!resetn)
                  begin
                    soft_reset_1 <= 1'b0;
                        timer_1<=5'b0;
                  end
                else if(vld_out_1)
                        begin
                                if(!read_enb_1)
                                        begin
                                                if(W1)
                                                        begin
                                                                soft_reset_1<=1'b1;
                                                                timer_1<=1'b0;
                                                        end
                                                else
                                                        begin
                                                                timer_1<=timer_1+1'b1;
                                                                soft_reset_1<=1'b0;
                                                        end
                                        end
                                else timer_1<=5'd0;
                        end
                else timer_1<=5'd0;
        end
always@(posedge clk)
        begin
                if(!resetn)
                  begin
                    soft_reset_2 <= 1'b0;
                        timer_2<=5'b0;
                  end
                else if(vld_out_2)
                        begin
                                if(!read_enb_2)
                                        begin
                                                if(W2)
                                                        begin
                                                                soft_reset_2<=1'b1;
                                                                timer_2<=1'b0;
                                                        end
                                                else
                                                        begin
                                                                timer_2<=timer_2+1'b1;
                                                                soft_reset_2<=1'b0;
                                                        end
                                        end
                                else timer_2<=5'd0;
                        end
                else timer_2<=5'd0;
        end
//------------------------------------------------------------------------------------
  always@(posedge clk)
   begin
        if(!resetn)
          int_addr_reg <= 2'b0;
        else if(detect_addr)
          int_addr_reg <= data_in;
   end
   
// Write enable logic   
   always@(*)
    begin
         write_enb =3'b00;
         if(write_enb_reg)
           begin
            case(int_addr_reg)
                  2'b00 : write_enb = 3'b001;
                  2'b01 : write_enb = 3'b010;
                  2'b10 : write_enb = 3'b100;
                default : write_enb = 3'b000;
                endcase
           end
    end

// For Full 
  always@(*)
    begin
        case(int_addr_reg)
          2'b00 : fifo_full = full_0;
          2'b01 : fifo_full = full_1;
          2'b10 : fifo_full = full_2;
        default : fifo_full = 1'b0;
        endcase
    end
endmodule
