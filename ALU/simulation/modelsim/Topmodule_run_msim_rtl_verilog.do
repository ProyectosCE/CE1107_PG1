transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -sv -work work +incdir+C:/Users/jimmy/GitHub/CE1107_PG1/ALU {C:/Users/jimmy/GitHub/CE1107_PG1/ALU/Topmodule.sv}
vlog -sv -work work +incdir+C:/Users/jimmy/GitHub/CE1107_PG1/ALU {C:/Users/jimmy/GitHub/CE1107_PG1/ALU/and_op.sv}
vlog -sv -work work +incdir+C:/Users/jimmy/GitHub/CE1107_PG1/ALU {C:/Users/jimmy/GitHub/CE1107_PG1/ALU/xor_op.sv}
vlog -sv -work work +incdir+C:/Users/jimmy/GitHub/CE1107_PG1/ALU {C:/Users/jimmy/GitHub/CE1107_PG1/ALU/sub_op.sv}
vlog -sv -work work +incdir+C:/Users/jimmy/GitHub/CE1107_PG1/ALU {C:/Users/jimmy/GitHub/CE1107_PG1/ALU/mul_op.sv}
vlog -sv -work work +incdir+C:/Users/jimmy/GitHub/CE1107_PG1/ALU {C:/Users/jimmy/GitHub/CE1107_PG1/ALU/mux4_1.sv}
vlog -sv -work work +incdir+C:/Users/jimmy/GitHub/CE1107_PG1/ALU {C:/Users/jimmy/GitHub/CE1107_PG1/ALU/alu.sv}
vlog -sv -work work +incdir+C:/Users/jimmy/GitHub/CE1107_PG1/ALU {C:/Users/jimmy/GitHub/CE1107_PG1/ALU/HEX_SevenSeg.sv}
vlog -sv -work work +incdir+C:/Users/jimmy/GitHub/CE1107_PG1/ALU {C:/Users/jimmy/GitHub/CE1107_PG1/ALU/UART.sv}
vlog -sv -work work +incdir+C:/Users/jimmy/GitHub/CE1107_PG1/ALU {C:/Users/jimmy/GitHub/CE1107_PG1/ALU/pwm_controller.sv}
vlog -sv -work work +incdir+C:/Users/jimmy/GitHub/CE1107_PG1/ALU {C:/Users/jimmy/GitHub/CE1107_PG1/ALU/UART_FSM.sv}
vlog -sv -work work +incdir+C:/Users/jimmy/GitHub/CE1107_PG1/ALU {C:/Users/jimmy/GitHub/CE1107_PG1/ALU/mux2_1.sv}

vlog -sv -work work +incdir+C:/Users/jimmy/GitHub/CE1107_PG1/ALU {C:/Users/jimmy/GitHub/CE1107_PG1/ALU/tb_UART.sv}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cyclonev_ver -L cyclonev_hssi_ver -L cyclonev_pcie_hip_ver -L rtl_work -L work -voptargs="+acc"  tb_UART

add wave *
view structure
view signals
run -all
