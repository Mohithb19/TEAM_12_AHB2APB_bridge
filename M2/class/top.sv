// -----------------------------------------------------------------------------
// Project: AHB APB Bridge Verification
// Module:  Monitor
// File:    monitor.sv
// -----------------------------------------------------------------------------\
//Team members:
//   Daniel Jacobsen
//   BALAJI Ginkal Harisha
//   Mohith Kumar Bennahatti Chikkegowda
//   Akshaya Kudumalakunte Ravi Kumar
// Created: 16/Feb/2025 
//
/* Description: 
// The `ahb_apb_top` module serves as the top-level testbench, integrating all testbench components
 and linking them to the Device Under Verification (DUT). The DUT, an AHB to APB bridge, 
 is instantiated under the module name `Bridge_Top`.
//
// The top module incorporates several files, each serving a specific purpose:  
1. transactions.sv – Contains the definition of the `Transaction` class.  
2. generator.sv – Defines the `Generator` class responsible for creating transactions.  
3. interface.sv – Establishes the interface for communication.  
4. driver.sv – Implements the `Driver` class to drive signals to the DUT.  
5. monitor.sv – Defines the `Monitor` class for observing transactions.  
6. scoreboard.sv – Manages the `Scoreboard` class for result verification.  
7. coverage.sv – Includes the `Coverage` class for coverage collection.  
8. environment.sv – Sets up the `Environment` class, integrating all components.  
9. test.sv – Contains the `Test` class to execute test scenarios.  
10. bridge_top.v – The Verilog module representing the DUT (Design Under Test).
//
// The top module generates a clock signal, `clk`, with a total period of 10 ns (5 ns for each half-cycle).
 The `reset` signal is initially set to 0 and transitions to 1 after 10 time units.
//
// The `test` class is instantiated as `test_h`, and its `run` method is invoked to initiate the test. 
The simulation is then halted after 100000 time units using the `$stop` system task.
//
// The DUT, instantiated as 'dut', is connected to the testbench through an instance 
of the `ahb_apb_bfm_if` interface named 'bfm'. This interface facilitates driving signals 
into the DUT and monitoring the signals output by the DUT.
// -----------------------------------------------------------------------------
*/

`include "transactions.sv"
`include "generator.sv"
`include "interface.sv"
`include "driver.sv"
`include "monitor.sv"
`include "scoreboard.sv"
`include "coverage.sv"
`include "environment.sv"
`include "test.sv"  
`include "AHB_Slave_Interface.sv"
`include "APB_Controller.sv"
`include "Bridge_Top.sv"  

module ahb_apb_top;

  logic clk, reset;

  // Generates clk with a time period of 5 ns
  always
  begin
    forever begin
      #5 clk = ~clk;
    end
  end

 

  ahb_apb_bfm_if bfm(clk, reset); // Connect clock and reset


  // Connecting DUT signals with signals present on the interface
// Connecting DUT signals with signals present on the interface
Bridge_Top dut(
    .Hclk(bfm.clk),
    .Hresetn(bfm.resetn),
    .Hwrite(bfm.Hwrite),
    .Hreadyin(bfm.Hreadyin),
    .Htrans(bfm.Htrans),
    .Hwdata(bfm.Hwdata),
    .Haddr(bfm.Haddr),
    .Hrdata(bfm.Hrdata),
    .Hresp(bfm.Hresp),
    .Hreadyout(bfm.Hreadyout),
    .Prdata(bfm.Prdata),
    .Pwdata(bfm.Pwdata),
    .Paddr(bfm.Paddr),
    .Pselx(bfm.Pselx),
    .Pwrite(bfm.Pwrite),
    .Penable(bfm.Penable)
);


  // test ahb_apb_test(bfm); // -> not initialized
    test test_h;
    Transaction trans;
  initial begin
    $display("in top");
    trans = new();
    //trans.cov_cg.sample();  // -> to get the coverage
	test_h = new(bfm);
	test_h.run();

	
  end

 // Initialize clk and reset
  initial begin
    clk = 1;
    reset = 0;
    #10
    reset = 1;
	

    #100000;
    $stop; // Stops simulation
  end

endmodule


