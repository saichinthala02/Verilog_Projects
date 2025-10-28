//--> Implementation of Asynchronous FIFO Test-Bench.
`include "asynch_fifo.v"
module top;
	parameter DEPTH = 16;
	parameter DATA_WIDTH = 12;
	parameter PTR_WIDTH = $clog2(DEPTH);

	reg wclk_i,rclk_i,rst_i,wr_en_i,rd_en_i;
	reg [DATA_WIDTH-1:0] wdata_i;
	wire [DATA_WIDTH-1:0] rdata_o;
	wire full_o,empty_o,overflow_o,underflow_o;

	integer i,j,l,k,wr_delay,rd_delay;
	reg [25*8:0] test_name;

	asynch_fifo #(.DEPTH(DEPTH),.DATA_WIDTH(DATA_WIDTH)) dut(
														.wclk_i     (wclk_i),
														.rclk_i     (rclk_i),
														.rst_i      (rst_i),
														.wr_en_i    (wr_en_i),
														.rd_en_i    (rd_en_i),
														.wdata_i    (wdata_i),
														.rdata_o    (rdata_o),
														.full_o     (full_o),
														.empty_o    (empty_o),
														.overflow_o (overflow_o),
														.underflow_o(underflow_o));
	initial begin
		wclk_i=0;
		forever #5 wclk_i = ~wclk_i;
	end

	initial begin
		rclk_i=0;
		forever #9 rclk_i = ~rclk_i;
	end


	initial begin
		$value$plusargs("test_name=%0s",test_name);
		reset_fifo();
		case(test_name)
			"test_1w" : begin
				write_fifo(1);
			end
			"test_1w_1r" : begin
				write_fifo(1);
				read_fifo(1);
			end
			"test_5w" : begin
				write_fifo(5);
			end
			"test_5w_5r" : begin
				write_fifo(5);
				read_fifo(5);
			end
			"test_full_wr_rd" : begin
				write_fifo(DEPTH);
				read_fifo(DEPTH);
			end
			"FULL" : begin
				write_fifo(DEPTH);
			end
			"OVERFLOW" : begin
				write_fifo(DEPTH+1);
				read_fifo(1);
			end
			"EMPTY" : begin
				write_fifo(DEPTH);
				read_fifo(DEPTH);
			end
			"UNDERFLOW" : begin
				write_fifo(DEPTH);
				read_fifo(DEPTH+1);
			end
			"CONCURRENT" : begin
				fork 
					for(l=0;l<DEPTH;l=l+1)begin
						write_fifo(1);
						wr_delay=$urandom_range(5,8);
						#(wr_delay);
					end
					for(k=0;k<DEPTH;k=k+1)begin
						read_fifo(1);
						rd_delay=$urandom_range(5,8);
						#(rd_delay);
					end
				join				
			end
		endcase
       	#100;
		$finish;
	end

	//--> FIFO Reset Task --> Apply and Release Reset.
	task reset_fifo();
		begin
			rst_i=1;
			wr_en_i=0;
			rd_en_i=0;
			wdata_i=0;
			repeat(2)@(posedge wclk_i);
			rst_i=0;
		end
	endtask

	//--> FIFO Write Task.
	task write_fifo(input integer num_writes);
		begin
			for(i=0;i<num_writes;i=i+1)begin
				@(posedge wclk_i);
				wr_en_i=1;
				wdata_i=$random;
			end
			@(posedge wclk_i);
			wr_en_i=0;
			wdata_i=0;
		end
	endtask

	//--> FIFO Read Task.
	task read_fifo(input integer num_reads);
		begin
			wait(empty_o==0);
			for(j=0;j<num_reads;j=j+1)begin
				@(posedge rclk_i);
				rd_en_i=1;
			end
			@(posedge rclk_i);
			rd_en_i=0;
		end
	endtask
endmodule
