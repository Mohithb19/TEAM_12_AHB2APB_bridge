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
 * This module implements the AHB Slave Interface,
 * responsible for handling AHB transactions and
 * forwarding them to the APB FSM Controller.
 */



module AHB_slave_interface (
    input logic Hclk,
    input logic Hresetn,
    input logic Hwrite,
    input logic Hreadyin,
    input logic [1:0] Htrans,
    input logic [31:0] Haddr,
    input logic [31:0] Hwdata,
    input logic [31:0] Prdata,
    output logic valid,
    output logic [31:0] Haddr1,
    output logic [31:0] Haddr2,
    output logic [31:0] Hwdata1,
    output logic [31:0] Hwdata2,
    output logic [31:0] Hrdata,
    output logic Hwritereg,
    output logic [2:0] tempselx,
    output logic [1:0] Hresp
);

// Implementing Pipeline Logic for Address, Data, and Control Signals
always_ff @(posedge Hclk or negedge Hresetn) begin
    if (!Hresetn) begin
        Haddr1 <= 32'b0;
        Haddr2 <= 32'b0;
    end else begin
        Haddr1 <= Haddr;
        Haddr2 <= Haddr1;
    end
end

always_ff @(posedge Hclk or negedge Hresetn) begin
    if (!Hresetn) begin
        Hwdata1 <= 32'b0;
        Hwdata2 <= 32'b0;
    end else begin
        Hwdata1 <= Hwdata;
        Hwdata2 <= Hwdata1;
    end
end

always_ff @(posedge Hclk or negedge Hresetn) begin
    if (!Hresetn)
        Hwritereg <= 1'b0;
    else
        Hwritereg <= Hwrite;
end

/// Implementing Valid Logic Generation
always_comb begin
    valid = 1'b0;
    if (Hresetn && Hreadyin && 
        (Haddr >= 32'h8000_0000 && Haddr < 32'h8C00_0000) && 
        (Htrans == 2'b10 || Htrans == 2'b11)) 
    begin
        valid = 1'b1;
    end
end

/// Implementing Tempselx Logic
always_comb begin
    tempselx = 3'b000;
    if (Hresetn && Haddr >= 32'h8000_0000 && Haddr < 32'h8400_0000)
        tempselx = 3'b001;
    else if (Hresetn && Haddr >= 32'h8400_0000 && Haddr < 32'h8800_0000)
        tempselx = 3'b010;
    else if (Hresetn && Haddr >= 32'h8800_0000 && Haddr < 32'h8C00_0000)
        tempselx = 3'b100;
end

assign Hrdata = Prdata;
assign Hresp = 2'b00;

endmodule
