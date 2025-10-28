//--> Implementation of Asynchronous FIFO.
module asynch_fifo(wclk_i,rclk_i,rst_i,wr_en_i,rd_en_i,wdata_i,rdata_o,full_o,empty_o,overflow_o,underflow_o);
	parameter DEPTH = 16;
	parameter DATA_WIDTH = 12;
	parameter PTR_WIDTH = $clog2(DEPTH);

	input wclk_i,rclk_i,rst_i,wr_en_i,rd_en_i;
	input [DATA_WIDTH-1:0] wdata_i;
	output reg [DATA_WIDTH-1:0] rdata_o;
	output reg full_o,empty_o,overflow_o,underflow_o;

	reg [DATA_WIDTH-1:0] fifo[DEPTH-1:0];
	reg [PTR_WIDTH-1:0] wr_ptr,rd_ptr,wr_ptr_rd_clk,rd_ptr_wr_clk;
	wire [PTR_WIDTH-1:0] wr_gray_ptr,rd_gray_ptr;
	reg wr_toggle,rd_toggle,wr_toggle_rd_clk,rd_toggle_wr_clk;
	integer i;
	
	//--> Write always Block
	always@(posedge wclk_i)begin
		if(rst_i) begin
			rdata_o          <= 0;
			full_o           <= 0;
			empty_o          <= 1;
			overflow_o       <= 0;
			underflow_o      <= 0;
			wr_ptr           <= 0;
			rd_ptr           <= 0;
			wr_ptr_rd_clk    <= 0;
			rd_ptr_wr_clk    <= 0;
			wr_toggle        <= 0;
			rd_toggle        <= 0;
			wr_toggle_rd_clk <= 0;
			rd_toggle_wr_clk <= 0;
			//wr_gray_ptr    <= 0;
			//rd_gray_ptr    <= 0;

			for(i=0;i<DEPTH;i=i+1) begin
				fifo[i]  <= 0;
			end
		end
		else begin
			overflow_o=0;
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
		end
	end
	//--> Read always block
	always@(posedge rclk_i)begin
		if(rst_i==0)begin
			underflow_o=0;
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

	//--> Synchronization
	always@(posedge rclk_i) begin
		wr_ptr_rd_clk =  wr_gray_ptr;
		wr_toggle_rd_clk = wr_toggle;
	end
	always@(posedge wclk_i) begin
		rd_ptr_wr_clk =  rd_gray_ptr;
		rd_toggle_wr_clk = rd_toggle;
	end

	always@(*)begin
		full_o=0;
		empty_o=0;
		if(wr_gray_ptr==rd_ptr_wr_clk && wr_toggle!=rd_toggle_wr_clk) full_o=1;
		if(wr_ptr_rd_clk==rd_gray_ptr && wr_toggle_rd_clk==rd_toggle) empty_o=1;
	end
	assign wr_gray_ptr = wr_ptr ^ (wr_ptr>>1);
	assign rd_gray_ptr = rd_ptr ^ (rd_ptr>>1);
endmodule
