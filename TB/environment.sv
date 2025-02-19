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
/* The environment class plays a crucial role in the SystemVerilog testbench, 
serving as the core of the verification process. It integrates key verification components 
such as the generator, driver, monitor, and scoreboard, ensuring seamless interaction between them. 
In this setup, the environment establishes mailboxes for communication, initializes all components, 
and oversees the execution of specific test cases. These test cases simulate various transactions 
that the AHB-APB bridge must handle, enabling thorough testing and verification of the design under test (DUT).
//
// -----------------------------------------------------------------------------
*/

class environment;

    mailbox #(Transaction) gen2driv;  
    mailbox #(Transaction) driv2sb;  
    mailbox #(Transaction) mail2sb; 
    mailbox #(Transaction) driv2cor;

    generator gen;        
    driver driv;          
    ahb_apb_monitor moni;         
    ahb_apb_scoreboard sb;        
    virtual ahb_apb_bfm_if vif;

    function new(virtual ahb_apb_bfm_if vif);
        this.vif = vif;
    endfunction

    function create();
        gen2driv = new(1);
        driv2sb = new(1);
        mail2sb = new(1);
        driv2cor = new(1);
        gen = new(gen2driv);
        driv = new(gen2driv, driv2sb, driv2cor, vif);
        moni = new(mail2sb, vif);
        sb = new(driv2sb, mail2sb);
    endfunction

    task run_test();
        fork
            gen.generate_transaction();
            driv.drive();
            moni.watch();
            //sb.data_write();
			
			if (gen.tx.Hwrite) begin
                sb.data_write();
            end else begin
                sb.data_read();
            end
			
        join_none
    endtask

endclass