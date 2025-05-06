`timescale 1ns/1ps
`include "FFE_Decoder.sv"

module ffe_decoder_tb;

parameter CLOCK_PERIOD = 10;

reg clock;
reg reset;

// Inputs to the combined module
logic signed [7:0] ffe_input [3:0];  // FFE input samples
logic signed [7:0] taps [13:0];      // PDFD taps

// Output from DUT
wire [11:0] decoded_syms;
wire        valid;

// Symbol breakdown
logic signed [2:0] sym0, sym1, sym2, sym3;

// Reference symbols for checking
typedef struct {
    int sym0;
    int sym1;
    int sym2;
    int sym3;
} SymbolEntry;

SymbolEntry expected_syms[$];
SymbolEntry ref_syms;

// DUT instantiation
FFE_Decoder dut (
    .clock(clock),
    .reset(reset),
    .io_rxSamples_0(ffe_input[0]),
    .io_rxSamples_1(ffe_input[1]),
    .io_rxSamples_2(ffe_input[2]),
    .io_rxSamples_3(ffe_input[3]),
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
    .io_decoded(decoded_syms),
    .io_valid(valid)
);

// Clock generation
initial clock = 0;
always #(CLOCK_PERIOD/2) clock = ~clock;

// Reset task
task automatic reset_DUT();
    reset <= 1;
    repeat(2) @(posedge clock);
    reset <= 0;
endtask

// File handles
integer ffe_file, tap_file, ref_file;
integer line, ref_line;
integer cycle_count = 0;
integer error_count = 0;

initial begin
    if ($test$plusargs("debug")) begin
        $dumpfile("ffe_decoder.vcd");
        $dumpvars(0, ffe_decoder_tb);
    end

    // Open tap file
    tap_file = $fopen("tap_vector.txt", "r");
    if (!tap_file) begin
        $display("ERROR: Cannot open tap_vector.txt!");
        $finish;
    end
    for (int i = 0; i < 14; i++) begin
        line = $fscanf(tap_file, "%d", taps[i]);
    end
    $fclose(tap_file);

    // Open input sample file
    ffe_file = $fopen("ffe_input.txt", "r");
    if (!ffe_file) begin
        $display("ERROR: Cannot open ffe_input.txt!");
        $finish;
    end

    // Open reference output file
    ref_file = $fopen("ref_output.txt", "r");
    if (!ref_file) begin
        $display("ERROR: Cannot open ref_output.txt!");
        $finish;
    end

    // Initial state
    reset_DUT();
    for (int i = 0; i < 4; i++) ffe_input[i] = 0;

    // Main simulation loop
    while (!$feof(ffe_file)) begin
        cycle_count++;

        // Read input and reference
        line = $fscanf(ffe_file, "%d %d %d %d", 
            ffe_input[0], ffe_input[1], ffe_input[2], ffe_input[3]);

        ref_line = $fscanf(ref_file, "%d %d %d %d", 
            ref_syms.sym0, ref_syms.sym1, ref_syms.sym2, ref_syms.sym3);

        if (line == 4 && ref_line == 4) begin
            expected_syms.push_back(ref_syms);
        end

        // Decode outputs
        sym3 = decoded_syms[2:0];
        sym2 = decoded_syms[5:3];
        sym1 = decoded_syms[8:6];
        sym0 = decoded_syms[11:9];

        // Check after initial pipeline fill
        if (cycle_count > 17 && valid) begin
            SymbolEntry ref = expected_syms.pop_front();
            if (sym0 !== ref.sym0 || sym1 !== ref.sym1 || sym2 !== ref.sym2 || sym3 !== ref.sym3) begin
                if (sym0 !== ref.sym0) error_count++;
                if (sym1 !== ref.sym1) error_count++;
                if (sym2 !== ref.sym2) error_count++;
                if (sym3 !== ref.sym3) error_count++;
            end
        end

        @(posedge clock);
    end

    // Finish off any remaining outputs
    while (expected_syms.size() > 0) begin
        cycle_count++;

        sym3 = decoded_syms[2:0];
        sym2 = decoded_syms[5:3];
        sym1 = decoded_syms[8:6];
        sym0 = decoded_syms[11:9];

        SymbolEntry ref = expected_syms.pop_front();
        if (valid) begin
            if (sym0 !== ref.sym0 || sym1 !== ref.sym1 || sym2 !== ref.sym2 || sym3 !== ref.sym3) begin
                if (sym0 !== ref.sym0) error_count++;
                if (sym1 !== ref.sym1) error_count++;
                if (sym2 !== ref.sym2) error_count++;
                if (sym3 !== ref.sym3) error_count++;
            end
        end

        @(posedge clock);
    end

    $display("Simulation completed. Total errors: %0d", error_count);
    $fclose(ffe_file);
    $fclose(ref_file);

    if ($test$plusargs("debug")) begin
        $vcdplusoff;
    end
    $finish;
end

endmodule
