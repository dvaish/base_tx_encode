`timescale 1ns/10ps
`include "Encoder.sv"

// vcs -full64 src/test/verilog/encoder/encoder_tb.sv -sverilog +incdir+. -R

module encoder_tb;

parameter CLOCK_PERIOD = 8;

reg            clock;
reg            reset;
reg            io_tx_enable;
reg            io_tx_mode;
reg            io_tx_error;
reg [7:0]      io_tx_data;
reg [31:0]     io_n;
reg [31:0]     io_n0;
reg            io_loc_rcvr_status;
reg [2:0]      io_A;
reg [2:0]      io_B;
reg [2:0]      io_C;
reg [2:0]      io_D;

initial clock = 0;
always #(CLOCK_PERIOD/2) clock = !clock;

always @(posedge clock) io_n = io_n + 1;

Encoder dut (.*);

integer i;
task test_NORMAL();

    @(posedge clock);

    reset <= 0;

    repeat (5) @(posedge clock);

    io_tx_enable <= 1;

    @(posedge clock);

    for (i = 0; i < 4; i = i + 1) begin
        $display("[CONDITION=%d] %d, %d, %d, %d", dut.ce.io_condition, $signed(dut.lut.io_tA), $signed(dut.lut.io_tB), $signed(dut.lut.io_tC), $signed(dut.lut.io_tD));
        @(posedge clock);
    end

    io_tx_enable <= 0;

    @(posedge clock)

    for (i = 0; i < 4; i = i + 1) begin
        $display("[CONDITION=%d] %d, %d, %d, %d", dut.ce.io_condition, $signed(dut.lut.io_tA), $signed(dut.lut.io_tB), $signed(dut.lut.io_tC), $signed(dut.lut.io_tD));
        @(posedge clock);
    end

endtask

initial begin
    $dumpfile("waves.vcd");  // Dump to "waves.vcd"
    $dumpvars(0, encoder_tb);       // Dump all variables in module "test"

    reset               = 1;
    io_tx_enable        = 0;
    io_tx_mode          = 1;
    io_tx_error         = 0;
    io_tx_data          = 8'b11110000;
    io_n                = 0;
    io_loc_rcvr_status  = 1;

    test_NORMAL();



    $finish;
end

endmodule