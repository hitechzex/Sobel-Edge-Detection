module sobel_core #(
    parameter DATA_WIDTH = 8
)(
    input  wire [DATA_WIDTH-1:0] p00, p01, p02, // Window of adjacent pixels
                                 p10, p11, p12,
                                 p20, p21, p22,
    output wire [DATA_WIDTH+2:0] gradient
);

    wire signed [10:0] gx, gy;
    
    assign gx = 
        -p00 - 2*p10 - p20 +
         p02 + 2*p12 + p22;

    assign gy = 
        -p00 - 2*p01 - p02 +
         p20 + 2*p21 + p22;

    wire [10:0] abs_gx = gx[10] ? -gx : gx;
    wire [10:0] abs_gy = gy[10] ? -gy : gy;

    assign gradient = abs_gx + abs_gy; // Final outcome of the given pixels

endmodule