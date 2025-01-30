module APB_FSM_Controller (
    input  logic        Hclk,
    input  logic        Hresetn,
    input  logic        valid,
    input  logic        Hwrite,
    input  logic        Hwritereg,
    input  logic [31:0] Hwdata,
    input  logic [31:0] Haddr,
    input  logic [31:0] Haddr1,
    input  logic [31:0] Haddr2,
    input  logic [31:0] Hwdata1,
    input  logic [31:0] Hwdata2,
    input  logic [31:0] Prdata,
    input  logic [2:0]  tempselx,
    output logic        Pwrite,
    output logic        Penable,
    output logic        Hreadyout,
    output logic [2:0]  Pselx,
    output logic [31:0] Paddr,
    output logic [31:0] Pwdata
);

// State Encoding
typedef enum logic [2:0] {
    ST_IDLE    = 3'b000,
    ST_WWAIT   = 3'b001,
    ST_READ    = 3'b010,
    ST_WRITE   = 3'b011,
    ST_WRITEP  = 3'b100,
    ST_RENABLE = 3'b101,
    ST_WENABLE = 3'b110,
    ST_WENABLEP= 3'b111
} state_t;

// Present and Next State Registers
state_t PRESENT_STATE, NEXT_STATE;

// State Transition Logic
always_ff @(posedge Hclk or negedge Hresetn) begin
    if (!Hresetn)
        PRESENT_STATE <= ST_IDLE;
    else
        PRESENT_STATE <= NEXT_STATE;
end

// Next State Logic
always_comb begin
    case (PRESENT_STATE)
        ST_IDLE: 
            if (!valid)
                NEXT_STATE = ST_IDLE;
            else if (valid && Hwrite)
                NEXT_STATE = ST_WWAIT;
            else 
                NEXT_STATE = ST_READ;
        
        ST_WWAIT:
            NEXT_STATE = (valid) ? ST_WRITEP : ST_WRITE;
        
        ST_READ:
            NEXT_STATE = ST_RENABLE;
        
        ST_WRITE:
            NEXT_STATE = (valid) ? ST_WENABLEP : ST_WENABLE;
        
        ST_WRITEP:
            NEXT_STATE = ST_WENABLEP;
        
        ST_RENABLE, ST_WENABLE:
            if (!valid)
                NEXT_STATE = ST_IDLE;
            else if (valid && Hwrite)
                NEXT_STATE = ST_WWAIT;
            else
                NEXT_STATE = ST_READ;
        
        ST_WENABLEP:
            if (!valid && Hwritereg)
                NEXT_STATE = ST_WRITE;
            else if (valid && Hwritereg)
                NEXT_STATE = ST_WRITEP;
            else
                NEXT_STATE = ST_READ;
        
        default:
            NEXT_STATE = ST_IDLE;
    endcase
end

// Output Logic
logic Penable_temp, Hreadyout_temp, Pwrite_temp;
logic [2:0] Pselx_temp;
logic [31:0] Paddr_temp, Pwdata_temp;

always_comb begin
    case (PRESENT_STATE)
        ST_IDLE: begin
            if (valid && !Hwrite) begin
                Paddr_temp = Haddr;
                Pwrite_temp = Hwrite;
                Pselx_temp = tempselx;
                Penable_temp = 0;
                Hreadyout_temp = 0;
            end else if (valid && Hwrite) begin
                Pselx_temp = 0;
                Penable_temp = 0;
                Hreadyout_temp = 1;
            end else begin
                Pselx_temp = 0;
                Penable_temp = 0;
                Hreadyout_temp = 1;
            end
        end
        
        ST_WWAIT, ST_WRITEP: begin
            Paddr_temp = Haddr1;
            Pwrite_temp = 1;
            Pselx_temp = tempselx;
            Pwdata_temp = Hwdata;
            Penable_temp = 0;
            Hreadyout_temp = 0;
        end
        
        ST_READ, ST_WRITE: begin
            Penable_temp = 1;
            Hreadyout_temp = 1;
        end
        
        ST_RENABLE, ST_WENABLEP, ST_WENABLE: begin
            Paddr_temp = Haddr2;
            Pwrite_temp = Hwrite;
            Pselx_temp = tempselx;
            Pwdata_temp = Hwdata;
            Penable_temp = 0;
            Hreadyout_temp = 0;
        end
        
        default: begin
            Paddr_temp = 0;
            Pwrite_temp = 0;
            Pselx_temp = 0;
            Pwdata_temp = 0;
            Penable_temp = 0;
            Hreadyout_temp = 0;
        end
    endcase
end

// Sequential Output Logic
always_ff @(posedge Hclk or negedge Hresetn) begin
    if (!Hresetn) begin
        Paddr <= 0;
        Pwrite <= 0;
        Pselx <= 0;
        Pwdata <= 0;
        Penable <= 0;
        Hreadyout <= 0;
    end else begin
        Paddr <= Paddr_temp;
        Pwrite <= Pwrite_temp;
        Pselx <= Pselx_temp;
        Pwdata <= Pwdata_temp;
        Penable <= Penable_temp;
        Hreadyout <= Hreadyout_temp;
    end
end

endmodule