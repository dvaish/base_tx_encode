`timescale 1ns/1ps
`include "/scratch/eecs251b-abg/base_tx_encode/FFE_Decoder.sv"

module ffe_decoder_tb;

parameter CLOCK_PERIOD = 10;

reg clock;
reg reset;

// Inputs
reg signed [7:0] ffe_input [3:0];
reg signed [7:0] taps [13:0];

wire [11:0] rxSymbols;
wire        rxValid;

// Instantiate the DUT
FFE_Decoder dut (
    .clock(clock),
    .reset(reset),
    .io_ffe_in_0(ffe_input[0]),
    .io_ffe_in_1(ffe_input[1]),
    .io_ffe_in_2(ffe_input[2]),
    .io_ffe_in_3(ffe_input[3]),
    .io_taps_0(taps[0]),
    .io_taps_1(taps[1]),
    .io_taps_2(taps[2]),
    .io_taps_3(taps[3]),
    .io_taps_4(taps[4]),
    .io_taps_5(taps[5]),
    .io_taps_6(taps[6]),
    .io_taps_7(taps[7]),
    .io_taps_8(taps[8]),
    .io_taps_9(taps[9]),
    .io_taps_10(taps[10]),
    .io_taps_11(taps[11]),
    .io_taps_12(taps[12]),
    .io_taps_13(taps[13]),
    .io_rxSymbols(rxSymbols),
    .io_rxValid(rxValid)
);

// Clock Generation
initial clock = 0;
always #(CLOCK_PERIOD / 2) clock = ~clock;

// Reset Task
task reset_DUT();
    reset <= 1;
    repeat(2) @(posedge clock);
    reset <= 0;
endtask

// Output file
integer output_file, input_file, tap_file;
integer line;
reg signed [7:0] in0, in1, in2, in3;

// Output symbols
reg signed [2:0] sym0, sym1, sym2, sym3;

initial begin
    $display("Starting FFE_Decoder TB...");

    // Setup VCD if needed
    if ($test$plusargs("vcd")) begin
        $dumpfile("ffe_decoder_tb.vcd");
        $dumpvars(0, ffe_decoder_tb);
    end

    // Load tap values
    tap_file = $fopen("tap_vector.txt", "r");
    if (!tap_file) begin
        $display("ERROR: Cannot open tap_vector.txt");
        $finish;
    end
    for (int i = 0; i < 14; i++) begin
        $fscanf(tap_file, "%d", taps[i]);
    end
    $fclose(tap_file);

    // Open input and output files
    input_file = $fopen("ffe_input.txt", "r");
    output_file = $fopen("ffe_decoder_output.txt", "w");

    if (!input_file) begin
        $display("ERROR: Cannot open ffe_input.txt");
        $finish;
    end
    if (!output_file) begin
        $display("ERROR: Cannot open ffe_decoder_output.txt for writing");
        $finish;
    end

    reset_DUT();

    while (!$feof(input_file)) begin
        line = $fscanf(input_file, "%d %d %d %d", in0, in1, in2, in3);
        if (line == 4) begin
            ffe_input[0] = in0;
            ffe_input[1] = in1;
            ffe_input[2] = in2;
            ffe_input[3] = in3;
        end

        @(posedge clock);

        if (rxValid) begin
            sym3 = rxSymbols[2:0];
            sym2 = rxSymbols[5:3];
            sym1 = rxSymbols[8:6];
            sym0 = rxSymbols[11:9];

            $fwrite(output_file, "%0d %0d %0d %0d\n", sym0, sym1, sym2, sym3);
        end
    end

    // Wait for trailing output
    repeat(10) begin
        @(posedge clock);
        if (rxValid) begin
            sym3 = rxSymbols[2:0];
            sym2 = rxSymbols[5:3];
            sym1 = rxSymbols[8:6];
            sym0 = rxSymbols[11:9];

            $fwrite(output_file, "%0d %0d %0d %0d\n", sym0, sym1, sym2, sym3);
        end
    end

    $display("Testbench finished. Output written to ffe_decoder_output.txt");
    $fclose(input_file);
    $fclose(output_file);
    $finish;
end

endmodule
