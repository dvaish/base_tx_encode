`timescale 1ns/1ps
`include "/scratch/eecs251b-aac/base_tx_encode/LaPDFD.sv"

module lapdfd_tb;

parameter CLOCK_PERIOD = 10;

reg clock;
reg reset;

// Inputs
logic signed [7:0] rx_syms[3:0];
logic signed [7:0] taps[13:0];
logic signed [2:0] sym0, sym1, sym2, sym3;

// Wires to connect to DUT
wire [11:0] rxData;
wire       rxValid;

int sym_table[5] = '{-103, -52, 0, 51, 101};
int ref_table[5] = '{-2, -1, 0, 1, 2};

// DUT instance
LaPDFD dut (
    .clock(clock),
    .reset(reset),
    .io_rxSamples_0(rx_syms[0]),
    .io_rxSamples_1(rx_syms[1]),
    .io_rxSamples_2(rx_syms[2]),
    .io_rxSamples_3(rx_syms[3]),
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
    .io_rxSymbols(rxData),
    .io_rxValid(rxValid)
);

// Clock generation
initial clock = 0;
always #(CLOCK_PERIOD / 2) clock = ~clock;

// Reset task
task reset_DUT();
    reset <= 1;
    @(posedge clock);
    @(posedge clock);
    reset <= 0;
endtask

// map standard PAM5 to sampled values
reg signed [7:0] sample_in [3:0];

always_comb begin
    for (int i = 0; i < 4; i++) begin
        rx_syms[i] = sample_in[i];
    end
end

// File handles and counters
integer tap_file, vector_file, outfile, line;
integer cycle_count = 0;

initial begin
    if ($test$plusargs("debug")) begin
        $dumpfile("lapdfd.vcd");
        $dumpvars(0, lapdfd_tb);
        // $vcdplusfile("lapdfd.vpd");
        // $vcdpluson(0, lapdfd_tb);
    end

    // Open and read tap vector file
    tap_file = $fopen("tap_vector.txt", "r");
    if (!tap_file) begin
        $display("ERROR: Cannot open tap_vector.txt!");
        $finish;
    end
    for (int i = 0; i < 14; i++) begin
        line = $fscanf(tap_file, "%d", taps[i]);
    end
    $fclose(tap_file);

    // Open input sample vector file
    vector_file = $fopen("ffe_output.txt", "r");
    if (!vector_file) begin
        $display("ERROR: Cannot open ffe_output.txt!");
        $finish;
    end

    // Open output file to write decoded symbols
    outfile = $fopen("decoded_output.txt", "w");
    if (!outfile) begin
        $display("ERROR: Cannot open decoded_output.txt!");
        $finish;
    end

    // Initialize inputs
    for (int i = 0; i < 4; i++) begin
        sample_in[i] = 0;
    end

    reset = 1;
    repeat(4) @(posedge clock);
    reset = 0;

    // Main simulation loop
    while (!$feof(vector_file)) begin
        cycle_count += 1;

        // Read 4 input samples per line
        line = $fscanf(vector_file, "%d %d %d %d", 
            sample_in[0], sample_in[1], sample_in[2], sample_in[3]);

        @(posedge clock);

        // Extract symbols from rxData
        sym3 = rxData[2:0];
        sym2 = rxData[5:3];
        sym1 = rxData[8:6];
        sym0 = rxData[11:9];

        if (rxValid) begin
            // Write raw decoded 3-bit symbols to file
            $fwrite(outfile, "%0d %0d %0d %0d %0d %0d %0d %0d\n", sym0, sym1, sym2, sym3,$signed(dut.dfp_0.io_rxFilter),$signed(dut.dfp_1.io_rxFilter),$signed(dut.dfp_2.io_rxFilter),$signed(dut.dfp_3.io_rxFilter));
        end
    end

    // Wrap up
    $fclose(vector_file);
    $fclose(outfile);
    // if ($test$plusargs("debug")) begin
    //     $vcdplusoff;
    // end

    $display("Simulation complete. Output written to decoded_output.txt.");
    $finish;
end

endmodule
