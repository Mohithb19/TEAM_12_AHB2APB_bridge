############### ECE 593 Pre-Si Validation ###############

.PHONY: all compile run_coverage run clean report

# Default target
all: clean compile run_coverage report

compile:
	vlog bus_interfaces.sv DUT.sv tb_top.sv

run_coverage:
	vsim -cvgperinstance -c Bridge_Top tb_top -do "coverage save -onexit covfile.ucdb; run -all; exit"

run:
	vsim -c tb_top -do "vsim -Q -timescale 1ns/1ns -access +rw +UVM_TESTNAME=ahb_apb_bridge_burst_read_test +UVM_VERBOSITY=UVM_NONE -coverage all -covfile covfile.ccf -covdut ahb2apb -uvmnocdnsextra work.top; run -all; quit"


clean:
	rm -rf work
	rm -rf transcript

report:
	vsim -cvgperinstance -viewcov covfile.ucdb -do "coverage report -output report.txt -srcfile=* -detail -option -cvg"
