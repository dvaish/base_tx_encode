module FFE_Decoder (
  input         clock,
  input         reset,

  // TileLink interface for FFE register control (can be stubbed or connected)
  // input         auto_reg_in_a_valid,
  // input  [2:0]  auto_reg_in_a_bits_opcode,
  // input  [2:0]  auto_reg_in_a_bits_param,
  // input  [1:0]  auto_reg_in_a_bits_size,
  // input  [2:0]  auto_reg_in_a_bits_source,
  // input  [12:0] auto_reg_in_a_bits_address,
  // input  [7:0]  auto_reg_in_a_bits_mask,
  // input  [63:0] auto_reg_in_a_bits_data,
  // input         auto_reg_in_a_bits_corrupt,
  input         auto_reg_in_d_ready,
  output        auto_reg_in_a_ready,
  output        auto_reg_in_d_valid,
  output [2:0]  auto_reg_in_d_bits_opcode,
  output [1:0]  auto_reg_in_d_bits_size,
  output [2:0]  auto_reg_in_d_bits_source,
  input  [7:0]  io_in_bits_0,
  input  [7:0]  io_in_bits_1,	
  input  [7:0]  io_in_bits_2,	
  input  [7:0]  io_in_bits_3,
  // LaPDFD tap values (external input)
  input  [7:0]  io_taps_0,
  input  [7:0]  io_taps_1,
  input  [7:0]  io_taps_2,
  input  [7:0]  io_taps_3,
  input  [7:0]  io_taps_4,
  input  [7:0]  io_taps_5,
  input  [7:0]  io_taps_6,
  input  [7:0]  io_taps_7,
  input  [7:0]  io_taps_8,
  input  [7:0]  io_taps_9,
  input  [7:0]  io_taps_10,
  input  [7:0]  io_taps_11,
  input  [7:0]  io_taps_12,
  input  [7:0]  io_taps_13,

  // Final LaPDFD output
  output [11:0] io_rxSymbols,
  output        io_rxValid
);

  // Intermediate valid signal from FFE to LaPDFD
  wire         ffe_out_valid;
  wire  [7:0]  ffe_out_0, ffe_out_1, ffe_out_2, ffe_out_3;

  // Instantiate FFE
  FFE ffe_inst (
    .clock(clock),
    .reset(reset),
    .auto_reg_in_a_ready(0),
    .auto_reg_in_a_valid(0),
    .auto_reg_in_a_bits_opcode(0),
    .auto_reg_in_a_bits_param(0),
    .auto_reg_in_a_bits_size(0),
    .auto_reg_in_a_bits_source(0),
    .auto_reg_in_a_bits_address(0),
    .auto_reg_in_a_bits_mask(0),
    .auto_reg_in_a_bits_data(0),
    .auto_reg_in_a_bits_corrupt(auto_reg_in_a_bits_corrupt),
    .auto_reg_in_d_ready(auto_reg_in_d_ready),
    .auto_reg_in_d_valid(auto_reg_in_d_valid),
    .auto_reg_in_d_bits_opcode(auto_reg_in_d_bits_opcode),
    .auto_reg_in_d_bits_size(auto_reg_in_d_bits_size),
    .auto_reg_in_d_bits_source(auto_reg_in_d_bits_source),

    .io_in_valid(1'b1),  // Need to fix
    .io_in_bits_0(8'h00),
    .io_in_bits_1(8'h00),
    .io_in_bits_2(8'h00),
    .io_in_bits_3(8'h00),

    .io_out_valid(ffe_out_valid),
    .io_out_bits_0(ffe_out_0),
    .io_out_bits_1(ffe_out_1),
    .io_out_bits_2(ffe_out_2),
    .io_out_bits_3(ffe_out_3)
  );

  // Instantiate LaPDFD
  LaPDFD lapdfd_inst (
    .clock(clock),
    .reset(reset),
    .io_rxSamples_0(ffe_out_0),
    .io_rxSamples_1(ffe_out_1),
    .io_rxSamples_2(ffe_out_2),
    .io_rxSamples_3(ffe_out_3),
    .io_taps_0(io_taps_0),
    .io_taps_1(io_taps_1),
    .io_taps_2(io_taps_2),
    .io_taps_3(io_taps_3),
    .io_taps_4(io_taps_4),
    .io_taps_5(io_taps_5),
    .io_taps_6(io_taps_6),
    .io_taps_7(io_taps_7),
    .io_taps_8(io_taps_8),
    .io_taps_9(io_taps_9),
    .io_taps_10(io_taps_10),
    .io_taps_11(io_taps_11),
    .io_taps_12(io_taps_12),
    .io_taps_13(io_taps_13),
    .io_rxSymbols(io_rxSymbols),
    .io_rxValid(io_rxValid)
  );

endmodule
