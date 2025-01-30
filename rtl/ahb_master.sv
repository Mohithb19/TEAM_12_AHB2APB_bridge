module AHB_Master (
    input logic Hclk, Hresetn, Hreadyout, 
    input logic [1:0] Hresp,
    input logic [31:0] Hrdata,
    output logic Hwrite, Hreadyin,
    output logic [1:0] Htrans,
    output logic [31:0] Hwdata, Haddr
); // Hreadyout = SLAVE is ready, Hreadyin = MASTER is ready, Hrdata = read data from SLAVE, Hresp = resp from SLAVE

    logic [2:0] Hburst;
    logic [2:0] Hsize;

    task automatic single_write();
        begin
            @(posedge Hclk);
            #2;
            Hwrite = 1;
            Htrans = 2'b10;
            Hsize = 3'b000;
            Hburst = 3'b000;
            Hreadyin = 1;
            Haddr = 32'h8000_0001;
            
            @(posedge Hclk);
            #2;
            Htrans = 2'b00;
            Hwdata = 8'hA3;
        end
    endtask

    task automatic single_read();
        begin
            @(posedge Hclk);
            #2;
            Hwrite = 0;
            Htrans = 2'b10;
            Hsize = 3'b000;
            Hburst = 3'b000;
            Hreadyin = 1;
            Haddr = 32'h8000_00A2;
            
            @(posedge Hclk);
            #2;
            Htrans = 2'b00;
        end
    endtask

endmodule