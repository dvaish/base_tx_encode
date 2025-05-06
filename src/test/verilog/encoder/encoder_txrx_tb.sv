`timescale 1ns/10ps
`include "Encoder_TXRX_SM.sv"  // Ensure this matches your file/module name

module encoder_txrx_tb;

  parameter CLOCK_PERIOD = 8;

  reg         clock;
  reg         reset;

  // TX inputs
  reg         io_tx_enable;
  reg         io_tx_mode;
  reg         io_tx_error;
  reg [7:0]   io_txd;
  reg         io_symb_timer_done;

  // Encoder inputs
  reg [31:0]  io_n;
  reg [31:0]  io_n0;
  reg         io_loc_rcvr_status;

  // RX inputs (for completeness; inactive in this TX-only test)
  reg         io_rx_symb_vector_valid;
  reg [2:0]   io_rx_symb_vector_bits_0;
  reg [2:0]   io_rx_symb_vector_bits_1;
  reg [2:0]   io_rx_symb_vector_bits_2;
  reg [2:0]   io_rx_symb_vector_bits_3;
  reg [7:0]   io_decoded_rx_symb_vector;
  reg         io_pcs_reset;
  reg [7:0] tx_data_seq[0:3];
  integer i;
  // Outputs
  wire [7:0]  io_rxd;
  wire        io_rx_dv, io_rx_er, io_rxerror_status;
  wire        io_rx_symb_vector_ready;
  wire        io_col;
  wire        io_tx_symb_vector_valid;
  reg        io_tx_symb_vector_ready;
  wire [2:0]  io_tx_symb_vector_bits_0;
  wire [2:0]  io_tx_symb_vector_bits_1;
  wire [2:0]  io_tx_symb_vector_bits_2;
  wire [2:0]  io_tx_symb_vector_bits_3;

  // Clock generation
  initial clock = 0;
  always #(CLOCK_PERIOD/2) clock = ~clock;

  // Increment `n` every cycle
  always @(posedge clock) begin
    io_n <= io_n + 1;
  end

  // DUT instantiation
  Encoder_TXRX_SM dut (
    .clock(clock),
    .reset(reset),
    .io_tx_enable(io_tx_enable),
    .io_tx_mode(io_tx_mode),
    .io_tx_error(io_tx_error),
    .io_txd(io_txd),
    .io_symb_timer_done(io_symb_timer_done),
    .io_n(io_n),
    .io_n0(io_n0),
    .io_loc_rcvr_status(io_loc_rcvr_status),
    .io_rx_symb_vector_valid(io_rx_symb_vector_valid),
    .io_rx_symb_vector_bits_0(io_rx_symb_vector_bits_0),
    .io_rx_symb_vector_bits_1(io_rx_symb_vector_bits_1),
    .io_rx_symb_vector_bits_2(io_rx_symb_vector_bits_2),
    .io_rx_symb_vector_bits_3(io_rx_symb_vector_bits_3),
    .io_decoded_rx_symb_vector(io_decoded_rx_symb_vector),
    .io_pcs_reset(io_pcs_reset),
    .io_rxd(io_rxd),
    .io_rx_dv(io_rx_dv),
    .io_rx_er(io_rx_er),
    .io_rxerror_status(io_rxerror_status),
    .io_rx_symb_vector_ready(io_rx_symb_vector_ready),
    .io_col(io_col),
    .io_tx_symb_vector_ready(io_tx_symb_vector_ready),  // Always ready to receive
    .io_tx_symb_vector_valid(io_tx_symb_vector_valid),
    .io_tx_symb_vector_bits_0(io_tx_symb_vector_bits_0),
    .io_tx_symb_vector_bits_1(io_tx_symb_vector_bits_1),
    .io_tx_symb_vector_bits_2(io_tx_symb_vector_bits_2),
    .io_tx_symb_vector_bits_3(io_tx_symb_vector_bits_3)
  );

  task test_RESET();
    reset <= 1;
    io_pcs_reset <= 1;
    repeat (2) @(posedge clock);
    reset <= 0;
    io_pcs_reset <= 0;
    
    // repeat (2) @(posedge clock);
  endtask

  task test_NORMAL_TX();
    test_RESET();

    io_tx_enable        <= 0;
    io_tx_mode          <= 0;
    io_tx_error         <= 0;
    io_symb_timer_done  <= 0;

    // TX input data sequence
    
    tx_data_seq[0] = 8'h00;
    tx_data_seq[1] = 8'h01;
    tx_data_seq[2] = 8'h02;
    tx_data_seq[3] = 8'h03;

    
    for (i = 0; i < 256+3; i = i + 1) begin
      io_tx_enable        <= 1;
      if (i < 3)
        io_txd <= 8'b0;
      else
        io_txd <= (i-3); // tx_data_seq[i%4];
      io_tx_symb_vector_ready <= 1;
      @(posedge clock);

      if (io_tx_symb_vector_valid) begin
        $fwrite(outfile, "Cycle %0t ns | TXD = 0x%0h | Encoded => A = %d, B = %d, C = %d, D = %d\n",
          $time, io_txd,
          $signed(dut.io_tx_symb_vector_bits_0),
          $signed(dut.io_tx_symb_vector_bits_1),
          $signed(dut.io_tx_symb_vector_bits_2),
          $signed(dut.io_tx_symb_vector_bits_3)
        );
        // $display("%d\t%d\t%d\t%d\t%d",dut.encoder.io_recovered_tx_data,$signed(dut.encoder.io_tA))//dut.encoder.io_tB,dut.encoder.io_tC,dut.encoder.io_tD);
        $display($signed(dut.fsm.io_encoded_tx_symb_vector_0),$signed(dut.fsm.io_encoded_tx_symb_vector_1),$signed(dut.fsm.io_encoded_tx_symb_vector_2),$signed(dut.fsm.io_encoded_tx_symb_vector_3));
      end else begin
        $display("Cycle %0t ns | TXD = 0x%0h | Output not valid yet", $time, io_txd);
      end

    end

    //io_tx_enable <= 0;
    @(posedge clock);
  endtask

  integer outfile;

  initial begin
    $dumpfile("waves.vcd");
    $dumpvars(0, encoder_txrx_tb);

    outfile = $fopen("encoder_txrx_output.txt", "w");
    if (!outfile) begin
      $display("ERROR: Failed to open output file.");
      $finish;
    end

    // Initial input state
    reset                   = 1;
    io_tx_enable            = 0;
    io_tx_mode              = 0;
    io_tx_error             = 0;
    io_txd                  = 8'b0;
    io_n                    = 0;
    io_n0                   = 0;
    io_loc_rcvr_status      = 1;
    io_symb_timer_done      = 1;
    io_rx_symb_vector_valid = 0;
    io_rx_symb_vector_bits_0 = 3'd0;
    io_rx_symb_vector_bits_1 = 3'd0;
    io_rx_symb_vector_bits_2 = 3'd0;
    io_rx_symb_vector_bits_3 = 3'd0;
    io_decoded_rx_symb_vector = 8'd0;
    io_pcs_reset            = 1;
    io_tx_symb_vector_ready = 0;
    

    test_NORMAL_TX();

    $finish;
  end

endmodule
