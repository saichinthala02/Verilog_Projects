vlib work
vlog tb_synch_fifo.v
vsim top +test_name=test_5w_5r
#add wave -position insertpoint sim:/top/dut/*
do wave.do
run -all
