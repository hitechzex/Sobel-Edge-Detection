module sobel_top #(
    parameter IMG_WIDTH = 8,
    parameter IMG_HEIGHT = 8,
    parameter DATA_WIDTH = 8
)(
    input  wire clk,
    input  wire rst,
    input  wire start,
    output reg  done,
    output reg  [2:0] out_row,
    output reg  [2:0] out_col,
    output reg  [DATA_WIDTH+2:0] sobel_out
);

    reg [3:0] col;
    reg [3:0] row;
    reg [3:0] state;

    localparam IDLE = 0, READ = 1, PROCESS = 2, DONE_STATE = 3;

    wire [DATA_WIDTH-1:0] pixel;
    reg  [2:0] mem_col;
    reg  [2:0] mem_row;

    reg [DATA_WIDTH-1:0] window [0:2][0:2];
    integer i, j;

    wire [DATA_WIDTH+2:0] gradient;

    image_mem mem (
        .row(mem_row),
        .col(mem_col),
        .pixel(pixel)
    );

    sobel_core sobel (
        .p00(window[0][0]), .p01(window[0][1]), .p02(window[0][2]),
        .p10(window[1][0]), .p11(window[1][1]), .p12(window[1][2]),
        .p20(window[2][0]), .p21(window[2][1]), .p22(window[2][2]),
        .gradient(gradient)
    );

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state <= IDLE;
            done <= 0;
            col <= 1;
            row <= 1;
        end else begin
            case (state)
                IDLE: begin // IDLE
                    done <= 0;
                    if (start) begin
                        row <= 1;
                        col <= 1;
                        state <= READ;
                    end
                end
                READ: begin // Reading from image memory
                    for (i = 0; i < 3; i = i + 1)
                        for (j = 0; j < 3; j = j + 1) begin
                            mem_row <= row + i - 1;
                            mem_col <= col + j - 1;
                            #1 window[i][j] <= pixel;
                        end
                    state <= PROCESS;
                end
                PROCESS: begin // Applying Sobel filter
                    sobel_out <= gradient;
                    out_row <= row;
                    out_col <= col;

                    if (col < IMG_WIDTH - 2) begin
                        col <= col + 1;
                        state <= READ;
                    end else begin
                        col <= 1;
                        if (row < IMG_HEIGHT - 2) begin
                            row <= row + 1;
                            state <= READ;
                        end else begin
                            state <= DONE_STATE;
                        end
                    end
                end
                DONE_STATE: begin // Done
                    done <= 1;
                    state <= IDLE;
                end
            endcase
        end
    end
endmodule
