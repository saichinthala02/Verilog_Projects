//--> Implementation of Memory Test-Bench.
`include "memory.v"
module top;
	parameter WIDTH = 8;
	parameter DEPTH = 16;
	parameter ADDR  = $clog2(DEPTH);

	reg clk_i,rst_i,wr_rd_i,valid_i;
	reg [ADDR-1:0]addr_i;
	reg [WIDTH-1:0]wdata_i;
	wire [WIDTH-1:0]rdata_o;
	wire ready_o;
	integer i;
	integer start_pos,end_pos;
	reg [25*8:0] testcase;

	memory #(.WIDTH(WIDTH), .DEPTH(DEPTH))dut(
											  .clk_i(clk_i),
											  .rst_i(rst_i),
											  .wr_rd_i(wr_rd_i),
											  .addr_i(addr_i),
											  .wdata_i(wdata_i),
											  .valid_i(valid_i),
											  .rdata_o(rdata_o),
											  .ready_o(ready_o));
	
	initial begin
		clk_i=0;
		forever #5 clk_i=~clk_i;
	end

	initial begin
		$value$plusargs("testcase=%0s",testcase);
		$display("=========================================");
		$display("Running testcase: %0s", testcase);
		$display("=========================================");
		reset_mem();
		case(testcase)
			"mem_1w_1r"			  : begin
										write_mem(0,1);
										read_mem(0,1);
						  			end
			"mem_5w_5r" 		  : begin
										write_mem(0,5);
										read_mem(0,5);
						  			end
			"mem_1w"			  : begin
										write_mem(0,1);
									end
			"mem_5w"			  : begin
										write_mem(0,5);
									end
			"mem_write"			  : begin
										write_mem(0,DEPTH);
						  			end
			"mem_full_wr_rd"  	  : begin
										write_mem(0,DEPTH);
										read_mem(0,DEPTH);
						 			end
			"mem_1/4_write_read"  : begin
										write_mem(0,DEPTH/4);
										read_mem(0,DEPTH/4);
						 			end
			"mem_half_write_read" : begin
								        write_mem(0,DEPTH/2);
										read_mem(0,DEPTH/2);
						  			end
			"mem_3/4_write_read"  : begin
								       	write_mem(0,3*(DEPTH/4));
								       	read_mem(0,3*(DEPTH/4));
									end
			"mem_3/4_wr_rd_only"  : begin
								       	write_mem(DEPTH/2,3*(DEPTH/4));
								       	read_mem(DEPTH/2,3*(DEPTH/4));
						 		  	end
			"test_fd_write_fd_read"	: begin
										  write_mem(0,DEPTH);
										  read_mem(0,DEPTH);
									  end
			"test_bd_write_bd_read"	: begin
										  mem_bd_write();
										  mem_bd_read();
									  end
			"test_bd_write_fd_read"	: begin
										  mem_bd_write();
										  read_mem(0,DEPTH);
									  end
			"test_fd_write_bd_read"	: begin
										  write_mem(0,DEPTH);
										  mem_bd_read();
									  end		
			"test_data_walking_ones" : begin
									    	walking_ones(0,DEPTH);
											read_mem(0,DEPTH);
									   end
			"test_data_walking_zeros" : begin
										    walking_zeros(0,DEPTH);
											read_mem(0,DEPTH);
									   end	
			"test_addr_walking_ones" : begin
										    walking_addr_ones(0,4);
											read_mem(0,DEPTH);
									   end	
			"test_addr_walking_zeros" : begin
										    walking_addr_zeros(0,ADDR);
											read_mem(0,DEPTH);
									   end						   
		endcase

		#100;
		$finish;
	end

//--> Reset_Memory_Task.
	task reset_mem();
		begin
			rst_i   = 1;
			wr_rd_i = 0;
			valid_i = 0;
			addr_i  = 0;
			wdata_i = 0;
			repeat(2)@(posedge clk_i);
			rst_i=0;
		end
	endtask

//--> Memory_Write_Task.
	task write_mem(input integer start_pos,input integer end_pos);
		begin
			for(i=start_pos;i<end_pos;i=i+1)begin
				@(posedge clk_i);
				valid_i = 1;
				wait(ready_o==1);
				wr_rd_i = 1;
				addr_i  = i;
				wdata_i = $random;		
			end
				@(posedge clk_i);
				valid_i = 0;
				wr_rd_i = 0;
				addr_i  = 0;
				wdata_i = 0;
		end
	endtask

//--> Memory_Read_Task.
	task read_mem(input integer start_pos,input integer end_pos);
		begin
			for(i=start_pos;i<end_pos;i=i+1)begin
				@(posedge clk_i);
				valid_i = 1;
				wait(ready_o==1);
				wr_rd_i = 0;
				addr_i  = i;
			end
				@(posedge clk_i);
				valid_i = 0;
				wr_rd_i = 0;
				addr_i  = 0;
				wdata_i = 0;
		end
	endtask

//--> Memory_Back_Door_Write.
	task mem_bd_write();
		begin
			$readmemh("data.hex",dut.mem);
		end
	endtask

//--> Memory_Back_Door_Read.
	task mem_bd_read();
		begin
			$writememb("output.bin",dut.mem);
		end
	endtask

//--> Memory_Walking_Ones
	task walking_ones(input integer start_pos, input integer end_pos);
	  integer bit_pos;
	  reg [WIDTH-1:0] pattern;
	  begin
	 	  for (i = start_pos; i < end_pos; i = i + 1) begin
	 	      @(posedge clk_i);
	 	      valid_i = 1;
	 	      wait(ready_o == 1);
	 	      wr_rd_i = 1;
	 	      addr_i  = i;
	 	      bit_pos = i % WIDTH;
	 	      pattern = 1 << bit_pos;
	 	      wdata_i = pattern;
	 	  end
	    @(posedge clk_i);
	    valid_i = 0;
	    wr_rd_i = 0;
	    addr_i  = 0;
	    wdata_i = 0;
	  end
	endtask

//--> Memory_Walking_Zeros
	task walking_zeros(input integer start_pos, input integer end_pos);
	  integer bit_pos;
	  reg [WIDTH-1:0] pattern;
	  begin
	 	 for (i = start_pos; i < end_pos; i = i + 1) begin
	 		 @(posedge clk_i);
	 		 valid_i = 1;
	 		 wait(ready_o == 1);
	 		 wr_rd_i = 1;
	 		 addr_i  = i;
	 		 bit_pos = i % WIDTH;
	 		 pattern = 1 << bit_pos;
	 		 wdata_i = ~pattern;
	 	 end
	
	    @(posedge clk_i);
	    valid_i = 0;
	    wr_rd_i = 0;
	    addr_i  = 0;
	    wdata_i = 0;
	  end
	endtask

//--> Memory_adderss_walking_ones
	task walking_addr_ones(input integer start_pos,input integer end_pos);
	integer a;
	reg [ADDR-1:0] pattern;
		begin
			for(i=start_pos;i<end_pos;i=i+1)begin
				@(posedge clk_i);
				valid_i=1;
				wr_rd_i=1;
				wdata_i=$random;
				a = i%ADDR;
				pattern = 1<<a;
				addr_i=pattern;
				wait(ready_o==1);
			end
			@(posedge clk_i);
			valid_i = 0;
			wr_rd_i = 0;
			addr_i  = 0;
			wdata_i = 0;
		end
	endtask

//--> Memory_adderss_walking_Zeros
	task walking_addr_zeros(input integer start_pos,input integer end_pos);
	integer a;
	reg [ADDR-1:0] pattern;
		begin
			for(i=start_pos;i<end_pos;i=i+1)begin
				@(posedge clk_i);
				valid_i=1;
				wr_rd_i=1;
				wdata_i=$random;
				a = i%ADDR;
				pattern = 1<<a;
				addr_i=~pattern;
				wait(ready_o==1);
			end
			@(posedge clk_i);
			valid_i = 0;
			wr_rd_i = 0;
			addr_i  = 0;
			wdata_i = 0;
		end
	endtask
endmodule


