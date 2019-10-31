transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/sjaem/Desktop/EE469_470/Lab1_files {C:/Users/sjaem/Desktop/EE469_470/Lab1_files/mux8_1.sv}
vlog -sv -work work +incdir+C:/Users/sjaem/Desktop/EE469_470/Lab1_files {C:/Users/sjaem/Desktop/EE469_470/Lab1_files/mux4_1.sv}
vlog -sv -work work +incdir+C:/Users/sjaem/Desktop/EE469_470/Lab1_files {C:/Users/sjaem/Desktop/EE469_470/Lab1_files/mux32_1.sv}
vlog -sv -work work +incdir+C:/Users/sjaem/Desktop/EE469_470/Lab1_files {C:/Users/sjaem/Desktop/EE469_470/Lab1_files/mux2_1.sv}
vlog -sv -work work +incdir+C:/Users/sjaem/Desktop/EE469_470/Lab1_files {C:/Users/sjaem/Desktop/EE469_470/Lab1_files/mux16_1.sv}
vlog -sv -work work +incdir+C:/Users/sjaem/Desktop/EE469_470/Lab1_files {C:/Users/sjaem/Desktop/EE469_470/Lab1_files/D_FF_en.sv}
vlog -sv -work work +incdir+C:/Users/sjaem/Desktop/EE469_470/Lab1_files {C:/Users/sjaem/Desktop/EE469_470/Lab1_files/D_FF.sv}
vlog -sv -work work +incdir+C:/Users/sjaem/Desktop/EE469_470/Lab1_files {C:/Users/sjaem/Desktop/EE469_470/Lab1_files/de2_4.sv}
vlog -sv -work work +incdir+C:/Users/sjaem/Desktop/EE469_470/Lab1_files {C:/Users/sjaem/Desktop/EE469_470/Lab1_files/de1_2.sv}
vlog -sv -work work +incdir+C:/Users/sjaem/Desktop/EE469_470/Lab1_files {C:/Users/sjaem/Desktop/EE469_470/Lab1_files/register.sv}
vlog -sv -work work +incdir+C:/Users/sjaem/Desktop/EE469_470/Lab1_files {C:/Users/sjaem/Desktop/EE469_470/Lab1_files/de5_32.sv}
vlog -sv -work work +incdir+C:/Users/sjaem/Desktop/EE469_470/Lab1_files {C:/Users/sjaem/Desktop/EE469_470/Lab1_files/de4_16.sv}
vlog -sv -work work +incdir+C:/Users/sjaem/Desktop/EE469_470/Lab1_files {C:/Users/sjaem/Desktop/EE469_470/Lab1_files/regfile.sv}

