# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./de1_2.sv"
vlog "./de4_16.sv"
vlog "./de2_4.sv"
vlog "./de5_32.sv"
vlog "./register.sv"
vlog "./regfile.sv"
vlog "./D_FF.sv"
vlog "./D_FF_en.sv"
vlog "./mux2_1.sv"
vlog "./mux4_1.sv"
vlog "./mux8_1.sv"
vlog "./mux16_1.sv"
vlog "./mux32_1.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work regstim

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do mux4_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
