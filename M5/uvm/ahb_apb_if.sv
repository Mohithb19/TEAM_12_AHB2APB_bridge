interface ahb_apb_if(input logic clk, resetn);
    logic Hwrite;
    logic Hreadyin;
    logic [1:0] Htrans;
    logic [31:0] Hwdata;
    logic [31:0] Haddr;
    logic [31:0] Hrdata;
    logic [1:0] Hresp;
    logic Hreadyout;

    logic Penable;
    logic Pwrite;
    logic [2:0] Pselx;
    logic [31:0] Pwdata;
    logic [31:0] Paddr;
    logic [31:0] Prdata;

    clocking drv_cb @(posedge clk);
        output Hwrite, Hreadyin, Htrans, Hwdata, Haddr;
        output Penable, Pwrite, Pselx, Pwdata, Paddr;
    endclocking

    clocking mon_cb @(posedge clk);
        input Hwrite, Hreadyin, Htrans, Hwdata, Haddr, Hrdata, Hresp, Hreadyout;
        input Penable, Pwrite, Pselx, Pwdata, Paddr, Prdata;
    endclocking

    modport master(clocking drv_cb, input clk, resetn);
    modport slave(clocking mon_cb, input clk, resetn);
endinterface