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
// The Scoreboard class plays a crucial role in verification process as it 
// validates the correctness of the design. It contains a memory model that
// mimics the behaviour of the design under test (DUT).
//
// The Scoreboard receives transactions from both the driver and the monitor, 
// allowing it to compare the expected and actual responses. This class has 
// methods to handle both data write and read operations. For a write operation, 
// it verifies that the data has been correctly written into the memory model. 
// For a read operation, it checks if the data read from the DUT matches with 
// the data stored in the memory model. Any discrepancy in data would result 
// in an assertion error, flagging a failure in the verification process.
// -----------------------------------------------------------------------------

class ahb_apb_scoreboard;

    Transaction tx1, tx2;
    mailbox #(Transaction) drv2sb;
    mailbox #(Transaction) mail2sb;
    logic [19:0] temp_addr; // We will only track the least significant 20 bits

    bit [31:0] mem_tb [2**20]; // memory of 2^20 locations each of 32 bits

    function new(mailbox #(Transaction) drv2sb, mailbox #(Transaction) mail2sb);
        this.drv2sb = drv2sb;
        this.mail2sb = mail2sb;
    endfunction

  task data_write();
    $display("[SCOREBOARD] - Checking Write Transaction:");

    // Receive data from driver and monitor
    drv2sb.get(tx1);
    mail2sb.get(tx2);

    temp_addr = tx1.Haddr[19:0];

    // Write data to the memory model
    mem_tb[temp_addr] = tx1.Hwdata;

    $display("[SCOREBOARD] - Input Address: %h", temp_addr);
    $display("[SCOREBOARD] - Input Write Data: %h", tx1.Hwdata);
    $display("[SCOREBOARD] - Data Stored: %h", mem_tb[temp_addr]);

    // Assert that the data was written correctly
    assert (tx1.Hwdata == mem_tb[temp_addr])
        else $error("[SCOREBOARD] - Data failed to write");

    $display("[SCOREBOARD] - WRITE = DATA MATCHED");
    $display("");
    #10;
endtask

task data_read();
    $display("[SCOREBOARD] - Checking Read Transaction:");

    drv2sb.get(tx1);
    mail2sb.get(tx2);

    temp_addr = tx1.Haddr[19:0];

    $display("[SCOREBOARD] - Temp address = %h", temp_addr);
    $display("[SCOREBOARD] - Read data from DUT: %h", tx2.Prdata); // data from monitor/DUT
    $display("[SCOREBOARD] - Data from TB memory: %h", mem_tb[temp_addr]);

    // Assert that the data read matches the data in the memory model
    assert (tx2.Prdata == mem_tb[temp_addr])
        else $error("[SCOREBOARD] - Data reading failed");

    $display("[SCOREBOARD] - READ = DATA MATCHED");
    $display("");
    #10;
endtask

endclass