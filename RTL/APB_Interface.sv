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
 * This module represents the APB Interface,
 * which handles the interaction between the APB FSM
 * Controller and the APB peripherals. It includes logic
 * for read and write operations on the APB side.
 */



module APB_Interface (
    input logic Pwrite,
    input logic Penable,
    input logic [2:0] Pselx,
    input logic [31:0] Pwdata,
    input logic [31:0] Paddr,

    output logic Pwriteout,
    output logic Penableout,
    output logic [2:0] Pselxout,
    output logic [31:0] Pwdataout,
    output logic [31:0] Paddrout,
    output logic [31:0] Prdata
);

assign Penableout = Penable;
assign Pselxout = Pselx;
assign Pwriteout = Pwrite;
assign Paddrout = Paddr;
assign Pwdataout = Pwdata;

always_comb begin
    if (!Pwrite && Penable)
        Prdata = ($urandom) % 256; 
    else
        Prdata = 32'b0;
end

endmodule
