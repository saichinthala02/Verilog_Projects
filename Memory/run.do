vlib work
vlog memory_tb.v
vsim top +testcase=test_data_walking_ones
#add wave -position insertpoint sim:/top/dut/*
do wave.do
run -all
