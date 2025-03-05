// Basic APB Sequence
class apb_sequence extends uvm_sequence #(apb_sequence_item);
  `uvm_object_utils(apb_sequence)

  function new (string name = "apb_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("APB_SEQ","Starting random APB transactions in apb_sequence...",UVM_LOW)
    repeat(N_TX) begin
      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      `uvm_info("APB_SEQ", $sformatf("Randomizing PSLVERR at time %0t",$time), UVM_LOW)
      assert(req.randomize());
      finish_item(req);
    end
    `uvm_info("APB_SEQ","Completed random APB transactions in apb_sequence.",UVM_LOW)
  endtask
endclass

// APB Random Sequence 
class apb_random_sequence extends uvm_sequence #(apb_sequence_item);
  `uvm_object_utils(apb_random_sequence)

  function new (string name = "apb_random_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("APB_RAND_SEQ","Generating PSLVERR=0, then PSLVERR=1, then PSLVERR=0 again",UVM_LOW)

    // PSLVERR=0 for (N_TX - 8)
    repeat(N_TX - 8) begin
      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      `uvm_info("APB_RAND_SEQ","Forcing PSLVERR=0",UVM_LOW)
      assert(req.randomize() with { PSLVERR == 8'b0; });
      finish_item(req);
    end

    // PSLVERR=1 for 10
    repeat(10) begin
      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      `uvm_info("APB_RAND_SEQ","Forcing PSLVERR=1",UVM_LOW)
      assert(req.randomize() with { PSLVERR == 8'b1; });
      finish_item(req);
    end

    // final PSLVERR=0
    req = apb_sequence_item::type_id::create("req");
    start_item(req);
    `uvm_info("APB_RAND_SEQ","Forcing PSLVERR=0 one last time",UVM_LOW)
    assert(req.randomize() with { PSLVERR == 8'b0; });
    finish_item(req);

    `uvm_info("APB_RAND_SEQ","Completed apb_random_sequence",UVM_LOW)
  endtask
endclass

// APB Single Write
class apb_single_write_sequence extends uvm_sequence #(apb_sequence_item);
  `uvm_object_utils(apb_single_write_sequence)

  function new (string name = "apb_single_write_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("APB_SINGLE_WRITE","Generating write sequences with PSLVERR=0 for 3 times",UVM_LOW)
    repeat(3) begin
      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      `uvm_info("APB_SINGLE_WRITE","Forcing PSLVERR=0 in single-write iteration",UVM_LOW)
      assert(req.randomize() with { PSLVERR == 8'b0; });
      finish_item(req);
    end
    `uvm_info("APB_SINGLE_WRITE","Completed single_write_sequence",UVM_LOW)
  endtask
endclass

// APB Single Read
class apb_single_read_sequence extends uvm_sequence #(apb_sequence_item);
  `uvm_object_utils(apb_single_read_sequence)

  function new (string name = "apb_single_read_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("APB_SINGLE_READ","Generating read sequences with PSLVERR=0 for 3 times",UVM_LOW)
    repeat(3) begin
      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      `uvm_info("APB_SINGLE_READ","Forcing PSLVERR=0 in single-read iteration",UVM_LOW)
      assert(req.randomize() with { PSLVERR == 8'b0; });
      finish_item(req);
    end
    `uvm_info("APB_SINGLE_READ","Completed single_read_sequence",UVM_LOW)
  endtask
endclass

// APB Burst Write
class apb_burst_write_sequence extends uvm_sequence #(apb_sequence_item);
  `uvm_object_utils(apb_burst_write_sequence)

  function new (string name = "apb_burst_write_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("APB_BURST_WRITE","Generating burst write with PSLVERR=0 for N_TX+3 times",UVM_LOW)
    repeat(N_TX + 3) begin
      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      `uvm_info("APB_BURST_WRITE","Forcing PSLVERR=0 in burst-write iteration",UVM_LOW)
      assert(req.randomize() with { PSLVERR == 8'b0; });
      finish_item(req);
    end
    `uvm_info("APB_BURST_WRITE","Completed apb_burst_write_sequence",UVM_LOW)
  endtask
endclass

// APB Burst Read
class apb_burst_read_sequence extends uvm_sequence #(apb_sequence_item);
  `uvm_object_utils(apb_burst_read_sequence)

  function new (string name = "apb_burst_read_sequence");
    super.new(name);
  endfunction

  task body();
    `uvm_info("APB_BURST_READ","Generating burst read with PSLVERR=0 for N_TX+2 times",UVM_LOW)
    repeat(N_TX + 2) begin
      req = apb_sequence_item::type_id::create("req");
      start_item(req);
      `uvm_info("APB_BURST_READ","Forcing PSLVERR=0 in burst-read iteration",UVM_LOW)
      assert(req.randomize() with { PSLVERR == 8'b0; });
      finish_item(req);
    end
    `uvm_info("APB_BURST_READ","Completed apb_burst_read_sequence",UVM_LOW)
  endtask
endclass
