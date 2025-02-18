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
/*
Description: 
In a SystemVerilog verification environment, the Test class plays a vital role by coordinating 
the execution of test cases and ensuring their seamless integration during the simulation process.

The Test class is responsible for creating an instance of the environment class while passing 
it the interface handle. Its run task initiates the environment and executes test sequences iteratively 
over multiple clock cycles.
// -----------------------------------------------------------------------------
*/
class test;

    environment env;  // creates handle

    function new(virtual ahb_apb_bfm_if i);
        env = new(i); 
    endfunction : new

    task run();
       // $display("in test");   
        env.create();  

        repeat(50) begin 
            //$display("in test repeat");
            env.run_test();
            #5;
        end
    endtask

endclass

