onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -radix unsigned /top/dut/wclk_i
add wave -noupdate -radix unsigned /top/dut/wr_en_i
add wave -noupdate -radix unsigned /top/dut/wr_ptr
add wave -noupdate -radix unsigned /top/dut/wr_gray_ptr
add wave -noupdate -radix unsigned /top/dut/wdata_i
add wave -noupdate -radix unsigned /top/dut/full_o
add wave -noupdate -radix unsigned /top/dut/wr_toggle
add wave -noupdate -radix unsigned /top/dut/overflow_o
add wave -noupdate -radix unsigned /top/dut/rd_ptr_wr_clk
add wave -noupdate -radix unsigned /top/dut/rd_toggle_wr_clk
add wave -noupdate -radix unsigned /top/dut/rst_i
add wave -noupdate -radix unsigned /top/dut/rclk_i
add wave -noupdate -radix unsigned /top/dut/rd_en_i
add wave -noupdate -radix unsigned /top/dut/rd_ptr
add wave -noupdate -radix unsigned /top/dut/rd_gray_ptr
add wave -noupdate -radix unsigned /top/dut/rdata_o
add wave -noupdate -radix unsigned /top/dut/empty_o
add wave -noupdate -radix unsigned /top/dut/rd_toggle
add wave -noupdate -radix unsigned /top/dut/underflow_o
add wave -noupdate -radix unsigned /top/dut/wr_ptr_rd_clk
add wave -noupdate -radix unsigned /top/dut/wr_toggle_rd_clk
add wave -noupdate -radix unsigned /top/dut/i
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {348 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {150 ps} {650 ps}
