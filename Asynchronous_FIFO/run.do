vlib work
vlog tb_asynch_fifo.v
vsim top +test_name=EMPTY
#add wave -position insertpoint sim:/top/dut/*
do wave.do
run -all
