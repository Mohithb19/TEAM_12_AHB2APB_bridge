// -----------------------------------------------------------------------------
// Project: AHB APB Bridge Verification
// Module:  Interface
// File:    interface.sv
// -----------------------------------------------------------------------------
//Team members:
//   Daniel Jacobsen
//   BALAJI Ginkal Harisha
//   Mohith Kumar Bennahatti Chikkegowda
//   Akshaya Kudumalakunte Ravi Kumar
// Created: 16/Feb/2025 
//
// Description: 
//The SystemVerilog interface encapsulates the signals of the AHB-APB Bridge
//protocol, providing a unified handle to manage them efficiently. 
//It facilitates communication between various verification components 
//such as the driver, monitor, and DUT.

//This module defines two clocking blocks—one for the driver 
//and one for the monitor. These clocking blocks enable precise 
//control over signal driving and sampling, which is essential 
//for accurate design and verification.

//The drv_cb clocking block is designated for the driver, 
//ensuring signals are correctly driven to the DUT. Conversely, 
//the mon_cb clocking block is used by the monitor to sample signals 
//from the DUT. This synchronized operation ensures both components function in alignment with the clock.

//Additionally, the interface includes modports: master for the driver and slave for the monitor. 
//The master (driver) is responsible for driving signals, while the slave (monitor) samples them, 
//ensuring structured and efficient signal interaction.


interface ahb_apb_bfm_if(input wire clk, resetn);

  // AHB signals
  logic Hwrite;     // AHB write signal
  logic Hreadyin;   // AHB ready input signal
  logic [1:0] Htrans; // AHB transfer type encoding
  logic [31:0] Hwdata; // AHB write data
  logic [31:0] Haddr;  // AHB address
  logic [31:0] Hrdata; // AHB read data
  logic [1:0] Hresp;   // AHB response
  logic Hreadyout;     // AHB ready output signal

  // APB signals
  wire Penable;       // APB enable signal
  wire Pwrite;        // APB write signal
  wire [2:0] Pselx;   // APB select signals
  wire [31:0] Pwdata; // APB write data
  wire [31:0] Paddr;  // APB address
  wire [31:0] Prdata; // APB read data

  // Clocking block for driver
  // This block defines the timing of the signals when they are driven by the driver
  clocking drv_cb @(posedge clk);
    default input #1ns output #1ns; // Default skew for input and output signals
    output Hwrite, Hreadyin, Htrans, Hwdata, Haddr; // AHB signals driven by the driver
    output Penable, Pwrite, Pselx, Pwdata, Paddr;   // APB signals driven by the driver
  endclocking

  // Clocking block for monitor
  // This block defines the timing of the signals when they are monitored
  clocking mon_cb @(posedge clk);
    default input #1ns output #1ns; // Default skew for input and output signals
    input Hwrite, Hreadyin, Htrans, Hwdata, Haddr, Hrdata, Hresp, Hreadyout; // AHB signals monitored
    input Penable, Pwrite, Pselx, Pwdata, Paddr, Prdata; // APB signals monitored
  endclocking

  // Modports
  // These define the interface for the driver and monitor, respectively
  modport master(clocking drv_cb, input clk, resetn); // driver
  modport slave(clocking mon_cb, input clk, resetn); // monitor

endinterface

