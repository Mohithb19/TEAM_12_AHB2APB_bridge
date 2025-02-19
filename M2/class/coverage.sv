class coverage_collector;

  // Transaction object
  Transaction tx;

  // Mailbox for transactions coming from the driver
  mailbox #(Transaction) driv2cor;

  // Virtual interface
  virtual ahb_apb_bfm_if vif;

  // ------------------------------------------------
  // Main covergroup
  // ------------------------------------------------
  covergroup cov_cg;
    // Coverpoint: transaction type
    trans_type_cp: coverpoint tx.trans_type {
      bins read  = {Transaction::AHB_READ};
      bins write = {Transaction::AHB_WRITE};
    }

    // Coverpoint: Htrans
    Htrans_cp: coverpoint tx.Htrans {
      bins non_seq = {2'b00};
      bins idle    = {2'b01};
      bins seq     = {2'b10};
      bins busy    = {2'b11};
    }

    // Coverpoint: Hsize
    Hsize_cp: coverpoint tx.Hsize {
      bins size_byte     = {3'b000};
      bins size_halfword = {3'b001};
      bins size_word     = {3'b010};
    }

    // Coverpoint: Hburst
    Hburst_cp: coverpoint tx.Hburst {
      bins single = {3'b000};
      bins incr   = {3'b001};
      bins wrap4  = {3'b010};
      bins incr4  = {3'b011};
      // Add more bins if your protocol supports additional burst types
    }

    // Cross coverage
    trans_x_htrans: cross trans_type_cp, Htrans_cp {
      bins read_non_seq = binsof(trans_type_cp.read) && binsof(Htrans_cp.non_seq);
      bins read_idle    = binsof(trans_type_cp.read) && binsof(Htrans_cp.idle);
      bins write_non_seq = binsof(trans_type_cp.write) && binsof(Htrans_cp.non_seq);
      bins write_idle    = binsof(trans_type_cp.write) && binsof(Htrans_cp.idle);
    }
    trans_x_hsize:  cross trans_type_cp, Hsize_cp;
    trans_x_hburst: cross trans_type_cp, Hburst_cp;

  endgroup

  // ------------------------------------------------
  // Constructor
  // ------------------------------------------------
  function new(mailbox #(Transaction) driv2cor, virtual ahb_apb_bfm_if vif);
    this.driv2cor = driv2cor;
    cov_cg = new;
    this.vif = vif;
  endfunction

  // ------------------------------------------------
  // Sample coverage
  // ------------------------------------------------
  function void sample_coverage();
    cov_cg.sample();
  endfunction

  // ------------------------------------------------
  // Print coverage report (optional)
  // ------------------------------------------------
  function void print_coverage();
    $display("[COV_COLLECTOR] Functional Coverage = %0.2f%%",
             cov_cg.get_coverage());
  endfunction

  // ------------------------------------------------
  // Main execution task
  // ------------------------------------------------
  task execute();
    forever begin
      // Wait for next transaction
      driv2cor.get(tx);

      // Display for transcript
      $display("[COV_COLLECTOR] Received tx with trans_type=%0d, Htrans=%0b, Hsize=%0b, Hburst=%0b",
               tx.trans_type, tx.Htrans, tx.Hsize, tx.Hburst);

      // Sample the coverage
      sample_coverage();
    end
  endtask

endclass
