onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/dut/clk_i
add wave -noupdate /top/dut/rst_i
add wave -noupdate -group Write_Signals /top/dut/wr_en_i
add wave -noupdate -group Write_Signals /top/dut/wr_ptr
add wave -noupdate -group Write_Signals /top/dut/wdata_i
add wave -noupdate -group Write_Signals /top/dut/full_o
add wave -noupdate -group Write_Signals /top/dut/wr_toggle
add wave -noupdate -group Write_Signals /top/dut/overflow_o
add wave -noupdate -group Read_Signals /top/dut/rd_en_i
add wave -noupdate -group Read_Signals /top/dut/rd_ptr
add wave -noupdate -group Read_Signals /top/dut/rdata_o
add wave -noupdate -group Read_Signals /top/dut/empty_o
add wave -noupdate -group Read_Signals /top/dut/rd_toggle
add wave -noupdate -group Read_Signals /top/dut/underflow_o
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {121 ps}
