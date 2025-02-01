/* 
 * AHB to APB Bridge Project - Testbench
 * ECE593 - Fundamentals of Pre-Silicon Validation
 * Team Members:
 *   Akshaya Kudumalakunte Ravi Kumar
 *   Mohith Kumar Bennahatti Chikkegowda
 *   BALAJI Ginkal Harisha
 *   Daniel Jacobsen
 *
 * Description:
 * This testbench verifies the functionality of the AHB to APB Bridge.
 * It includes tasks for generating single read and write transactions,
 * as well as checking the correctness of data flow between AHB and APB.
 *
 * Test Scenarios:
 * 1. Single Write: Verify that data is written to the APB peripheral correctly.
 * 2. Single Read: Verify that data is read back correctly from the APB peripheral.
 * The testbench uses self-checking assertions to validate functionality.
 */



// `timescale 1ns/1ps

module bridge_tb;

  // Clock and reset
  logic Hclk;
  logic Hresetn;

  // AHB signals
  logic Hwrite;
  logic Hreadyin;
  logic [31:0] Hwdata;
  logic [31:0] Haddr;
  logic [1:0]  Htrans;
  logic [1:0]  Hresp;
  logic [31:0] Hrdata;
  logic Hreadyout;

  // APB signals
  logic Penable;
  logic Pwrite;
  logic [2:0] Pselx;
  logic [31:0] Paddr;
  logic [31:0] Pwdata;
  logic [31:0] Prdata;

  // DUT instantiation
  Bridge_Top bridge_top (
      .Hclk       (Hclk),
      .Hresetn    (Hresetn),
      .Hwrite     (Hwrite),
      .Hreadyin   (Hreadyin),
      .Hwdata     (Hwdata),
      .Haddr      (Haddr),
      .Htrans     (Htrans),
      .Prdata     (Prdata),
      .Hreadyout  (Hreadyout),
      .Hresp      (Hresp),
      .Hrdata     (Hrdata),
      .Penable    (Penable),
      .Pwrite     (Pwrite),
      .Pselx      (Pselx),
      .Paddr      (Paddr),
      .Pwdata     (Pwdata)
  );

  // Variables for the testbench
  integer errors = 0;

  // Clock generation (10 ns period)
  initial begin
    Hclk = 0;
    forever #5 Hclk = ~Hclk;
  end

  // Reset generation
  initial begin
    Hresetn = 0;
    #15;      // Hold reset low for 15 ns
    Hresetn = 1;
  end

  /* USED IN EDA PLAYGROUND TESTING
  // Waveform dump
  initial begin
    $dumpfile("bridge_tb.vcd");
    $dumpvars(0, bridge_tb);
  end
*/

  // Tasks to model AHB transactions


  // Single WRITE transaction
  task automatic do_single_write(
    input [31:0] addr,
    input [31:0] data
  );
    begin
      // 1) Drive address & data, set Htrans=NONSEQ, set Hwrite=1
      @(posedge Hclk);
      Haddr    <= addr;
      Hwdata   <= data;
      Hwrite   <= 1;
      Htrans   <= 2'b10; // NONSEQ
      Hreadyin <= 1;

      // 2) Wait for the bridge to respond (if the bridge deasserts Hreadyout, wait until it is re-asserted)
      //    Some designs keep Hreadyout=1 all the time; if so, you can just wait 1 or 2 cycles.
      @(posedge Hclk);
      while (!Hreadyout) @(posedge Hclk);

      // 3) Return to idle
      @(posedge Hclk);
      Htrans <= 2'b00;
      Hwrite <= 0;
    end
  endtask

  // Check the APB signals for that single WRITE
  // (Call this after do_single_write finishes, plus maybe 1 cycle.)
  task automatic check_single_write(
    input [31:0] expectedAddr,
    input [31:0] expectedData
  );
    begin
      // Wait a cycle so the pipeline can update APB signals
      @(posedge Hclk);
      // Compare with Paddr, Pwdata, Pwrite
      if (Pwrite !== 1'b1 || Paddr !== expectedAddr || Pwdata !== expectedData) begin
        $display($time, " *** ERROR: Write mismatch. ");
        $display("    Pwrite=%b, Paddr=0x%08h, Pwdata=0x%08h",
                 Pwrite, Paddr, Pwdata);
        errors++;
      end else begin
        $display($time, " Write matched: Pwrite=%b, Paddr=0x%08h, Pwdata=0x%08h",
                 Pwrite, Paddr, Pwdata);
      end
    end
  endtask

  // Single READ transaction
  task automatic do_single_read(
    input [31:0] addr
  );
    begin
      @(posedge Hclk);
      Haddr    <= addr;
      Hwrite   <= 0;
      Htrans   <= 2'b10;  // NONSEQ
      Hreadyin <= 1;

      // Wait for Hreadyout
      @(posedge Hclk);
      while (!Hreadyout) @(posedge Hclk);

      // Return to IDLE
      @(posedge Hclk);
      Htrans <= 2'b00;
    end
  endtask

  // Check the read data returned on Hrdata
  task automatic check_single_read(
    input [31:0] expectedData
  );
    begin
      // Wait a cycle or two for pipeline
      @(posedge Hclk);

      if (Hrdata !== expectedData) begin
        $display($time, " *** ERROR: Read mismatch. Hrdata=0x%08h (expected 0x%08h)",
                 Hrdata, expectedData);
        errors++;
      end else begin
        $display($time, " Read matched: Hrdata=0x%08h", Hrdata);
      end
    end
  endtask


  // Main Test Sequence

  initial begin
    // Initialize signals
    Hwrite   = 0;
    Hreadyin = 1;
    Haddr    = 32'b0;
    Hwdata   = 32'b0;
    Htrans   = 2'b00;
    Prdata   = 32'b0;

    // Wait until reset is de-asserted
    @(posedge Hclk);
    wait (Hresetn === 1);

    @(posedge Hclk);
    $display("\nStarting Bridge Tests...\n");

    // TEST 1: Single Write
    do_single_write(32'h8000_0001, 32'hA5A5A5A5);
    check_single_write(32'h8000_0001, 32'hA5A5A5A5);

    // TEST 2: Single Read
    // We'll set Prdata to be returned by the APB side:
    Prdata = 32'h5A5A5A5A;
    do_single_read(32'h8000_00A2);
    check_single_read(32'h5A5A5A5A);

    // End of tests
    if (errors == 0)
      $display("\nTestbench PASSED with no errors!\n");
    else
      $display("\nTestbench FAILED with %0d errors!\n", errors);

    $finish;
  end

endmodule
