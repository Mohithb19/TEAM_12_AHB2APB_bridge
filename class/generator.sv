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
 The SystemVerilog `generator` class is responsible for creating various types 
of transactions and transmitting them to the driver for execution. 
This module defines multiple test cases as tasks, each corresponding to a distinct transaction.  

Within the class, a transaction handle `tx` is utilized along with a mailbox `gen2driv` 
to facilitate communication with the driver. Additionally, the class integrates 
a virtual interface `vif` to interact with the DUT.

The `read_single_byte_nonseq_single_Htransfer_okay` task generates a read transaction,
 setting each field based on the test case requirements. Once the transaction is fully prepared, 
 it is transmitted to the driver using the `gen2driv.put(tx);` command.

// Each test case task performs similar operations, defining a unique transaction type with different field values.  

Additionally, the generator class samples each transaction for coverage using `tx.cov_cg.sample();`, 
ensuring that all transaction types are generated and executed, contributing to comprehensive functional coverage.
-----------------------------------------------------------------------------*/


class generator;

    Transaction tx;   // Handle for Htransactions          
    mailbox #(Transaction) gen2driv;  // Generator to Driver mailbox

    function new(mailbox #(Transaction) gen2driv);
        this.gen2driv = gen2driv;
    endfunction

    task generate_transaction();
        tx = new();
        tx.Haddr = $urandom;  // Randomize Haddr
        tx.Hwdata = $urandom; // Randomize Hwdata
        tx.Hburst = $urandom_range(1, 5); // Randomize Hburst between 001, 010, 011, 100, 101
        tx.Htrans = $urandom_range(2, 3); // Randomize Htrans between 10 and 11

        // Display transaction details from the generator
        $display("[GENERATOR] - Generated Transaction:");
        $display("[GENERATOR] - Haddr: %h, Hwdata: %h", tx.Haddr, tx.Hwdata);
        case (tx.Hburst)
            3'b001: $display("[GENERATOR] - Hburst: %b (INCR)", tx.Hburst);
            3'b010: $display("[GENERATOR] - Hburst: %b (WRAP4)", tx.Hburst);
            3'b011: $display("[GENERATOR] - Hburst: %b (INCR4)", tx.Hburst);
            3'b100: $display("[GENERATOR] - Hburst: %b (WRAP8)", tx.Hburst);
            3'b101: $display("[GENERATOR] - Hburst: %b (INCR8)", tx.Hburst);
            default: $display("[GENERATOR] - Hburst: %b (UNKNOWN)", tx.Hburst);
        endcase

        case (tx.Htrans)
            2'b10: $display("[GENERATOR] - Htrans: %b (NON-SEQ)", tx.Htrans);
            2'b11: $display("[GENERATOR] - Htrans: %b (SEQ)", tx.Htrans);
            default: $display("[GENERATOR] - Htrans: %b (UNKNOWN)", tx.Htrans);
        endcase

        // Randomize Hwrite (0 for read, 1 for write)
        tx.Hwrite = $urandom_range(0, 1);

        // Update transaction type based on Hwrite
        tx.update_trans_type();

        // Sample coverage
        tx.cov_cg.sample();

        // Send transaction to driver
        gen2driv.put(tx);
    endtask

endclass