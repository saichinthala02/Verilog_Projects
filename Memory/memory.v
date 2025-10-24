//--> Implementation of Memory.
module memory(clk_i,rst_i,wr_rd_i,addr_i,wdata_i,valid_i,rdata_o,ready_o);
	parameter WIDTH = 8;
	parameter DEPTH = 16;
	parameter ADDR  = $clog2(DEPTH);

	input clk_i,rst_i,wr_rd_i,valid_i;
	input [ADDR-1:0]addr_i;
	input [WIDTH-1:0]wdata_i;
	output reg [WIDTH-1:0]rdata_o;
	output reg ready_o;

	reg [WIDTH-1:0] mem[DEPTH-1:0];
	integer i;

	always@(posedge clk_i) begin
		if(rst_i==1) begin
			rdata_o=0;
			ready_o=0;
			for(i=0;i<DEPTH;i=i+1)begin
				mem[i]=0;
			end
		end
		else begin
			if(valid_i==1) begin
				ready_o = 1;
				if(wr_rd_i==1) begin
					mem[addr_i]=wdata_i;
				end
				else rdata_o=mem[addr_i];
			end
			else ready_o = 0;
		end
	end
endmodule
