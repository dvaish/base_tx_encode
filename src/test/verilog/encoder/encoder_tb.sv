`timescale 1ns/10ps
`include "/scratch/eecs251b-aac/base_tx_encode/Encoder.sv"

// // vcs -full64 src/test/verilog/encoder/encoder_tb.sv -sverilog +incdir+. -R

// module encoder_tb;

// parameter CLOCK_PERIOD = 8;

// reg            clock;
// reg            reset;
// reg            io_tx_enable;
// reg            io_tx_mode;
// reg            io_tx_error;
// reg [7:0]      io_tx_data;
// reg [31:0]     io_n;
// reg [31:0]     io_n0;
// reg            io_loc_rcvr_status;
// reg [2:0]      io_A;
// reg [2:0]      io_B;
// reg [2:0]      io_C;
// reg [2:0]      io_D;

// initial clock = 0;
// always #(CLOCK_PERIOD/2) clock = !clock;

// always @(posedge clock) io_n = io_n + 1;

// Encoder dut (.*);

// task test_RESET();
//     @(posedge clock);
//     reset <= 0;
//     repeat (5) @(posedge clock);
// endtask

// wire [3*4-1:0] packet; 
// assign packet = {dut.lut.io_tA, dut.lut.io_tB, dut.lut.io_tC, dut.lut.io_tD};

// localparam logic [3*4-1:0] SSD1         = {{3'd2}, {3'd2}, {3'd2}, {3'd2}};
// localparam logic [3*4-1:0] SSD2         = {{3'd2}, {3'd2}, {3'd2}, {3'd6}};
// localparam logic [3*4-1:0] ESD1         = {{3'd2}, {3'd2}, {3'd2}, {3'd2}};
// localparam logic [3*4-1:0] ESD2_Ext_0   = {{3'd2}, {3'd2}, {3'd2}, {3'd6}};
// localparam logic [3*4-1:0] ESD2_Ext_1   = {{3'd2}, {3'd2}, {3'd6}, {3'd2}};
// localparam logic [3*4-1:0] ESD2_Ext_2   = {{3'd2}, {3'd6}, {3'd2}, {3'd2}};
// localparam logic [3*4-1:0] ESD2_Ext_Err = {{3'd6}, {3'd2}, {3'd2}, {3'd2}};

// integer i;
// task test_NORMAL();

//     test_RESET();

//     io_tx_enable <= 1;
//     @(posedge clock);

//     assert (packet == SSD1);
//     @(posedge clock);

//     assert (packet == SSD2);
//     @(posedge clock);

//     for (i = 0; i < 4; i = i + 1) begin
//         $display("[CONDITION=%d] %d, %d, %d, %d", dut.ce.io_condition, $signed(dut.lut.io_tA), $signed(dut.lut.io_tB), $signed(dut.lut.io_tC), $signed(dut.lut.io_tD));
//         // if (i == 0) assert (packet == SSD1);
//         @(posedge clock);
//     end

//     io_tx_enable <= 0;
//     @(posedge clock)

//     $display("[CONDITION=%d] %d, %d, %d, %d", dut.ce.io_condition, $signed(dut.lut.io_tA), $signed(dut.lut.io_tB), $signed(dut.lut.io_tC), $signed(dut.lut.io_tD));
//     @(posedge clock);

//     $display("[CONDITION=%d] %d, %d, %d, %d", dut.ce.io_condition, $signed(dut.lut.io_tA), $signed(dut.lut.io_tB), $signed(dut.lut.io_tC), $signed(dut.lut.io_tD));
//     @(posedge clock);

//     assert (packet == ESD1);
//     @(posedge clock);

//     assert (packet == ESD2_Ext_0);
//     @(posedge clock);

//     // for (i = 0; i < 4; i = i + 1) begin
//     //     $display("[CONDITION=%d] %d, %d, %d, %d", dut.ce.io_condition, $signed(dut.lut.io_tA), $signed(dut.lut.io_tB), $signed(dut.lut.io_tC), $signed(dut.lut.io_tD));
//     //     @(posedge clock);
//     // end

// endtask

// initial begin
//     $dumpfile("waves.vcd");  // Dump to "waves.vcd"
//     $dumpvars(0, encoder_tb);       // Dump all variables in module "test"

//     reset               = 1;
//     io_tx_enable        = 0;
//     io_tx_mode          = 1;
//     io_tx_error         = 0;
//     io_tx_data          = 8'b11110000;
//     io_n                = 0;
//     io_loc_rcvr_status  = 1;

//     test_NORMAL();



//     $finish;
// end

// endmodule


`timescale 1ns/1ps

module Encoder_tb;

  parameter CLOCK_PERIOD = 8;

  // Clock and Reset
  reg clock = 0;
  reg reset;

  always #(CLOCK_PERIOD/2) clock = ~clock;

  // Inputs
  reg         io_tx_enable;
  reg         io_tx_mode;
  reg         io_tx_error;
  reg  [7:0]  io_tx_data;
  reg  [31:0] io_n;
  reg  [31:0] io_n0;
  reg         io_loc_rcvr_status;
  reg  [7:0] i;
  // Outputs
  wire [2:0] io_A, io_B, io_C, io_D;

  // DUT
  Encoder dut (
    .clock(clock),
    .reset(reset),
    .io_tx_enable(io_tx_enable),
    .io_tx_mode(io_tx_mode),
    .io_tx_error(io_tx_error),
    .io_tx_data(io_tx_data),
    .io_n(io_n),
    .io_n0(io_n0),
    .io_loc_rcvr_status(io_loc_rcvr_status),
    .io_A(io_A),
    .io_B(io_B),
    .io_C(io_C),
    .io_D(io_D)
  );

  wire [7:0] tx_data;
  assign tx_data = 8'b11110000;

  // File handler
  integer outfile;

  initial begin
    $dumpfile("encoder.vcd");
    $dumpvars(0, Encoder_tb);

    // Open output file
    outfile = $fopen("encoder_output.txt", "w");
    if (!outfile) begin
      $display("ERROR: Failed to open output file.");
      $finish;
    end

    // Write header
    $fwrite(outfile, "TX_DATA\tA\tB\tC\tD\n");

    // Reset sequence
    reset = 1;
    io_tx_enable = 0;
    io_tx_mode = 0;
    io_tx_error = 0;
    io_tx_data = 8'd0;
    io_n = 32'd0;
    io_n0 = 32'd0;
    io_loc_rcvr_status = 1;

    repeat (4) @(posedge clock);
    reset <= 0;

    repeat (1) @(posedge clock);

    // Stimulate with a range of input values
    for (i = 0; i < 256; i=i+1) begin
      io_tx_data <= i[7:0];
      io_tx_enable <= 1;
      io_n <= io_n + 1;

      @(posedge clock);  // Wait for output to settle

      // Log values to file
      $fwrite(outfile, "%08b\t%d\t%d\t%d\t%d\n", io_tx_data, $signed(dut.lut.io_tA), $signed(dut.lut.io_tB), $signed(dut.lut.io_tC), $signed(dut.lut.io_tD));


      // io_tx_enable <= 0;
    end

    $fclose(outfile);
    $display("Encoder output written to encoder_output.txt");
    $finish;
  end

  // Timeout
  reg [31:0] cycle_count = 0;
  always @(posedge clock) begin
    cycle_count <= cycle_count + 1;
    if (cycle_count > 2000) begin
      $fatal("TIMEOUT: simulation exceeded 2000 cycles");
    end
  end

endmodule
