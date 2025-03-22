module image_mem #(
    parameter IMG_WIDTH = 8,
    parameter IMG_HEIGHT = 8,
    parameter DATA_WIDTH = 8
)(
    input  wire [$clog2(IMG_HEIGHT)-1:0] row,
    input  wire [$clog2(IMG_WIDTH)-1:0] col,
    output reg  [DATA_WIDTH-1:0] pixel
);

    reg [DATA_WIDTH-1:0] img_data [0:IMG_HEIGHT-1][0:IMG_WIDTH-1];

    integer i, j;
    initial begin
        for (i = 0; i < IMG_HEIGHT; i = i + 1) begin
            for (j = 0; j < IMG_WIDTH; j = j + 1) begin
                img_data[i][j] = (i * j) % 256;  // Modulo-based test pattern
            end
        end
    end

    always @(*) begin
        pixel = img_data[row][col];
    end
endmodule