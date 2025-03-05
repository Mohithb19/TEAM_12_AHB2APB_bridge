/* 
 * AHB to APB Bridge Project
 * ECE593 - Fundamentals of Pre-Silicon Validation
 * Team Members:
 *   Akshaya Kudumalakunte Ravi Kumar
 *   Mohith Kumar Bennahatti Chikkegowda
 *   BALAJI Ginkal Harisha
 *   Daniel Jacobsen
 *
 * Description:
 * This is the top-level module for the AHB to APB Bridge.
 * It integrates the AHB Slave Interface, APB FSM Controller,
 * and APB Interface modules. This module serves as the
 * primary DUT (Device Under Test) in the verification process.
 */


/* USED IN EDA PLAYGROUND TESTING
`include "AHB_Master.sv"
`include "AHB_Slave_Interface.sv"
`include "APB_Controller.sv"
`include "APB_Interface.sv"
*/

module Bridge_Top (
    input logic Hclk,
    input logic Hresetn,
    input logic Hwrite,
    input logic Hreadyin,
    input logic [31:0] Hwdata,
    input logic [31:0] Haddr,
    input logic [31:0] Prdata,
    input logic [1:0] Htrans,
    output logic Penable,
    output logic Pwrite,
    output logic Hreadyout,
    output logic [1:0] Hresp,
    output logic [2:0] Pselx,
    output logic [31:0] Paddr,
    output logic [31:0] Pwdata,
    output logic [31:0] Hrdata
);

// Intermediate signals
logic valid;
logic [31:0] Haddr1, Haddr2, Hwdata1, Hwdata2;
logic Hwritereg;
logic [2:0] tempselx;

// Instantiate Modules
AHB_slave_interface AHBSlave (
    .Hclk(Hclk),
    .Hresetn(Hresetn),
    .Hwrite(Hwrite),
    .Hreadyin(Hreadyin),
    .Htrans(Htrans),
    .Haddr(Haddr),
    .Hwdata(Hwdata),
    .Prdata(Prdata),
    .valid(valid),
    .Haddr1(Haddr1),
    .Haddr2(Haddr2),
    .Hwdata1(Hwdata1),
    .Hwdata2(Hwdata2),
    .Hrdata(Hrdata),
    .Hwritereg(Hwritereg),
    .tempselx(tempselx),
    .Hresp(Hresp)
);

APB_FSM_Controller APBControl (
    .Hclk(Hclk),
    .Hresetn(Hresetn),
    .valid(valid),
    .Haddr1(Haddr1),
    .Haddr2(Haddr2),
    .Hwdata1(Hwdata1),
    .Hwdata2(Hwdata2),
    .Prdata(Prdata),
    .Hwrite(Hwrite),
    .Haddr(Haddr),
    .Hwdata(Hwdata),
    .Hwritereg(Hwritereg),
    .tempselx(tempselx),
    .Pwrite(Pwrite),
    .Penable(Penable),
    .Pselx(Pselx),
    .Paddr(Paddr),
    .Pwdata(Pwdata),
    .Hreadyout(Hreadyout)
);

endmodule
