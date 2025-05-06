`timescale 1ns/1ps
`include "/scratch/eecs251b-abg/base_tx_encode/FFE.sv"
`include "/scratch/eecs251b-abg/base_tx_encode/LaPDFD.sv"

module FFE_Decoder (
    input         clock,
    input         reset,
    // FFE module I/Os
    input         io_in_valid,
    input  [7:0]  io_in_bits_0,
    input  [7:0]  io_in_bits_1,
    input  [7:0]  io_in_bits_2,
    input  [7:0]  io_in_bits_3,
    output        io_out_valid,
    output [7:0]  io_out_bits_0,
    output [7:0]  io_out_bits_1,
    output [7:0]  io_out_bits_2,
    output [7:0]  io_out_bits_3,
    // LaPDFD module I/Os
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
    output [11:0] io_rxSymbols,
    output        io_rxValid
);

  // Internal signals for connecting FFE and LaPDFD
  wire ffe_io_out_valid;
  wire [7:0] ffe_io_out_bits_0;
  wire [7:0] ffe_io_out_bits_1;
  wire [7:0] ffe_io_out_bits_2;
  wire [7:0] ffe_io_out_bits_3;
  
  wire [7:0] laPdfd_io_rxSamples_0;
  wire [7:0] laPdfd_io_rxSamples_1;
  wire [7:0] laPdfd_io_rxSamples_2;
  wire [7:0] laPdfd_io_rxSamples_3;
  
  // Instantiate FFE Module
  FFE ffe_inst (
    .clock(clock),
    .reset(reset),
    .io_in_valid(io_in_valid),
    .io_in_bits_0(io_in_bits_0),
    .io_in_bits_1(io_in_bits_1),
    .io_in_bits_2(io_in_bits_2),
    .io_in_bits_3(io_in_bits_3),
    .io_out_valid(ffe_io_out_valid),
    .io_out_bits_0(ffe_io_out_bits_0),
    .io_out_bits_1(ffe_io_out_bits_1),
    .io_out_bits_2(ffe_io_out_bits_2),
    .io_out_bits_3(ffe_io_out_bits_3)
  );

  // Assign FFE output to LaPDFD input signals
  assign laPdfd_io_rxSamples_0 = ffe_io_out_bits_0;
  assign laPdfd_io_rxSamples_1 = ffe_io_out_bits_1;
  assign laPdfd_io_rxSamples_2 = ffe_io_out_bits_2;
  assign laPdfd_io_rxSamples_3 = ffe_io_out_bits_3;

  // Instantiate LaPDFD Module
  LaPDFD lapdfd_inst (
    .clock(clock),
    .reset(reset),
    .io_rxSamples_0(laPdfd_io_rxSamples_0),
    .io_rxSamples_1(laPdfd_io_rxSamples_1),
    .io_rxSamples_2(laPdfd_io_rxSamples_2),
    .io_rxSamples_3(laPdfd_io_rxSamples_3),
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

  // Connect the outputs to the overall module outputs
  assign io_out_valid = ffe_io_out_valid;
  assign io_out_bits_0 = ffe_io_out_bits_0;
  assign io_out_bits_1 = ffe_io_out_bits_1;
  assign io_out_bits_2 = ffe_io_out_bits_2;
  assign io_out_bits_3 = ffe_io_out_bits_3;

endmodule
