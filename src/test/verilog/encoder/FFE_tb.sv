`timescale 1ns/1ps
`include "/scratch/eecs251b-abg/base_tx_encode/FFE.sv"
module FFE_tb;

  parameter CLOCK_PERIOD = 8;

  // Clock and Reset
  reg clock = 0;
  reg reset;
  

  // Inputs
  reg         io_in_valid;
  reg  [7:0]  io_in_bits_0;
  reg  [7:0]  io_in_bits_1;
  reg  [7:0]  io_in_bits_2;
  reg  [7:0]  io_in_bits_3;

  // Outputs
  wire        io_out_valid;
  wire [7:0]  io_out_bits_0;
  wire [7:0]  io_out_bits_1;
  wire [7:0]  io_out_bits_2;
  wire [7:0]  io_out_bits_3;

  // Tie-off unused FFE I/Os
  assign auto_reg_in_a_valid = 0;
  assign auto_reg_in_a_bits_opcode = 0;
  assign auto_reg_in_a_bits_param = 0;
  assign auto_reg_in_a_bits_size = 0;
  assign auto_reg_in_a_bits_source = 0;
  assign auto_reg_in_a_bits_address = 0;
  assign auto_reg_in_a_bits_mask = 0;
  assign auto_reg_in_a_bits_data = 0;
  assign auto_reg_in_a_bits_corrupt = 0;
  assign auto_reg_in_d_ready = 1;

  // Unused wires
  wire auto_reg_in_a_ready;
  wire auto_reg_in_d_valid;
  wire [2:0] auto_reg_in_d_bits_opcode;
  wire [1:0] auto_reg_in_d_bits_size;
  wire [2:0] auto_reg_in_d_bits_source;
  always #(CLOCK_PERIOD/2) clock = ~clock;
  // DUT instantiation
  FFE dut (
    .clock(clock),
    .reset(reset),
    .auto_reg_in_a_ready(auto_reg_in_a_ready),
    .auto_reg_in_a_valid(auto_reg_in_a_valid),
    .auto_reg_in_a_bits_opcode(auto_reg_in_a_bits_opcode),
    .auto_reg_in_a_bits_param(auto_reg_in_a_bits_param),
    .auto_reg_in_a_bits_size(auto_reg_in_a_bits_size),
    .auto_reg_in_a_bits_source(auto_reg_in_a_bits_source),
    .auto_reg_in_a_bits_address(auto_reg_in_a_bits_address),
    .auto_reg_in_a_bits_mask(auto_reg_in_a_bits_mask),
    .auto_reg_in_a_bits_data(auto_reg_in_a_bits_data),
    .auto_reg_in_a_bits_corrupt(auto_reg_in_a_bits_corrupt),
    .auto_reg_in_d_ready(auto_reg_in_d_ready),
    .auto_reg_in_d_valid(auto_reg_in_d_valid),
    .auto_reg_in_d_bits_opcode(auto_reg_in_d_bits_opcode),
    .auto_reg_in_d_bits_size(auto_reg_in_d_bits_size),
    .auto_reg_in_d_bits_source(auto_reg_in_d_bits_source),
    .io_in_valid(io_in_valid),
    .io_in_bits_0(io_in_bits_0),
    .io_in_bits_1(io_in_bits_1),
    .io_in_bits_2(io_in_bits_2),
    .io_in_bits_3(io_in_bits_3),
    .io_out_valid(io_out_valid),
    .io_out_bits_0(io_out_bits_0),
    .io_out_bits_1(io_out_bits_1),
    .io_out_bits_2(io_out_bits_2),
    .io_out_bits_3(io_out_bits_3)
  );

  // File handling
  integer infile, outfile;
  reg [255:0] line;
  integer r;

  initial begin
    $dumpfile("ffe.vcd");
    $dumpvars(0, FFE_tb);

    // Open input and output files
    infile = $fopen("ffe_input.txt", "r");
    if (!infile) begin
      $display("ERROR: Couldn't open input file.");
      $finish;
    end

    outfile = $fopen("ffe_output.txt", "w");
    if (!outfile) begin
      $display("ERROR: Couldn't open output file.");
      $finish;
    end

    // Reset
    reset = 1;
    io_in_valid = 0;
    io_in_bits_0 = 0;
    io_in_bits_1 = 0;
    io_in_bits_2 = 0;
    io_in_bits_3 = 0;
    io_in_valid = 0;
    repeat (5) @(posedge clock);
    reset = 0;
    io_in_valid = 1;
    

    // Write output header
    $fwrite(outfile, "OUT_VALID\tOUT_0\tOUT_1\tOUT_2\tOUT_3\n");

    // Read and drive input from file
    while (!$feof(infile)) begin
      r = $fscanf(infile, "%d\t%d\t%d\t%d\n", io_in_bits_0, io_in_bits_1, io_in_bits_2, io_in_bits_3);
      @(posedge clock);

      // Capture output
      $fwrite(outfile, "%0d\t%0d\t%0d\t%0d\t%0d\n",
              io_out_valid, io_out_bits_0, io_out_bits_1, io_out_bits_2, io_out_bits_3);
      // $fwrite(outfile, "%h\t%h\t%h\t%h\t%h\n",
      //         dut._firFilters_1.io_weights_0, dut._firFilters_1.io_weights_1, dut._firFilters_1.io_weights_2, dut._firFilters_1.io_weights_3, dut._firFilters_1.io_weights_4);

    end

    $fclose(infile);
    $fclose(outfile);
    $display("FFE output written to ffe_output.txt");
    $finish;
  end

  // Timeout protection
  reg [31:0] cycle_count = 0;
  always @(posedge clock) begin
    cycle_count <= cycle_count + 1;
    if (cycle_count > 10000) begin
      $fatal("TIMEOUT: simulation exceeded 10000 cycles");
    end
  end

endmodule
