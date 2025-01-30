`timescale 1ns/1ps

module top;

    // Testbench signals
    logic        Hclk;           // AHB clock
    logic        Hresetn;        // AHB active-low reset
    logic        Hwrite;         // AHB write signal
    logic        Hreadyin;       // AHB ready signal from master
    logic [31:0] Hwdata;         // AHB write data
    logic [31:0] Haddr;          // AHB address
    logic [31:0] Prdata;         // APB read data (from peripheral)
    logic [1:0]  Htrans;         // AHB transaction type
    logic        Penable;        // APB enable signal
    logic        Pwrite;         // APB write signal
    logic        Hreadyout;      // AHB ready signal to master
    logic [1:0]  Hresp;          // AHB response
    logic [2:0]  Pselx;          // APB peripheral select
    logic [31:0] Paddr;          // APB address
    logic [31:0] Pwdata;         // APB write data
    logic [31:0] Hrdata;         // AHB read data

    // Instantiate the Bridge_Top module
    Bridge_Top uut (
        .Hclk(Hclk),
        .Hresetn(Hresetn),
        .Hwrite(Hwrite),
        .Hreadyin(Hreadyin),
        .Hwdata(Hwdata),
        .Haddr(Haddr),
        .Prdata(Prdata),
        .Htrans(Htrans),
        .Penable(Penable),
        .Pwrite(Pwrite),
        .Hreadyout(Hreadyout),
        .Hresp(Hresp),
        .Pselx(Pselx),
        .Paddr(Paddr),
        .Pwdata(Pwdata),
        .Hrdata(Hrdata)
    );

    // Clock generation
    initial begin
        Hclk = 0;
        forever #5 Hclk = ~Hclk; // 10ns clock period
    end

    // Testbench stimulus
    initial begin
        // Initialize signals
        Hresetn = 0;
        Hwrite = 0;
        Hreadyin = 1;
        Hwdata = 32'h0;
        Haddr = 32'h0;
        Prdata = 32'h0;
        Htrans = 2'b00;

        // Apply reset
        #20;
        Hresetn = 1;

        // Test 1: Single Write Transaction
        #10;
        Hwrite = 1;              // Write transaction
        Htrans = 2'b10;          // NONSEQ transaction
        Haddr = 32'h8000_0001;   // Address
        Hwdata = 32'hA5A5_A5A5;  // Write data

        // Wait for Hreadyout
        wait(Hreadyout == 1);
        #10;
        Htrans = 2'b00;          // IDLE transaction
        Hwrite = 0;

        // Test 2: Single Read Transaction
        #10;
        Hwrite = 0;              // Read transaction
        Htrans = 2'b10;          // NONSEQ transaction
        Haddr = 32'h8000_00A2;   // Address

        // Simulate APB read data
        #20;
        Prdata = 32'h1234_5678;  // Simulated read data from APB peripheral

        // Wait for Hreadyout
        wait(Hreadyout == 1);
        #10;
        Htrans = 2'b00;          // IDLE transaction

        // Test 3: Verify Read Data
        if (Hrdata == 32'h1234_5678)
            $display("Read Test Passed: Hrdata = %h", Hrdata);
        else
            $display("Read Test Failed: Hrdata = %h", Hrdata);

        // End simulation
        #100;
        $finish;
    end

    // Monitor signals
    initial begin
        $monitor("Time: %0t | Hwrite: %b | Htrans: %b | Haddr: %h | Hwdata: %h | Hrdata: %h | Hreadyout: %b | Pwrite: %b | Penable: %b | Paddr: %h | Pwdata: %h | Prdata: %h",
                 $time, Hwrite, Htrans, Haddr, Hwdata, Hrdata, Hreadyout, Pwrite, Penable, Paddr, Pwdata, Prdata);
    end

endmodule