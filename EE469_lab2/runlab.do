# Create work library
vlib work

# Compile Verilog
#     All Verilog files that are part of this design should have
#     their own "vlog" line below.
vlog "./alu.sv"
vlog "./alustim.sv"
vlog "./full_adder.sv"
vlog "./mux2_1.sv"
vlog "./mux4_1.sv"
vlog "./mux8_1.sv"
vlog "./nth_alu.sv"
vlog "./zero_flag.sv"

# Call vsim to invoke simulator
#     Make sure the last item on the line is the name of the
#     testbench module you want to execute.
vsim -voptargs="+acc" -t 1ps -lib work alustim

# Source the wave do file
#     This should be the file that sets up the signal window for
#     the module you are testing.
do alustim_wave.do

# Set the window types
view wave
view structure
view signals

# Run the simulation
run -all

# End
