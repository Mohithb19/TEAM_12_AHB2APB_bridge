// -----------------------------------------------------------------------------
// Project: AHB APB Bridge Verification
// Module:  Driver
// File:    driver.sv
// -----------------------------------------------------------------------------
//Team members:
//   Daniel Jacobsen
//   BALAJI Ginkal Harisha
//   Mohith Kumar Bennahatti Chikkegowda
//   Akshaya Kudumalakunte Ravi Kumar
// Created: 16/Feb/2025 

//**SystemVerilog driver class** is responsible for receiving 
//transactions from the generator and driving them into the 
//**Design Under Verification (DUV)**. It communicates with the DUV using a **virtual interface
//(`vif`)**, ensuring seamless interaction. The driver maintains **transaction handles** and multiple 
//**mailboxes** to facilitate data flow. The **`gen2driv`** mailbox receives transactions from the
//generator, while **`driv2sb`** forwards them to the scoreboard for verification, and **`driv2cor`** sends them directly to the DUV.  

//The core functionality of the driver is encapsulated in the **`drive` task**, 
//which retrieves transactions from the generator using **`gen2driv.get(tx)`**, 
//then transmits them to both the scoreboard and the DUV via **`driv2sb.put(tx)`** and **`driv2cor.put(tx)`**, 
//respectively. After that, the driver utilizes the **virtual interface (`vif`)** to assign 
//transaction values to the corresponding signals in the DUV. To maintain synchronization, it
// waits for a clock edge before proceeding to the next transaction, ensuring accurate and reliable 
//communication between the verification components.=


class driver;

    Transaction tx; // Handle for transactions       
    mailbox #(Transaction) gen2driv; // Generator to Driver mailbox
    mailbox #(Transaction) driv2sb;  // Driver to Scoreboard mailbox
    mailbox #(Transaction) driv2cor; // Driver to DUV mailbox
    virtual ahb_apb_bfm_if.master vif; // Virtual interface to DUT

    function new(mailbox #(Transaction) gen2driv, mailbox #(Transaction) driv2sb, mailbox #(Transaction) driv2cor, virtual ahb_apb_bfm_if.master vif);
        this.gen2driv = gen2driv;
        this.driv2sb = driv2sb;
        this.driv2cor = driv2cor;
        this.vif = vif;
    endfunction

    task drive; 
        gen2driv.get(tx);   
        driv2sb.put(tx);   
        driv2cor.put(tx);

        // Display transaction details from the driver
        $display("[DRIVER] - Driving Transaction to DUT:");
        $display("[DRIVER] - Haddr: %h, Hwdata: %h", tx.Haddr, tx.Hwdata);
        case (tx.Hburst)
            3'b001: $display("[DRIVER] - Hburst: %b (INCR)", tx.Hburst);
            3'b010: $display("[DRIVER] - Hburst: %b (WRAP4)", tx.Hburst);
            3'b011: $display("[DRIVER] - Hburst: %b (INCR4)", tx.Hburst);
            3'b100: $display("[DRIVER] - Hburst: %b (WRAP8)", tx.Hburst);
            3'b101: $display("[DRIVER] - Hburst: %b (INCR8)", tx.Hburst);
            default: $display("[DRIVER] - Hburst: %b (UNKNOWN)", tx.Hburst);
        endcase

        case (tx.Htrans)
            2'b10: $display("[DRIVER] - Htrans: %b (NON-SEQ)", tx.Htrans);
            2'b11: $display("[DRIVER] - Htrans: %b (SEQ)", tx.Htrans);
            default: $display("[DRIVER] - Htrans: %b (UNKNOWN)", tx.Htrans);
        endcase

        // Drive the transaction to the DUT
        vif.drv_cb.Hwrite <= tx.Hwrite;     
        vif.drv_cb.Htrans <= tx.Htrans;
        vif.drv_cb.Hwdata <= tx.Hwdata;     
        vif.drv_cb.Haddr <= tx.Haddr;
        #10;  // Wait for 10 time units
    endtask

endclass

