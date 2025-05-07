// `timescale 1ns/10ps
// `include "/scratch/eecs251b-abg/base_tx_encode/Descrambler.sv"

// module descrambler_tb;

//   parameter CLOCK_PERIOD = 8;

//   reg clock;
//   reg reset;

//   // Inputs
//   reg         io_tx_enable;
//   reg [7:0]   io_scn;
//   reg [8:0]   io_sdn;
//   reg         io_loc_rcvr_status;

//   // Outputs
//   wire [7:0]  io_recovered_tx_data;
//   wire        io_recovered_tx_error;

//   integer infile, outfile, r;
//   reg [255:0] line;
//   reg [17:0]  in_bits;

//   // Clock generation
//   initial clock = 0;
//   always #(CLOCK_PERIOD/2) clock = ~clock;

//   // DUT instantiation
//   Descrambler dut (
//     .clock(clock),
//     .reset(reset),
//     .io_tx_enable(io_tx_enable),
//     .io_scn(io_scn),
//     .io_sdn(io_sdn),
//     .io_loc_rcvr_status(io_loc_rcvr_status),
//     .io_recovered_tx_data(io_recovered_tx_data),
//     .io_recovered_tx_error(io_recovered_tx_error)
//   );

//   initial begin
//     $dumpfile("descrambler.vcd");
//     $dumpvars(0, descrambler_tb);

//     // Reset
//     reset = 1;
//     io_tx_enable = 0;
//     io_scn = 8'd0;
//     io_sdn = 9'd0;
//     io_loc_rcvr_status = 0;

//     infile = $fopen("descrambler_input.txt", "r");
//     if (!infile) begin
//       $display("ERROR: Could not open descrambler_input.txt");
//       $finish;
//     end

//     outfile = $fopen("descrambler_output.txt", "w");
//     if (!outfile) begin
//       $display("ERROR: Could not open descrambler_output.txt");
//       $finish;
//     end

//     repeat (2) @(posedge clock);
//     reset = 0;

//     // Read inputs line-by-line
//     while (!$feof(infile)) begin
//       r = $fgets(line, infile);
//       if (r) begin
//         r = $sscanf(line, "%b %b%b%b%b%b%b%b%b %b%b%b%b%b%b%b%b%b %b",
//           io_tx_enable,
//           io_scn[7], io_scn[6], io_scn[5], io_scn[4], io_scn[3], io_scn[2], io_scn[1], io_scn[0],
//           io_sdn[8], io_sdn[7], io_sdn[6], io_sdn[5], io_sdn[4], io_sdn[3], io_sdn[2], io_sdn[1], io_sdn[0],
//           io_loc_rcvr_status
//         );
//         @(posedge clock);

//         $fwrite(outfile, "Time = %0t ns | TX_EN = %b | SCN = %b | SDN = %b | LOC_STATUS = %b | Decoded = 0x%0h | Error = %b\n",
//           $time, io_tx_enable, io_scn, io_sdn, io_loc_rcvr_status,
//           io_recovered_tx_data, io_recovered_tx_error
//         );
//       end
//     end

//     $fclose(infile);
//     $fclose(outfile);
//     $finish;
//   end

// endmodule
`timescale 1ns/10ps
`include "/scratch/eecs251b-abg/base_tx_encode/Descrambler.sv"

module descrambler_tb;

  parameter CLOCK_PERIOD = 8;

  reg clock;
  reg reset;

  // Inputs
  reg         io_tx_enable;
  reg [7:0]   io_scn;
  reg [8:0]   io_sdn;
  reg         io_loc_rcvr_status;

  // Outputs
  wire [7:0]  io_recovered_tx_data;
  wire        io_recovered_tx_error;

  // DUT instantiation with bitwise connections
  Descrambler dut (
    .clock(clock),
    .reset(reset),
    .io_tx_enable(io_tx_enable),
    .io_scn_0(io_scn[0]),
    .io_scn_1(io_scn[1]),
    .io_scn_2(io_scn[2]),
    .io_scn_3(io_scn[3]),
    .io_scn_4(io_scn[4]),
    .io_scn_5(io_scn[5]),
    .io_scn_6(io_scn[6]),
    .io_scn_7(io_scn[7]),
    .io_sdn_0(io_sdn[0]),
    .io_sdn_1(io_sdn[1]),
    .io_sdn_2(io_sdn[2]),
    .io_sdn_3(io_sdn[3]),
    .io_sdn_4(io_sdn[4]),
    .io_sdn_5(io_sdn[5]),
    .io_sdn_6(io_sdn[6]),
    .io_sdn_7(io_sdn[7]),
    .io_sdn_8(io_sdn[8]),
    .io_loc_rcvr_status(io_loc_rcvr_status),
    .io_recovered_tx_data(io_recovered_tx_data),
    .io_recovered_tx_error(io_recovered_tx_error)
  );

  // Clock generation
  initial clock = 0;
  always #(CLOCK_PERIOD/2) clock = ~clock;

  integer infile, outfile, r;
  reg [255:0] line;

  initial begin
    $dumpfile("descrambler.vcd");
    $dumpvars(0, descrambler_tb);

    // Reset and initial inputs
    reset = 1;
    io_tx_enable = 0;
    io_scn = 8'd0;
    io_sdn = 9'd0;
    io_loc_rcvr_status = 0;

    infile = $fopen("descrambler_input.txt", "r");
    if (!infile) begin
      $display("ERROR: Could not open descrambler_input.txt");
      $finish;
    end

    outfile = $fopen("descrambler_output.txt", "w");
    if (!outfile) begin
      $display("ERROR: Could not open descrambler_output.txt");
      $finish;
    end

    // Apply reset
    repeat (2) @(posedge clock);
    reset = 0;

    // Read each line from input file and apply inputs
    while (!$feof(infile)) begin
      r = $fgets(line, infile);
      if (r) begin
        // r = $sscanf(line, "%b %b %b %b",
        //   io_tx_enable,
        //   io_scn[7], io_scn[6], io_scn[5], io_scn[4], io_scn[3], io_scn[2], io_scn[1], io_scn[0],
        //   io_sdn[8], io_sdn[7], io_sdn[6], io_sdn[5], io_sdn[4], io_sdn[3], io_sdn[2], io_sdn[1], io_sdn[0],
        //   io_loc_rcvr_status
        // );
        r = $sscanf(line, "%b %b %b %b",
          io_tx_enable,
          io_scn, io_sdn,
          io_loc_rcvr_status
        );
        @(posedge clock);

        $fwrite(outfile, "Time = %0t ns | TX_EN = %b | SCN = %b | SDN = %b | LOC_STATUS = %b | Decoded = 0x%0d | Error = %b\n",
          $time, io_tx_enable, io_scn, io_sdn, io_loc_rcvr_status,
          io_recovered_tx_data, io_recovered_tx_error
        );
      end
    end

    $fclose(infile);
    $fclose(outfile);
    $finish;
  end

endmodule