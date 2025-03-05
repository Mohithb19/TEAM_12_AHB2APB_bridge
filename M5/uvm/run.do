# ECE 593 Pre-Si Validation QuestaSim Script (run.do)

# Remove previous compilation logs (but NOT the work library)
if [file exists transcript] { file delete transcript }

# Create and map work library
vlib work
vmap work work

# Ensure a clean compilation environment
vdel -lib work -all

# Compile all dependencies first
#vlog -work work -sv ahb_intf.sv
#vlog -work work -sv apb_intf.sv
vlog -work work -sv bus_interfaces.sv
vlog -work work -sv DUT.sv

# Now compile tb_top.sv since it depends on the above
vlog -work work -sv tb_top.sv

# Run simulation with coverage
vsim -cvgperinstance -c tb_top -do "
    coverage save -onexit covfile.ucdb;
    run -all;
    exit;
"

# Run functional simulation
vsim -c tb_top -do "
    vsim -timescale 1ns/1ns -access +rw +UVM_TESTNAME=ahb_apb_bridge_burst_read_test +UVM_VERBOSITY=UVM_NONE -coverage all -covfile covfile.ccf -covdut ahb2apb -uvmnocdnsextra work.tb_top;
    run -all;
    quit;
"

# Generate coverage report
vsim -cvgperinstance -viewcov covfile.ucdb -do "
    coverage report -file ahb_apb_bridge_report.txt -byfile -detail -noannotate -option -cvg;
"
