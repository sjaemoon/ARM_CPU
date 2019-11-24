onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /pipelinedstim/dut/clk
add wave -noupdate /pipelinedstim/dut/reset
add wave -noupdate -expand -group {IF Stage} -radix unsigned /pipelinedstim/dut/PC/PC_internal
add wave -noupdate -expand -group {IF Stage} -radix hexadecimal /pipelinedstim/dut/PC/Stagereg_in
add wave -noupdate -expand -group {DEC Stage} -expand -group {Branch Signals} /pipelinedstim/dut/PC/BrTaken
add wave -noupdate -expand -group {DEC Stage} -expand -group {Branch Signals} /pipelinedstim/dut/PC/UncondBr
add wave -noupdate -expand -group {DEC Stage} -expand -group {Branch Signals} /pipelinedstim/dut/PC/pc_rd
add wave -noupdate -expand -group {DEC Stage} /pipelinedstim/dut/PC/Instr_out
add wave -noupdate -group {Register File Signals} -group {Register Control Signals} /pipelinedstim/dut/datapath/RegisterStage/rf/RegWrite
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[31]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[30]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[29]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[28]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[27]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[26]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[25]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[24]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[23]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[22]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[21]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[20]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[19]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[18]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[17]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[16]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[15]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[14]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[13]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[12]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[11]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[10]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[9]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[8]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[7]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[6]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[5]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[4]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[3]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[2]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[1]}
add wave -noupdate -group {Register File Signals} -group {Register Contents} -radix decimal {/pipelinedstim/dut/datapath/RegisterStage/rf/regOut[0]}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {10485760 ps}
