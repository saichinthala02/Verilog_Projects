//--> Implementation of Synchronous FIFO.
module synch_fifo(clk_i,rst_i,wr_en_i,rd_en_i,wdata_i,rdata_o,full_o,empty_o,overflow_o,underflow_o);
	parameter DEPTH = 16;
	parameter DATA_WIDTH = 12;
	parameter PTR_WIDTH = $clog2(DEPTH);

	input clk_i,rst_i,wr_en_i,rd_en_i;
	input [DATA_WIDTH-1:0] wdata_i;
	output reg [DATA_WIDTH-1:0] rdata_o;
	output reg full_o,empty_o,overflow_o,underflow_o;

	reg [DATA_WIDTH-1:0] fifo[DEPTH-1:0];
	reg [PTR_WIDTH-1:0] wr_ptr,rd_ptr;
	reg wr_toggle,rd_toggle;
	integer i;

	always@(posedge clk_i)begin
		if(rst_i) begin
			rdata_o     = 0;
			full_o      = 0;
			empty_o     = 1;
			overflow_o  = 0;
			underflow_o = 0;
			wr_ptr      = 0;
			rd_ptr      = 0;
			wr_toggle   = 0;
			rd_toggle   = 0;
			for(i=0;i<DEPTH;i=i+1) begin
				fifo[i] = 0;
			end
		end
		else begin
			overflow_o=0;
			underflow_o=0;
			if(wr_en_i==1) begin
				if(full_o==1) overflow_o=1;
				else begin
					fifo[wr_ptr]=wdata_i;
					if(wr_ptr==DEPTH-1) begin
						wr_toggle=~wr_toggle;
						wr_ptr=0;
					end
					else wr_ptr=wr_ptr+1;
				end
			end
			if(rd_en_i==1) begin
				if(empty_o==1) underflow_o=1;
				else begin
					rdata_o=fifo[rd_ptr];
					if(rd_ptr==DEPTH-1) begin
						rd_toggle=~rd_toggle;
						rd_ptr=0;
					end
					else rd_ptr=rd_ptr+1;
				end
			end
		end
	end
	always@(*)begin
		empty_o=0;
		full_o=0;
		if(wr_ptr==rd_ptr  && wr_toggle==rd_toggle) empty_o=1;
		if(wr_ptr==rd_ptr  && wr_toggle!=rd_toggle) full_o=1;
	end
endmodule
