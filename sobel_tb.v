`timescale 1ns / 1ps

module sobel_tb;

    parameter IMG_WIDTH = 8;
    parameter IMG_HEIGHT = 8;
    parameter DATA_WIDTH = 8;

    reg clk;
    reg rst;
    reg start;
    wire done;
    wire [2:0] out_row;
    wire [2:0] out_col;
    wire [DATA_WIDTH+2:0] sobel_out;

    integer i, j;
    reg [DATA_WIDTH+2:0] stored_output [1:IMG_HEIGHT-2][1:IMG_WIDTH-2];

    sobel_top DUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .done(done),
        .out_row(out_row),
        .out_col(out_col),
        .sobel_out(sobel_out)
    );

    initial begin
        $dumpfile("sobel_edge_detector.vcd");
        $dumpvars(0, sobel_tb);
    end

    initial clk = 0;
    always #5 clk = ~clk;
	
	// Preparing ref. model
    function [DATA_WIDTH+2:0] ref_sobel;
        input integer i, j;
        integer gx, gy;
        begin
            gx = -(i-1)*(j-1) - 2*(i)*(j-1) - (i+1)*(j-1)
                 + (i-1)*(j+1) + 2*(i)*(j+1) + (i+1)*(j+1);
            gy = -(i-1)*(j-1) - 2*(i-1)*(j) - (i-1)*(j+1)
                 + (i+1)*(j-1) + 2*(i+1)*(j) + (i+1)*(j+1);
            if (gx < 0) gx = -gx;
            if (gy < 0) gy = -gy;
            ref_sobel = gx + gy;
        end
    endfunction

    initial begin
        $display("Starting simulation...");
        rst = 1;
        start = 0;
        #20 rst = 0;
        #10 start = 1;
        #10 start = 0;

        // Capture all `sobel_out` values in an array as they are generated
        while (!done) begin
            @(posedge clk);
            if (out_row >= 1 && out_row < IMG_HEIGHT - 1 && out_col >= 1 && out_col < IMG_WIDTH - 1) begin
                stored_output[out_row][out_col] = sobel_out;
            end
        end

        // Wait for final stabilization after `done`
        repeat(5) @(posedge clk);

        // Compare stored results with ref model
        $display("Comparing pixel outputs...");
        for (i = 1; i < IMG_HEIGHT - 1; i = i + 1) begin
            for (j = 1; j < IMG_WIDTH - 1; j = j + 1) begin
                if (stored_output[i][j] === ref_sobel(i, j)) begin
                    $display("Pixel (%0d,%0d): Output=%0d | Expected=%0d => MATCH", i, j, stored_output[i][j], ref_sobel(i, j));
                end else begin
                    $display("Pixel (%0d,%0d): Output=%0d | Expected=%0d => MISMATCH", i, j, stored_output[i][j], ref_sobel(i, j));
                end
            end
        end

        $display("Test complete.");
        $finish;
    end
endmodule
