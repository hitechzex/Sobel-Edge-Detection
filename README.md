Sobel Edge Detection in Verilog
===============================

Overview
--------
This project implements a simple and realistic Sobel edge detector using Verilog. The goal is to process an 8x8 grayscale image, detect edges using the Sobel filter, and verify the results using a testbench with a golden model.

Modules
-------

1. image_mem.v
   - Stores an 8x8 test image.
   - Initialized with a modulo-based pattern (pixel = (i * j) % 256).
   - Provides pixel values on request.

2. sobel_core.v
   - Applies the Sobel convolution using a 3x3 window.
   - Outputs the gradient magnitude as the sum of absolute Gx and Gy.

3. sobel_top.v
   - Top-level controller that coordinates reading from memory and applying the Sobel filter.
   - Iterates over each valid pixel and stores the result.
   - Signals when processing is complete with a 'done' signal.

4. sobel_tb.v
   - Testbench that initializes the system, waits for the 'done' signal, and then compares each output to a golden model.
   - The results of each comparison are printed with both actual and expected values and a match/mismatch status.

Simulation Screenshot
---------------------

![Simulation](https://github.com/hitechzex/Sobel-Edge-Detection/blob/main/Simulation_screenshot/your-image.png?raw=true)
