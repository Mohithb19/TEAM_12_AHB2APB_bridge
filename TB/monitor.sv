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
// Description: 
//The monitor class plays a vital role in the SystemVerilog testbench by observing 
//the interface, capturing transactions on the bus, and forwarding them to the 
//scoreboard for comparison with expected results. As a passive component, 
//it acts as a listener, ensuring non-intrusive monitoring of the Design Under Test (DUT).

//In this setup, the monitor continuously observes the signals on the AHB-APB bridge interface,
// creates transaction objects based on the detected activity, and sends them to the scoreboard 
//for verification. Operating in an infinite loop, it constantly monitors the interface for new transactions.

//To maintain synchronization, the monitor leverages a clocking block (mon_cb), 
//which ensures that signals are sampled accurately with the clock. 
//The captured values are then used to construct a transaction object, 
//which is subsequently transmitted to the scoreboard via a mailbox for further processing.

class ahb_apb_monitor;

    Transaction tx;      // Transaction handle            
    mailbox #(Transaction) mail2sb;  // Mailbox to the scoreboard
    virtual ahb_apb_bfm_if.slave vif; // Virtual interface reference

    function new(mailbox #(Transaction) mail2sb, virtual ahb_apb_bfm_if.slave vif);
        this.mail2sb = mail2sb;
        this.vif = vif;
    endfunction

    task watch;
        tx = new();
        
        // Loop to monitor transactions
        forever begin
            @(vif.mon_cb) begin  // Use the clocking block to sample the interface signals
                wait(vif.mon_cb.Htrans !== 2'b00); // Wait for any transaction to start

                // Capture transaction details
                tx.Haddr = vif.mon_cb.Haddr;
                tx.Hwdata = vif.mon_cb.Hwdata;
                tx.Hwrite = vif.mon_cb.Hwrite;
                tx.Htrans = vif.mon_cb.Htrans;
                tx.Paddr = vif.mon_cb.Paddr;
                tx.Pwdata = vif.mon_cb.Pwdata;
                tx.Pwrite = vif.mon_cb.Pwrite;
                tx.Pselx = vif.mon_cb.Pselx;
                tx.Prdata = vif.mon_cb.Prdata;

                // Display transaction details from the monitor
                $display("[MONITOR] - Observed Transaction:");
                $display("[MONITOR] - Haddr: %h, Hwdata: %h, Prdata: %h", tx.Haddr, tx.Hwdata, tx.Prdata);
                case (tx.Hburst)
                    3'b001: $display("[MONITOR] - Hburst: %b (INCR)", tx.Hburst);
                    3'b010: $display("[MONITOR] - Hburst: %b (WRAP4)", tx.Hburst);
                    3'b011: $display("[MONITOR] - Hburst: %b (INCR4)", tx.Hburst);
                    3'b100: $display("[MONITOR] - Hburst: %b (WRAP8)", tx.Hburst);
                    3'b101: $display("[MONITOR] - Hburst: %b (INCR8)", tx.Hburst);
                    default: $display("[MONITOR] - Hburst: %b (UNKNOWN)", tx.Hburst);
                endcase

                case (tx.Htrans)
                    2'b10: $display("[MONITOR] - Htrans: %b (NON-SEQ)", tx.Htrans);
                    2'b11: $display("[MONITOR] - Htrans: %b (SEQ)", tx.Htrans);
                    default: $display("[MONITOR] - Htrans: %b (UNKNOWN)", tx.Htrans);
                endcase

                mail2sb.put(tx); // Send the transaction to the scoreboard
            end
        end
    endtask

endclass