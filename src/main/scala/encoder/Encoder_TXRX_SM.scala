package encoder

import chisel3._
import chisel3.util._
import _root_.circt.stage.ChiselStage
import chisel3.util.ShiftRegister
import chisel3.util.ShiftRegisters
class Encoder_TXRX_SM(master: Boolean = true, init: UInt = 1.U(33.W)) extends Module {
  val io = IO(new Bundle {
    // PCS Reset
    val pcs_reset = Input(Bool())

    // GMII TX interface
    val tx_enable = Input(Bool())
    val tx_error = Input(Bool())
    val txd = Input(UInt(8.W))
    val symb_timer_done = Input(Bool())

    // GMII RX interface
    val rxd = Output(UInt(8.W))
    val rx_dv = Output(Bool())
    val rx_er = Output(Bool())
    val rxerror_status = Output(Bool())

    // RX Symbol input from Decoder
    val rx_symb_vector = Flipped(Decoupled(Vec(4, SInt(3.W))))
    val decoded_rx_symb_vector = Input(UInt(8.W))

    // Control and status
    val col = Output(Bool())
    val tx_symb_vector = Decoupled(Vec(4, SInt(3.W)))

    // Encoder-specific inputs
    val tx_mode = Input(Bool())
    val n = Input(UInt(32.W))
    val n0 = Input(UInt(32.W))
    val loc_rcvr_status = Input(Bool())
  })

  // Instantiate Encoder
  val encoder = Module(new Encoder(master, init)) // default init value used
  encoder.io.tx_enable := io.tx_enable
  encoder.io.tx_mode := io.tx_mode
  encoder.io.tx_error := io.tx_error
  encoder.io.tx_data := io.txd
  encoder.io.n := io.n
  encoder.io.n0 := io.n0
  encoder.io.loc_rcvr_status := io.loc_rcvr_status

  // Connect encoder output as encoded_tx_symb_vector
  val encoded_tx_symb_vector = Wire(Vec(4, SInt(3.W)))
  encoded_tx_symb_vector(0) := encoder.io.A
  encoded_tx_symb_vector(1) := encoder.io.B
  encoded_tx_symb_vector(2) := encoder.io.C
  encoded_tx_symb_vector(3) := encoder.io.D

  // Instantiate TxRxStateMachine
  val fsm = Module(new TxRxStateMachine)
  fsm.io.pcs_reset := io.pcs_reset
  fsm.io.tx_enable := io.tx_enable
  fsm.io.tx_error := io.tx_error
  fsm.io.symb_timer_done := io.symb_timer_done
  fsm.io.txd := io.txd
  fsm.io.encoded_tx_symb_vector := encoded_tx_symb_vector
  fsm.io.rx_symb_vector <> io.rx_symb_vector
  fsm.io.decoded_rx_symb_vector := io.decoded_rx_symb_vector

  // Outputs
  io.rxd := fsm.io.rxd
  io.rx_dv := fsm.io.rx_dv
  io.rx_er := fsm.io.rx_er
  io.rxerror_status := fsm.io.rxerror_status
  io.col := fsm.io.col
  io.tx_symb_vector <> fsm.io.tx_symb_vector
}

object Encoder_TXRX_SM extends App {
  ChiselStage.emitSystemVerilogFile(
    new Encoder_TXRX_SM,
    firtoolOpts = Array("-disable-all-randomization", "-strip-debug-info")
  )
}