package encoder
import pdfd._

import chisel3._
import chisel3.util._
import _root_.circt.stage.ChiselStage
import chisel3.util.ShiftRegister
import chisel3.util.ShiftRegisters
// import LaPDFD._
// import Encoder._

class Encoder_Decoder(master: Boolean = true, init: UInt = 1.U, filter: Boolean = true) extends Module {
  val io = IO(new Bundle {
    // LaPDFD IO
    val rxSamples = Input(Vec(4, SInt(8.W)))
    val taps      = Input(Vec(14, SInt(8.W)))
    val rxSymbols = Output(UInt(12.W))
    val rxValid   = Output(Bool())

    // Encoder IO
    val tx_enable        = Input(Bool())
    val tx_mode          = Input(Bool())
    val tx_error         = Input(Bool())
    val tx_data          = Input(UInt(8.W))
    val n                = Input(UInt(32.W))
    val n0               = Input(UInt(32.W))
    val loc_rcvr_status  = Input(Bool())

    val A                = Output(SInt(7.W))
    val B                = Output(SInt(7.W))
    val C                = Output(SInt(7.W))
    val D                = Output(SInt(7.W))
    val recovered_tx_data = Output(UInt(8.W))
  })

  // Instantiate submodules
  val lapdfd = Module(new LaPDFD())
  val encoder = Module(new Encoder(master, init))

  // Connect LaPDFD
  lapdfd.io.rxSamples := io.rxSamples
  lapdfd.io.taps      := io.taps
  io.rxSymbols        := lapdfd.io.rxSymbols
  io.rxValid          := lapdfd.io.rxValid

  // Connect Encoder
  encoder.io.tx_enable       := io.tx_enable
  encoder.io.tx_mode         := io.tx_mode
  encoder.io.tx_error        := io.tx_error
  encoder.io.tx_data         := io.tx_data
  encoder.io.n               := io.n
  encoder.io.n0              := io.n0
  encoder.io.loc_rcvr_status := io.loc_rcvr_status

  io.A := encoder.io.A
  io.B := encoder.io.B
  io.C := encoder.io.C
  io.D := encoder.io.D
  io.recovered_tx_data := encoder.io.recovered_tx_data
}

// object Encoder_Decoder extends App {
//   ChiselStage.emitSystemVerilogFile(
//     new Encoder_Decoder(true, 1.U(33.W), false),
//     firtoolOpts = Array("-disable-all-randomization", "-strip-debug-info")
//   )
// }