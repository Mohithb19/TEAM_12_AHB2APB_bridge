module APB_Interface (
    input  logic        Pwrite,
    input  logic        Penable,
    input  logic [2:0]  Pselx,
    input  logic [31:0] Pwdata,
    input  logic [31:0] Paddr,
    output logic        Pwriteout,
    output logic        Penableout,
    output logic [2:0]  Pselxout,
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
        Prdata = $random % 256;
    else
        Prdata = 0;
end

endmodule