module ahb_apb_top;
    logic clk, reset;

    always #5 clk = ~clk;

    ahb_apb_if bfm(clk, reset);

    Bridge_Top dut(
        .Hclk(bfm.clk),
        .Hresetn(bfm.resetn),
        .Hwrite(bfm.Hwrite),
        .Hreadyin(bfm.Hreadyin),
        .Htrans(bfm.Htrans),
        .Hwdata(bfm.Hwdata),
        .Haddr(bfm.Haddr),
        .Hrdata(bfm.Hrdata),
        .Hresp(bfm.Hresp),
        .Hreadyout(bfm.Hreadyout),
        .Prdata(bfm.Prdata),
        .Pwdata(bfm.Pwdata),
        .Paddr(bfm.Paddr),
        .Pselx(bfm.Pselx),
        .Pwrite(bfm.Pwrite),
        .Penable(bfm.Penable)
    );

    initial begin
        uvm_config_db#(virtual ahb_apb_if)::set(null, "*", "vif", bfm);
        run_test("ahb_apb_test");
    end

    initial begin
        clk = 1;
        reset = 0;
        #10 reset = 1;
        #100000 $stop;
    end
endmodule