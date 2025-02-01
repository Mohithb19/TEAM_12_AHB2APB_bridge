# Create the work library
vlib work

# Compile all design files and testbench
vlog AHB_Master.sv
vlog AHB_Slave_Interface.sv
vlog APB_Controller.sv
vlog APB_Interface.sv
vlog Bridge_Top.sv
vlog testbench.sv

# Simulate the testbench
vsim -voptargs="+acc" work.bridge_tb

# Add signals to match report waveform
add wave -position insertpoint \
    sim:/bridge_tb/Pwrite \
    sim:/bridge_tb/Pwdata \
    sim:/bridge_tb/Pselx \
    sim:/bridge_tb/Prdata \
    sim:/bridge_tb/Penable \
    sim:/bridge_tb/Paddr \
    sim:/bridge_tb/Hwrite \
    sim:/bridge_tb/Hwdata \
    sim:/bridge_tb/Htrans \
    sim:/bridge_tb/Hresp \
    sim:/bridge_tb/Hresetn \
    sim:/bridge_tb/Hreadyout \
    sim:/bridge_tb/Hreadyin \
    sim:/bridge_tb/Hrdata \
    sim:/bridge_tb/Hclk \
    sim:/bridge_tb/Haddr \
    sim:/bridge_tb/errors

# Run the simulation
run -all

