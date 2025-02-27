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
 * This module implements the AHB Master, which generates
 * read and write transactions for the AHB-to-APB bridge.
 * It provides tasks for single read and write operations.
 */



module AHB_Master (
    input logic Hclk,
    input logic Hresetn,
    input logic Hreadyout,
    input logic [1:0] Hresp,
    input logic [31:0] Hrdata,
    output logic Hwrite,
    output logic Hreadyin,
    output logic [1:0] Htrans,
    output logic [31:0] Hwdata,
    output logic [31:0] Haddr
);

    logic [2:0] Hburst;
    logic [2:0] Hsize;

    // Task for single write operation
    task automatic single_write();
        begin
            @(posedge Hclk);
            #2;
            begin
                Hwrite = 1;
                Htrans = 2'b10;
                Hsize = 3'b000;
                Hburst = 3'b000;
                Hreadyin = 1;
                Haddr = 32'h8000_0001;
            end
            
            @(posedge Hclk);
            #2;
            begin
                Htrans = 2'b00;
                Hwdata = 8'hA3;
            end
        end
    endtask

    // Task for single read operation
    task automatic single_read();
        begin
            @(posedge Hclk);
            #2;
            begin
                Hwrite = 0;
                Htrans = 2'b10;
                Hsize = 3'b000;
                Hburst = 3'b000;
                Hreadyin = 1;
                Haddr = 32'h8000_00A2;
            end
            
            @(posedge Hclk);
            #2;
            begin
                Htrans = 2'b00;
            end
        end
    endtask

endmodule
