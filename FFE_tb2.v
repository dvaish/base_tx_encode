`timescale 1ns/1ps

module FFE_tb;

  // Clock and reset
  logic clock;
  logic reset;

  // TileLink-like register interface (write)
  logic        auto_reg_in_a_valid;
  logic [2:0]  auto_reg_in_a_bits_opcode;
  logic [2:0]  auto_reg_in_a_bits_param;
  logic [1:0]  auto_reg_in_a_bits_size;
  logic [2:0]  auto_reg_in_a_bits_source;
  logic [12:0] auto_reg_in_a_bits_address;
  logic [7:0]  auto_reg_in_a_bits_mask;
  logic [63:0] auto_reg_in_a_bits_data;
  logic        auto_reg_in_a_bits_corrupt;
  logic        auto_reg_in_d_ready;
  wire         auto_reg_in_a_ready;
  wire         auto_reg_in_d_valid;
  wire [2:0]   auto_reg_in_d_bits_opcode;
  wire [1:0]   auto_reg_in_d_bits_size;
  wire [2:0]   auto_reg_in_d_bits_source;

  // Data I/O interface
  logic        io_in_valid;
  logic [7:0]  io_in_bits_0, io_in_bits_1, io_in_bits_2, io_in_bits_3;
  wire         io_out_valid;
  wire [7:0]   io_out_bits_0, io_out_bits_1, io_out_bits_2, io_out_bits_3;

  // Instantiate DUT
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

  // Clock generation
  always #5 clock = ~clock;

  task write_ffetaps(input [63:0] data, input [7:0] mask);
    begin
      @(posedge clock);
      auto_reg_in_a_valid <= 1;
      auto_reg_in_a_bits_opcode <= 3'b0; // assuming 0 = write
      auto_reg_in_a_bits_mask <= mask;
      auto_reg_in_a_bits_data <= data;
      auto_reg_in_a_bits_address <= 13'h000;
      auto_reg_in_a_bits_size <= 2'b11;
      auto_reg_in_a_bits_param <= 3'b0;
      auto_reg_in_a_bits_source <= 3'b000;
      auto_reg_in_a_bits_corrupt <= 0;
      @(posedge clock);
      auto_reg_in_a_valid <= 0;
      @(posedge clock);
    end
  endtask

  task send_input(input [7:0] b0, b1, b2, b3);
    begin
      @(posedge clock);
      io_in_valid <= 1;
      io_in_bits_0 <= b0;
      io_in_bits_1 <= b1;
      io_in_bits_2 <= b2;
      io_in_bits_3 <= b3;
      @(posedge clock);
      io_in_valid <= 0;
    end
  endtask

  initial begin
    // Init
    clock = 0;
    reset = 1;
    auto_reg_in_a_valid = 0;
    auto_reg_in_d_ready = 1;
    io_in_valid = 0;

    // Reset sequence
    repeat (5) @(posedge clock);
    reset = 0;

    // Write FFE tap weights: mask bits 0–3 for 4 taps (example values)
    write_ffetaps(64'h04030201deadbeef, 8'b00001111);

    // Send input data
    send_input(8'h10, 8'h20, 8'h30, 8'h40);

    // Wait and observe
    repeat (10) @(posedge clock);

    // Print result
    if (io_out_valid) begin
      $display("Output: %02x %02x %02x %02x",
        io_out_bits_0, io_out_bits_1, io_out_bits_2, io_out_bits_3);
    end else begin
      $display("No output valid.");
    end

    $finish;
  end
endmodule
