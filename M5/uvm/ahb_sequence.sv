// ---------------------
// Basic AHB Sequence
// ---------------------
class ahb_sequence extends uvm_sequence #(ahb_sequence_item);
  `uvm_object_utils(ahb_sequence)

  function new (string name = "ahb_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("AHB_SEQ","Starting random AHB transactions in ahb_sequence...", UVM_LOW)
    repeat(N_TX) begin
      req = ahb_sequence_item::type_id::create("req");
      start_item(req);
      `uvm_info("AHB_SEQ", $sformatf("Randomizing item at time %0t",$time), UVM_LOW)
      assert(req.randomize());
      finish_item(req);
    end
    `uvm_info("AHB_SEQ","Completed random AHB transactions in ahb_sequence.", UVM_LOW)
  endtask
endclass

// ---------------------
// AHB Random Sequence
//   HTRANS=00, 10, repeated 11 & 00
// ---------------------
class ahb_random_sequence extends uvm_sequence #(ahb_sequence_item);
  `uvm_object_utils(ahb_random_sequence)

  function new (string name = "ahb_random_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("AHB_RANDOM_SEQ","Generating HTRANS=00, then 10, then repeated 11 & 00 loops",UVM_LOW)

    // 1) HTRANS=00
    req = ahb_sequence_item::type_id::create("req");
    start_item(req);
    `uvm_info("AHB_RANDOM_SEQ","Forcing HTRANS=00",UVM_LOW)
    assert(req.randomize() with { HTRANS == 2'b00; });
    finish_item(req);

    // 2) HTRANS=10
    req = ahb_sequence_item::type_id::create("req");
    start_item(req);
    `uvm_info("AHB_RANDOM_SEQ","Forcing HTRANS=10",UVM_LOW)
    assert(req.randomize() with { HTRANS == 2'b10; });
    finish_item(req);

    // repeated 11 & 00
    repeat(N_TX) begin
      req = ahb_sequence_item::type_id::create("req");
      start_item(req);
      `uvm_info("AHB_RANDOM_SEQ","Forcing HTRANS=11 in random loop",UVM_LOW)
      assert(req.randomize() with { HTRANS == 2'b11; });
      finish_item(req);

      req = ahb_sequence_item::type_id::create("req");
      start_item(req);
      `uvm_info("AHB_RANDOM_SEQ","Forcing HTRANS=00 in random loop",UVM_LOW)
      assert(req.randomize() with { HTRANS == 2'b00; });
      finish_item(req);
    end
    `uvm_info("AHB_RANDOM_SEQ","Completed ahb_random_sequence.",UVM_LOW)
  endtask
endclass

// ---------------------
// AHB Single Write Sequence
//   multiple constraints
// ---------------------
class ahb_single_write_sequence extends uvm_sequence #(ahb_sequence_item);
  `uvm_object_utils(ahb_single_write_sequence)

  function new (string name = "ahb_single_write_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("AHB_SINGLE_WRITE","Starting single-write constraints",UVM_LOW)

    // 1) Write with HRESETn=0, HTRANS=00
    req = ahb_sequence_item::type_id::create("req");
    start_item(req);
    `uvm_info("AHB_SINGLE_WRITE","Forcing (HRESETn=0, HWRITE=1, HTRANS=00)",UVM_LOW)
    assert(req.randomize() with {
      HRESETn == 1'b0;
      HWRITE  == 1'b1;
      HTRANS  == 2'b00;
    });
    finish_item(req);

    // 2) Write with HRESETn=1, HWRITE=1, HSELAHB=1, HTRANS=10
    req = ahb_sequence_item::type_id::create("req");
    start_item(req);
    `uvm_info("AHB_SINGLE_WRITE","Forcing (HRESETn=1, HWRITE=1, HTRANS=10)",UVM_LOW)
    assert(req.randomize() with {
      HRESETn == 1'b1;
      HWRITE  == 1'b1;
      HSELAHB == 1'b1;
      HTRANS  == 2'b10;
    });
    finish_item(req);

    // 3) Another write with HRESETn=1, HSELAHB=1, HTRANS=00
    req = ahb_sequence_item::type_id::create("req");
    start_item(req);
    `uvm_info("AHB_SINGLE_WRITE","Forcing (HRESETn=1, HWRITE=1, HTRANS=00)",UVM_LOW)
    assert(req.randomize() with {
      HRESETn == 1'b1;
      HSELAHB == 1'b1;
      HWRITE  == 1'b1;
      HTRANS  == 2'b00;
    });
    finish_item(req);

    `uvm_info("AHB_SINGLE_WRITE","Completed single-write sequence.",UVM_LOW)
  endtask
endclass

// ---------------------
// AHB Single Read Sequence
// ---------------------
class ahb_single_read_sequence extends uvm_sequence #(ahb_sequence_item);
  `uvm_object_utils(ahb_single_read_sequence)

  function new (string name = "ahb_single_read_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("AHB_SINGLE_READ","Starting single-read constraints",UVM_LOW)

    // 1) read with HRESETn=0, HTRANS=00
    req = ahb_sequence_item::type_id::create("req");
    start_item(req);
    `uvm_info("AHB_SINGLE_READ","Forcing (HRESETn=0, HWRITE=0, HTRANS=00)",UVM_LOW)
    assert(req.randomize() with {
      HRESETn == 1'b0;
      HWRITE  == 1'b0;
      HTRANS  == 2'b00;
    });
    finish_item(req);

    // 2) Another read with HRESETn=1, HSELAHB=1, HTRANS=10
    req = ahb_sequence_item::type_id::create("req");
    start_item(req);
    `uvm_info("AHB_SINGLE_READ","Forcing (HRESETn=1, HWRITE=0, HSELAHB=1, HTRANS=10)",UVM_LOW)
    assert(req.randomize() with {
      HRESETn == 1'b1;
      HWRITE  == 1'b0;
      HSELAHB == 1'b1;
      HTRANS  == 2'b10;
    });
    finish_item(req);

    // 3) Another read with HRESETn=1, HSELAHB=1, HTRANS=00
    req = ahb_sequence_item::type_id::create("req");
    start_item(req);
    `uvm_info("AHB_SINGLE_READ","Forcing (HRESETn=1, HWRITE=0, HSELAHB=1, HTRANS=00)",UVM_LOW)
    assert(req.randomize() with {
      HRESETn == 1'b1;
      HWRITE  == 1'b0;
      HSELAHB == 1'b1;
      HTRANS  == 2'b00;
    });
    finish_item(req);

    `uvm_info("AHB_SINGLE_READ","Completed single-read sequence.",UVM_LOW)
  endtask
endclass

// ---------------------
// AHB Burst Write Sequence
// ---------------------
class ahb_burst_write_sequence extends uvm_sequence #(ahb_sequence_item);
  `uvm_object_utils(ahb_burst_write_sequence)

  function new (string name = "ahb_burst_write_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("AHB_BURST_WRITE","Generating specific burst write constraints",UVM_LOW)

    // 1) initial
    req = ahb_sequence_item::type_id::create("req");
    start_item(req);
    `uvm_info("AHB_BURST_WRITE","Forcing (HRESETn=0, HWRITE=1, HTRANS=00)",UVM_LOW)
    assert(req.randomize() with {
      HRESETn == 1'b0;
      HWRITE  == 1'b1;
      HTRANS  == 2'b00;
    });
    finish_item(req);

    // 2) second
    req = ahb_sequence_item::type_id::create("req");
    start_item(req);
    `uvm_info("AHB_BURST_WRITE","Forcing (HRESETn=1, HWRITE=1, HSELAHB=1, HTRANS=10)",UVM_LOW)
    assert(req.randomize() with {
      HRESETn == 1'b1;
      HWRITE  == 1'b1;
      HSELAHB == 1'b1;
      HTRANS  == 2'b10;
    });
    finish_item(req);

    // repeated block
    repeat(N_TX) begin
      req = ahb_sequence_item::type_id::create("req");
      start_item(req);
      `uvm_info("AHB_BURST_WRITE","Forcing (HRESETn=1, HWRITE=1, HSELAHB=1, HTRANS=11)",UVM_LOW)
      assert(req.randomize() with {
        HRESETn == 1'b1;
        HWRITE  == 1'b1;
        HSELAHB == 1'b1;
        HTRANS  == 2'b11;
      });
      finish_item(req);
    end

    // final
    req = ahb_sequence_item::type_id::create("req");
    start_item(req);
    `uvm_info("AHB_BURST_WRITE","Forcing final (HRESETn=1, HWRITE=1, HTRANS=00)",UVM_LOW)
    assert(req.randomize() with {
      HRESETn == 1'b1;
      HSELAHB == 1'b1;
      HWRITE  == 1'b1;
      HTRANS  == 2'b00;
    });
    finish_item(req);

    `uvm_info("AHB_BURST_WRITE","Completed burst_write_sequence",UVM_LOW)
  endtask
endclass

// ---------------------
// AHB Burst Read Sequence
// ---------------------
class ahb_burst_read_sequence extends uvm_sequence #(ahb_sequence_item);
  `uvm_object_utils(ahb_burst_read_sequence)

  function new (string name = "ahb_burst_read_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("AHB_BURST_READ","Generating specific burst read constraints",UVM_LOW)

    // 1) initial read
    req = ahb_sequence_item::type_id::create("req");
    start_item(req);
    `uvm_info("AHB_BURST_READ","Forcing (HRESETn=0, HWRITE=0, HTRANS=00)",UVM_LOW)
    assert(req.randomize() with {
      HRESETn == 1'b0;
      HWRITE  == 1'b0;
      HTRANS  == 2'b00;
    });
    finish_item(req);

    // repeated block
    repeat(N_TX) begin
      req = ahb_sequence_item::type_id::create("req");
      start_item(req);
      `uvm_info("AHB_BURST_READ","Forcing (HRESETn=1, HWRITE=0, HSELAHB=1, HTRANS=10)",UVM_LOW)
      assert(req.randomize() with {
        HRESETn == 1'b1;
        HWRITE  == 1'b0;
        HSELAHB == 1'b1;
        HTRANS  == 2'b10;
      });
      finish_item(req);
    end

    // final read
    req = ahb_sequence_item::type_id::create("req");
    start_item(req);
    `uvm_info("AHB_BURST_READ","Forcing final (HRESETn=1, HWRITE=0, HTRANS=00)",UVM_LOW)
    assert(req.randomize() with {
      HRESETn == 1'b1;
      HWRITE  == 1'b0;
      HSELAHB == 1'b1;
      HTRANS  == 2'b00;
    });
    finish_item(req);

    `uvm_info("AHB_BURST_READ","Completed burst_read_sequence",UVM_LOW)
  endtask
endclass
