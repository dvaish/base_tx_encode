package encoder

import chisel3._
import chisel3.util._

class Top_Encoder extends Module {
  val io = IO(new Bundle {
    // Encoder inputs
    val tx_enable = Input(Bool())
    val tx_mode = Input(Bool())
    val tx_error = Input(Bool())
    val tx_data = Input(UInt(8.W))
    val n = Input(UInt(32.W))
    val n0 = Input(UInt(32.W))
    val loc_rcvr_status = Input(Bool())


    // Raw PAM-5 symbols from Encoder
    val An = Output(SInt(7.W))
    val Bn = Output(SInt(7.W))
    val Cn = Output(SInt(7.W))
    val Dn = Output(SInt(7.W))

    // Pulse-shaped thermometer outputs
    val Ashaped = Output(UInt(16.W))
    val Bshaped = Output(UInt(16.W))
    val Cshaped = Output(UInt(16.W))
    val Dshaped = Output(UInt(16.W))
  })

  // Instantiate Encoder
  val encoder = Module(new Encoder())

  encoder.io.tx_enable := io.tx_enable
  encoder.io.tx_mode := io.tx_mode
  encoder.io.tx_error := io.tx_error
  encoder.io.tx_data := io.tx_data
  encoder.io.n := io.n
  encoder.io.n0 := io.n0
  encoder.io.loc_rcvr_status := io.loc_rcvr_status

//   io.recovered_tx_data := encoder.io.recovered_tx_data

  // Raw PAM-5 symbols to output
  io.An := encoder.io.A
  io.Bn := encoder.io.B
  io.Cn := encoder.io.C
  io.Dn := encoder.io.D

  // Instantiate PulseShapingFilter
  val filter = Module(new PulseShapingFilter())

  filter.io.A := encoder.io.A.asSInt
  filter.io.B := encoder.io.B.asSInt
  filter.io.C := encoder.io.C.asSInt
  filter.io.D := encoder.io.D.asSInt

  io.Ashaped := filter.io.Ashaped
  io.Bshaped := filter.io.Bshaped
  io.Cshaped := filter.io.Cshaped
  io.Dshaped := filter.io.Dshaped
}
