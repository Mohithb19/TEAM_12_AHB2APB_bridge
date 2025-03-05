`ifndef N
    `define N 8 // Number of slaves (N here is the number of slaves)
`endif

interface ahb_intf (input logic clk);

    // Signal Declarations
    logic         HRESETn;
    logic [31:0]  HADDR;
    logic [31:0]  HWDATA;
    logic [31:0]  HRDATA;  
    logic [1:0]   HTRANS;
    logic         HWRITE;  
    logic         HSELAHB;
    logic         HREADY;
    logic [1:0]   HRESP;

    // MODPORTS 
    modport AHB_DRIVER  (clocking ahb_driver_cb,  input clk);
    modport AHB_MONITOR (clocking ahb_monitor_cb, input clk);

    // AHB Driver Clocking Block
    clocking ahb_driver_cb @(posedge clk);
        default input #1 output #1;
        output HRESETn;
        output HADDR;
        output HTRANS;
        output HWRITE;
        output HWDATA;
        output HSELAHB;
        input  HREADY;
    endclocking

    // AHB Monitor Clocking Block
    clocking ahb_monitor_cb @(posedge clk);
        default input #1 output #1;
        input HRESETn;
        input HADDR;
        input HTRANS;
        input HWRITE;
        input HWDATA;
        input HSELAHB;
        input HRDATA;
        input HREADY;
        input HRESP;
    endclocking

endinterface

interface apb_intf (input logic clk);

    // Signal Declarations
    bit [31:0]     PRDATA [`N-1:0];
    bit [31:0]     PWDATA;
    bit [31:0]     PADDR; 
    bit [`N-1:0]   PSLVERR;
    bit [`N-1:0]   PREADY;
    bit [`N-1:0]   PSELx;
    bit            PENABLE;
    bit            PWRITE;

    // MODPORTS 
    modport APB_DRIVER  (clocking apb_driver_cb, input clk);
    modport APB_MONITOR (clocking apb_monitor_cb, input clk);

    // APB DRIVER Clocking Block
    clocking apb_driver_cb @(posedge clk);
        default input #1 output #1;
        output  PRDATA;
        output  PSLVERR;
        output  PREADY;
    endclocking

    // APB MONITOR Clocking Block
    clocking apb_monitor_cb @(posedge clk);
        default input #1 output #1;
        input PRDATA;
        input PSLVERR;
        input PREADY;
        input PWDATA;
        input PENABLE;
        input PSELx;
        input PADDR;
        input PWRITE;
    endclocking

endinterface
