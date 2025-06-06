// Generated by CIRCT unknown git version
// `include "/scratch/eecs251b-abg/base_tx_encode/FirFilter.sv"
`include "/scratch/eecs251b-aac/base_tx_encode/FirFilter.sv"

// Users can define 'PRINTF_COND' to add an extra gate to prints.
`ifndef PRINTF_COND_
  `ifdef PRINTF_COND
    `define PRINTF_COND_ (`PRINTF_COND)
  `else  // PRINTF_COND
    `define PRINTF_COND_ 1
  `endif // PRINTF_COND
`endif // not def PRINTF_COND_

// Include register initializers in init blocks unless synthesis is set
`ifndef RANDOMIZE
  `ifdef RANDOMIZE_REG_INIT
    `define RANDOMIZE
  `endif // RANDOMIZE_REG_INIT
`endif // not def RANDOMIZE
`ifndef SYNTHESIS
  `ifndef ENABLE_INITIAL_REG_
    `define ENABLE_INITIAL_REG_
  `endif // not def ENABLE_INITIAL_REG_
`endif // not def SYNTHESIS

// Standard header to adapt well known macros for register randomization.

// RANDOM may be set to an expression that produces a 32-bit random unsigned value.
`ifndef RANDOM
  `define RANDOM $random
`endif // not def RANDOM

// Users can define INIT_RANDOM as general code that gets injected into the
// initializer block for modules with registers.
`ifndef INIT_RANDOM
  `define INIT_RANDOM
`endif // not def INIT_RANDOM

// If using random initialization, you can also define RANDOMIZE_DELAY to
// customize the delay used, otherwise 0.002 is used.
`ifndef RANDOMIZE_DELAY
  `define RANDOMIZE_DELAY 0.002
`endif // not def RANDOMIZE_DELAY

// Define INIT_RANDOM_PROLOG_ for use in our modules below.
`ifndef INIT_RANDOM_PROLOG_
  `ifdef RANDOMIZE
    `ifdef VERILATOR
      `define INIT_RANDOM_PROLOG_ `INIT_RANDOM
    `else  // VERILATOR
      `define INIT_RANDOM_PROLOG_ `INIT_RANDOM #`RANDOMIZE_DELAY begin end
    `endif // VERILATOR
  `else  // RANDOMIZE
    `define INIT_RANDOM_PROLOG_
  `endif // RANDOMIZE
`endif // not def INIT_RANDOM_PROLOG_
module FFE(	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
  input         clock,	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
  input         reset,	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
  output        auto_reg_in_a_ready,	// @[generators/diplomacy/diplomacy/src/diplomacy/lazymodule/LazyModuleImp.scala:106:25]
  input         auto_reg_in_a_valid,	// @[generators/diplomacy/diplomacy/src/diplomacy/lazymodule/LazyModuleImp.scala:106:25]
  input  [2:0]  auto_reg_in_a_bits_opcode,	// @[generators/diplomacy/diplomacy/src/diplomacy/lazymodule/LazyModuleImp.scala:106:25]
  input  [2:0]  auto_reg_in_a_bits_param,	// @[generators/diplomacy/diplomacy/src/diplomacy/lazymodule/LazyModuleImp.scala:106:25]
  input  [1:0]  auto_reg_in_a_bits_size,	// @[generators/diplomacy/diplomacy/src/diplomacy/lazymodule/LazyModuleImp.scala:106:25]
  input  [2:0]  auto_reg_in_a_bits_source,	// @[generators/diplomacy/diplomacy/src/diplomacy/lazymodule/LazyModuleImp.scala:106:25]
  input  [12:0] auto_reg_in_a_bits_address,	// @[generators/diplomacy/diplomacy/src/diplomacy/lazymodule/LazyModuleImp.scala:106:25]
  input  [7:0]  auto_reg_in_a_bits_mask,	// @[generators/diplomacy/diplomacy/src/diplomacy/lazymodule/LazyModuleImp.scala:106:25]
  input  [63:0] auto_reg_in_a_bits_data,	// @[generators/diplomacy/diplomacy/src/diplomacy/lazymodule/LazyModuleImp.scala:106:25]
  input         auto_reg_in_a_bits_corrupt,	// @[generators/diplomacy/diplomacy/src/diplomacy/lazymodule/LazyModuleImp.scala:106:25]
  input         auto_reg_in_d_ready,	// @[generators/diplomacy/diplomacy/src/diplomacy/lazymodule/LazyModuleImp.scala:106:25]
  output        auto_reg_in_d_valid,	// @[generators/diplomacy/diplomacy/src/diplomacy/lazymodule/LazyModuleImp.scala:106:25]
  output [2:0]  auto_reg_in_d_bits_opcode,	// @[generators/diplomacy/diplomacy/src/diplomacy/lazymodule/LazyModuleImp.scala:106:25]
  output [1:0]  auto_reg_in_d_bits_size,	// @[generators/diplomacy/diplomacy/src/diplomacy/lazymodule/LazyModuleImp.scala:106:25]
  output [2:0]  auto_reg_in_d_bits_source,	// @[generators/diplomacy/diplomacy/src/diplomacy/lazymodule/LazyModuleImp.scala:106:25]
  input         io_in_valid,	// @[generators/chipyard/src/main/scala/FFE.scala:111:16]
  input  [7:0]  io_in_bits_0,	// @[generators/chipyard/src/main/scala/FFE.scala:111:16]
  input  [7:0]  io_in_bits_1,	// @[generators/chipyard/src/main/scala/FFE.scala:111:16]
  input  [7:0]  io_in_bits_2,	// @[generators/chipyard/src/main/scala/FFE.scala:111:16]
  input  [7:0]  io_in_bits_3,	// @[generators/chipyard/src/main/scala/FFE.scala:111:16]
  output        io_out_valid,	// @[generators/chipyard/src/main/scala/FFE.scala:111:16]
  output [7:0]  io_out_bits_0,	// @[generators/chipyard/src/main/scala/FFE.scala:111:16]
  output [7:0]  io_out_bits_1,	// @[generators/chipyard/src/main/scala/FFE.scala:111:16]
  output [7:0]  io_out_bits_2,	// @[generators/chipyard/src/main/scala/FFE.scala:111:16]
  output [7:0]  io_out_bits_3	// @[generators/chipyard/src/main/scala/FFE.scala:111:16]
);

  wire       out_woready_6;	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
  reg  [7:0] weightRegs_0;	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
  reg  [7:0] weightRegs_1;	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
  reg  [7:0] weightRegs_2;	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
  reg  [7:0] weightRegs_3;	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
  reg  [7:0] weightRegs_4;	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
  reg  [7:0] weightRegs_5;	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
  reg  [7:0] weightRegs_6;	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
  wire       in_bits_read = auto_reg_in_a_bits_opcode == 3'h4;	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:74:36]
  wire       out_f_woready = out_woready_6 & auto_reg_in_a_bits_mask[0];	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
  wire       out_f_woready_1 = out_woready_6 & auto_reg_in_a_bits_mask[1];	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
  wire       out_f_woready_2 = out_woready_6 & auto_reg_in_a_bits_mask[2];	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
  wire       out_f_woready_3 = out_woready_6 & auto_reg_in_a_bits_mask[3];	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
  wire       out_f_woready_4 = out_woready_6 & auto_reg_in_a_bits_mask[4];	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
  wire       out_f_woready_5 = out_woready_6 & auto_reg_in_a_bits_mask[5];	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
  wire       out_f_woready_6 = out_woready_6 & auto_reg_in_a_bits_mask[6];	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
  `ifndef SYNTHESIS	// @[generators/chipyard/src/main/scala/FFE.scala:122:17]
    always @(posedge clock) begin	// @[generators/chipyard/src/main/scala/FFE.scala:122:17]
      if ((`PRINTF_COND_) & out_f_woready & ~reset)	// @[generators/chipyard/src/main/scala/FFE.scala:122:17, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
        $fwrite(32'h80000002, "ffe tap %d set to %d\n", 1'h0, auto_reg_in_a_bits_data[7:0]);	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :122:17, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
      if ((`PRINTF_COND_) & out_f_woready_1 & ~reset)	// @[generators/chipyard/src/main/scala/FFE.scala:122:17, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
        $fwrite(32'h80000002, "ffe tap %d set to %d\n", 1'h1, auto_reg_in_a_bits_data[15:8]);	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :122:17, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
      if ((`PRINTF_COND_) & out_f_woready_2 & ~reset)	// @[generators/chipyard/src/main/scala/FFE.scala:122:17, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
        $fwrite(32'h80000002, "ffe tap %d set to %d\n", 2'h2, auto_reg_in_a_bits_data[23:16]);	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :122:17, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
      if ((`PRINTF_COND_) & out_f_woready_3 & ~reset)	// @[generators/chipyard/src/main/scala/FFE.scala:122:17, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
        $fwrite(32'h80000002, "ffe tap %d set to %d\n", 2'h3, auto_reg_in_a_bits_data[31:24]);	// @[generators/chipyard/src/main/scala/FFE.scala:122:17, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
      if ((`PRINTF_COND_) & out_f_woready_4 & ~reset)	// @[generators/chipyard/src/main/scala/FFE.scala:122:17, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
        $fwrite(32'h80000002, "ffe tap %d set to %d\n", 3'h4, auto_reg_in_a_bits_data[39:32]);	// @[generators/chipyard/src/main/scala/FFE.scala:122:17, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
      if ((`PRINTF_COND_) & out_f_woready_5 & ~reset)	// @[generators/chipyard/src/main/scala/FFE.scala:122:17, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
        $fwrite(32'h80000002, "ffe tap %d set to %d\n", 3'h5, auto_reg_in_a_bits_data[47:40]);	// @[generators/chipyard/src/main/scala/FFE.scala:122:17, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
      if ((`PRINTF_COND_) & out_f_woready_6 & ~reset)	// @[generators/chipyard/src/main/scala/FFE.scala:122:17, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
        $fwrite(32'h80000002, "ffe tap %d set to %d\n", 3'h6, auto_reg_in_a_bits_data[55:48]);	// @[generators/chipyard/src/main/scala/FFE.scala:122:17, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
    end // always @(posedge)
  `endif // not def SYNTHESIS
  assign out_woready_6 = auto_reg_in_a_valid & auto_reg_in_d_ready & ~in_bits_read & auto_reg_in_a_bits_address[7:3] == 5'h0;	// @[generators/rocket-chip/src/main/scala/tilelink/Edges.scala:192:34, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:74:36, :75:19, :87:24]
  wire [2:0] regNodeIn_d_bits_opcode = {2'h0, in_bits_read};	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:74:36, :105:19]
  reg        io_out_valid_REG;	// @[generators/chipyard/src/main/scala/FFE.scala:145:100]
  reg        io_out_valid_REG_1;	// @[generators/chipyard/src/main/scala/FFE.scala:145:100]
  reg        io_out_valid_REG_2;	// @[generators/chipyard/src/main/scala/FFE.scala:145:100]
  reg        io_out_valid_REG_3;	// @[generators/chipyard/src/main/scala/FFE.scala:145:100]
  reg        io_out_valid_REG_4;	// @[generators/chipyard/src/main/scala/FFE.scala:145:100]
  reg        io_out_valid_REG_5;	// @[generators/chipyard/src/main/scala/FFE.scala:145:100]
  reg        io_out_valid_REG_6;	// @[generators/chipyard/src/main/scala/FFE.scala:145:100]
  always @(posedge clock) begin	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
    if (reset) begin	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
      weightRegs_0 <= 8'hFE;	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
      weightRegs_1 <= 8'd4;	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
      weightRegs_2 <= 8'd127;	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
      weightRegs_3 <= 8'hB5;	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
      weightRegs_4 <= 8'd47;	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
      weightRegs_5 <= 8'hF6;	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
      weightRegs_6 <= 8'd2;	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    end
    else begin	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
      if (out_f_woready)	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
        weightRegs_0 <= auto_reg_in_a_bits_data[7:0];	// @[generators/chipyard/src/main/scala/FFE.scala:118:57, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
      if (out_f_woready_1)	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
        weightRegs_1 <= auto_reg_in_a_bits_data[15:8];	// @[generators/chipyard/src/main/scala/FFE.scala:118:57, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
      if (out_f_woready_2)	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
        weightRegs_2 <= auto_reg_in_a_bits_data[23:16];	// @[generators/chipyard/src/main/scala/FFE.scala:118:57, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
      if (out_f_woready_3)	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
        weightRegs_3 <= auto_reg_in_a_bits_data[31:24];	// @[generators/chipyard/src/main/scala/FFE.scala:118:57, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
      if (out_f_woready_4)	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
        weightRegs_4 <= auto_reg_in_a_bits_data[39:32];	// @[generators/chipyard/src/main/scala/FFE.scala:118:57, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
      if (out_f_woready_5)	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
        weightRegs_5 <= auto_reg_in_a_bits_data[47:40];	// @[generators/chipyard/src/main/scala/FFE.scala:118:57, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
      if (out_f_woready_6)	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
        weightRegs_6 <= auto_reg_in_a_bits_data[55:48];	// @[generators/chipyard/src/main/scala/FFE.scala:118:57, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:87:24]
    end
    io_out_valid_REG <= io_in_valid;	// @[generators/chipyard/src/main/scala/FFE.scala:145:100]
    io_out_valid_REG_1 <= io_out_valid_REG;	// @[generators/chipyard/src/main/scala/FFE.scala:145:100]
    io_out_valid_REG_2 <= io_out_valid_REG_1;	// @[generators/chipyard/src/main/scala/FFE.scala:145:100]
    io_out_valid_REG_3 <= io_out_valid_REG_2;	// @[generators/chipyard/src/main/scala/FFE.scala:145:100]
    io_out_valid_REG_4 <= io_out_valid_REG_3;	// @[generators/chipyard/src/main/scala/FFE.scala:145:100]
    io_out_valid_REG_5 <= io_out_valid_REG_4;	// @[generators/chipyard/src/main/scala/FFE.scala:145:100]
    io_out_valid_REG_6 <= io_out_valid_REG_5;	// @[generators/chipyard/src/main/scala/FFE.scala:145:100]
  end // always @(posedge)
  `ifdef ENABLE_INITIAL_REG_	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
    `ifdef RTL_BEFORE_INITIAL	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
      `FIRRTL_BEFORE_INITIAL	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
    `endif // FIRRTL_BEFORE_INITIAL
    logic [31:0] _RANDOM[0:1];	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
    initial begin	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
      `ifdef INIT_RANDOM_PROLOG_	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
        `INIT_RANDOM_PROLOG_	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
      `endif // INIT_RANDOM_PROLOG_
      `ifdef RANDOMIZE_REG_INIT	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
        for (logic [1:0] i = 2'h0; i < 2'h2; i += 2'h1) begin
          _RANDOM[i[0]] = `RANDOM;	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
        end	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
        weightRegs_0 = _RANDOM[1'h0][7:0];	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :118:57]
        weightRegs_1 = _RANDOM[1'h0][15:8];	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :118:57]
        weightRegs_2 = _RANDOM[1'h0][23:16];	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :118:57]
        weightRegs_3 = _RANDOM[1'h0][31:24];	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :118:57]
        weightRegs_4 = _RANDOM[1'h1][7:0];	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :118:57]
        weightRegs_5 = _RANDOM[1'h1][15:8];	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :118:57]
        weightRegs_6 = _RANDOM[1'h1][23:16];	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :118:57]
        io_out_valid_REG = _RANDOM[1'h1][24];	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :118:57, :145:100]
        io_out_valid_REG_1 = _RANDOM[1'h1][25];	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :118:57, :145:100]
        io_out_valid_REG_2 = _RANDOM[1'h1][26];	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :118:57, :145:100]
        io_out_valid_REG_3 = _RANDOM[1'h1][27];	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :118:57, :145:100]
        io_out_valid_REG_4 = _RANDOM[1'h1][28];	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :118:57, :145:100]
        io_out_valid_REG_5 = _RANDOM[1'h1][29];	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :118:57, :145:100]
        io_out_valid_REG_6 = _RANDOM[1'h1][30];	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :118:57, :145:100]
      `endif // RANDOMIZE_REG_INIT
    end // initial
    `ifdef FIRRTL_AFTER_INITIAL	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
      `FIRRTL_AFTER_INITIAL	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
    `endif // FIRRTL_AFTER_INITIAL
  `endif // ENABLE_INITIAL_REG_
  // TLMonitor monitor (	// @[generators/rocket-chip/src/main/scala/tilelink/Nodes.scala:27:25]
  //   .clock                (clock),
  //   .reset                (reset),
  //   .io_in_a_ready        (auto_reg_in_d_ready),
  //   .io_in_a_valid        (auto_reg_in_a_valid),
  //   .io_in_a_bits_opcode  (auto_reg_in_a_bits_opcode),
  //   .io_in_a_bits_param   (auto_reg_in_a_bits_param),
  //   .io_in_a_bits_size    (auto_reg_in_a_bits_size),
  //   .io_in_a_bits_source  (auto_reg_in_a_bits_source),
  //   .io_in_a_bits_address (auto_reg_in_a_bits_address),
  //   .io_in_a_bits_mask    (auto_reg_in_a_bits_mask),
  //   .io_in_a_bits_corrupt (auto_reg_in_a_bits_corrupt),
  //   .io_in_d_ready        (auto_reg_in_d_ready),
  //   .io_in_d_valid        (auto_reg_in_a_valid),
  //   .io_in_d_bits_opcode  (regNodeIn_d_bits_opcode),	// @[generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:105:19]
  //   .io_in_d_bits_size    (auto_reg_in_a_bits_size),
  //   .io_in_d_bits_source  (auto_reg_in_a_bits_source)
  // );	// @[generators/rocket-chip/src/main/scala/tilelink/Nodes.scala:27:25]
  FirFilter _firFilters_0 (	// @[generators/chipyard/src/main/scala/FFE.scala:136:29]
    .clock        (clock),
    .io_in        (io_in_bits_0),
    .io_weights_0 (weightRegs_0),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_1 (weightRegs_1),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_2 (weightRegs_2),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_3 (weightRegs_3),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_4 (weightRegs_4),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_5 (weightRegs_5),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_6 (weightRegs_6),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_out       (io_out_bits_0)
  );	// @[generators/chipyard/src/main/scala/FFE.scala:136:29]
  FirFilter _firFilters_1 (	// @[generators/chipyard/src/main/scala/FFE.scala:136:29]
    .clock        (clock),
    .io_in        (io_in_bits_1),
    .io_weights_0 (weightRegs_0),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_1 (weightRegs_1),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_2 (weightRegs_2),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_3 (weightRegs_3),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_4 (weightRegs_4),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_5 (weightRegs_5),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_6 (weightRegs_6),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_out       (io_out_bits_1)
  );	// @[generators/chipyard/src/main/scala/FFE.scala:136:29]
  FirFilter _firFilters_2 (	// @[generators/chipyard/src/main/scala/FFE.scala:136:29]
    .clock        (clock),
    .io_in        (io_in_bits_2),
    .io_weights_0 (weightRegs_0),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_1 (weightRegs_1),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_2 (weightRegs_2),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_3 (weightRegs_3),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_4 (weightRegs_4),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_5 (weightRegs_5),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_6 (weightRegs_6),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_out       (io_out_bits_2)
  );	// @[generators/chipyard/src/main/scala/FFE.scala:136:29]
  FirFilter _firFilters_3 (	// @[generators/chipyard/src/main/scala/FFE.scala:136:29]
    .clock        (clock),
    .io_in        (io_in_bits_3),
    .io_weights_0 (weightRegs_0),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_1 (weightRegs_1),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_2 (weightRegs_2),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_3 (weightRegs_3),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_4 (weightRegs_4),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_5 (weightRegs_5),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_weights_6 (weightRegs_6),	// @[generators/chipyard/src/main/scala/FFE.scala:118:57]
    .io_out       (io_out_bits_3)
  );	// @[generators/chipyard/src/main/scala/FFE.scala:136:29]
  assign auto_reg_in_a_ready = auto_reg_in_d_ready;	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
  assign auto_reg_in_d_valid = auto_reg_in_a_valid;	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
  assign auto_reg_in_d_bits_opcode = regNodeIn_d_bits_opcode;	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, generators/rocket-chip/src/main/scala/tilelink/RegisterRouter.scala:105:19]
  assign auto_reg_in_d_bits_size = auto_reg_in_a_bits_size;	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
  assign auto_reg_in_d_bits_source = auto_reg_in_a_bits_source;	// @[generators/chipyard/src/main/scala/FFE.scala:110:9]
  assign io_out_valid = io_in_valid & io_out_valid_REG_6;	// @[generators/chipyard/src/main/scala/FFE.scala:110:9, :145:{33,100}]
endmodule

