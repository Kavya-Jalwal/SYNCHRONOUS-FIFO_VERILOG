module fifo_sync
 #(parameter FIFO_DEPTH =8,
   parameter DATA_WIDTH=32)
   (input clk,rst_n,cs,wr_en,rd_en,
    input [DATA_WIDTH-1:0] data_in,
    output reg [DATA_WIDTH-1:0] data_out,
    output empty,full
 );
 localparam FIFO_DEPTH_LOG = $clog2(FIFO_DEPTH); //specify locations from (000-111)
 reg [DATA_WIDTH-1:0] fifo [0:FIFO_DEPTH-1]; //array of 8 locations each having 32 bit data
 reg [FIFO_DEPTH_LOG : 0] write_pointer; //both read and write pointer have 1 extra bit for full and empty operation
 reg [FIFO_DEPTH_LOG :0 ] read_pointer;
 //write
 always @(posedge clk or negedge rst_n)
  begin
  if(!rst_n) write_pointer<=0;
  else if(cs && wr_en && !full)begin
    fifo[write_pointer[FIFO_DEPTH_LOG-1:0]]<=data_in;
    write_pointer<=write_pointer+1'b1;
  end
  end
 //read 
always @(posedge clk or negedge rst_n)
  begin
  if(!rst_n) read_pointer<=0;
  else if(cs && rd_en && !empty)begin
    data_out<=fifo[read_pointer[FIFO_DEPTH_LOG-1:0]];
    read_pointer<=read_pointer+1'b1;
  end
  end
assign empty =(read_pointer == write_pointer);
assign full= (read_pointer== {~write_pointer[FIFO_DEPTH_LOG] , write_pointer[FIFO_DEPTH_LOG-1:0] });

  
  
 
endmodule
