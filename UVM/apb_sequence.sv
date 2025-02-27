// ---------------------
// Basic APB Sequence
// ---------------------
class apb_sequence extends uvm_sequence #(apb_sequence_item);
  `uvm_object_utils(apb_sequence)

  function new (string name = "apb_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("APB_SEQ","Starting apb_sequence with random PSLVERR",UVM_LOW)
    repeat(N_TX) begin
      req = apb_sequence_item::type_id::create("req");
      start_item(req);

      // Minor new log
      `uvm_info("APB_SEQ", $sformatf("Randomizing PSLVERR at time %0t",$time),UVM_LOW)
      assert(req.randomize());

      finish_item(req);
    end
    `uvm_info("APB_SEQ","Completed apb_sequence",UVM_LOW)
  endtask
endclass

// ---------------------
// APB Random Sequence
// PSLVERR=0 mostly, then PSLVERR=1
// ---------------------
class apb_random_sequence extends uvm_sequence #(apb_sequence_item);
  `uvm_object_utils(apb_random_sequence)

  function new (string name = "apb_random_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("APB_RANDOM_SEQ","Generating PSLVERR=0, then PSLVERR=1, then 0 again",UVM_LOW)

    // PSLVERR=0 for (N_TX - 8) times
    repeat(N_TX - 8) begin
      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      // randomize, forcing PSLVERR=0
      assert(req.randomize() with { PSLVERR == 8'b0; });
      finish_item(req);
    end

    // PSLVERR=1 for 10 times
    repeat(10) begin
      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { PSLVERR == 8'b1; });
      finish_item(req);
    end

    // Final sequence with PSLVERR=0
    req = apb_sequence_item::type_id::create("req");
    start_item(req);
    assert(req.randomize() with { PSLVERR == 8'b0; });
    finish_item(req);
  endtask
endclass

// ---------------------
// APB Single Write Sequence
// ---------------------
class apb_single_write_sequence extends uvm_sequence #(apb_sequence_item);
  `uvm_object_utils(apb_single_write_sequence)

  function new (string name = "apb_single_write_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("APB_SINGLE_WRITE","Generating 3 PSLVERR=0 single-write items",UVM_LOW)
    repeat(3) begin
      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { PSLVERR == 8'b0; });
      finish_item(req);
    end
  endtask
endclass

// ---------------------
// APB Single Read Sequence
// ---------------------
class apb_single_read_sequence extends uvm_sequence #(apb_sequence_item);
  `uvm_object_utils(apb_single_read_sequence)

  function new (string name = "apb_single_read_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("APB_SINGLE_READ","Generating 3 PSLVERR=0 single-read items",UVM_LOW)
    repeat(3) begin
      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { PSLVERR == 8'b0; });
      finish_item(req);
    end
  endtask
endclass

// ---------------------
// APB Burst Write Sequence
// ---------------------
class apb_burst_write_sequence extends uvm_sequence #(apb_sequence_item);
  `uvm_object_utils(apb_burst_write_sequence)

  function new (string name = "apb_burst_write_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("APB_BURST_WRITE","Generating PSLVERR=0 for N_TX+3 burst writes",UVM_LOW)
    repeat(N_TX + 3) begin
      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { PSLVERR == 8'b0; });
      finish_item(req);
    end
  endtask
endclass

// ---------------------
// APB Burst Read Sequence
// ---------------------
class apb_burst_read_sequence extends uvm_sequence #(apb_sequence_item);
  `uvm_object_utils(apb_burst_read_sequence)

  function new (string name = "apb_burst_read_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("APB_BURST_READ","Generating PSLVERR=0 for N_TX+2 burst reads",UVM_LOW)
    repeat(N_TX + 2) begin
      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      assert(req.randomize() with { PSLVERR == 8'b0; });
      finish_item(req);
    end
  endtask
endclass
