module tb_Router_Synchronizer();
 
  reg clk,resetn,detect_addr,write_enb_reg,empty_0,empty_1,empty_2,full_0,full_1,full_2,read_enb_0,read_enb_1,read_enb_2;
  reg [1:0]data_in;
  wire vld_out_0,vld_out_1,vld_out_2;
  wire fifo_full,soft_reset_0,soft_reset_1,soft_reset_2;
  wire [2:0]write_enb;
  reg [1:0]int_addr_reg;
  reg timer_0,timer_1,timer_2;
  parameter cycle=10;
  
  //Instantiation 
Router_Synchronizer DUT(clk,resetn,detect_addr,write_enb_reg,
                        empty_0,empty_1,empty_2,full_0,full_1,full_2,            //order based
						read_enb_0,read_enb_1,read_enb_2,data_in,
						vld_out_0,vld_out_1,vld_out_2,fifo_full,
						soft_reset_0,soft_reset_1,soft_reset_2,write_enb);

// clock generation
  always
    begin
         #(cycle/2);
           clk=1'b1;
         #(cycle/2);
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

//task for inputs
   task stimulus(input [1:0]j);
     begin

       detect_addr=1'b1;
       data_in=j;
       write_enb_reg=1'b1;
     end
   endtask

//task for read  
  task read(input x,y,z);
      begin
        read_enb_0=x;
        read_enb_1=y;
        read_enb_2=z;
      end
   endtask

//task for full
   task full(input a,b,c);
     begin
       full_0=a;
       full_1=b;
       full_2=c;
     end
   endtask

//task for empty  
   task empty(input p,q,r);
     begin
       empty_0=p;
       empty_1=q;
       empty_2=r;
     end
   endtask

//calling tasks
        initial
          begin
             reset;
			 #5;
			 stimulus(2'b10);
			 read(1,1,0);
			 full(0,0,1);
			 empty(1,1,0);
			 #500;
			 $finish;
                end
endmodule
