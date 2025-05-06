package encoder

import chisel3._
import chisel3.util.ShiftRegister
class Descrambler extends Module {
  val io = IO(new Bundle {
    val tx_enable = Input(Bool())
    val scn = Input(Vec(8, Bool()))
    val sdn = Input(Vec(9, Bool()))
    val loc_rcvr_status = Input(Bool())
    val recovered_tx_data = Output(UInt(8.W))
    val recovered_tx_error = Output(Bool())
  })

  val OK = 1.U
  val tx_enable_n_2 = ShiftRegister(io.tx_enable, 2, 0.B, true.B)
  val csreset = tx_enable_n_2 && !io.tx_enable

  val tx_data_bits = Wire(Vec(8, Bool()))
  val tx_error = Wire(Bool())

  // Recover tx_data bits from XOR if tx_enable_n_2 is high
  for (i <- 3 to 5) {
    tx_data_bits(i) := Mux(tx_enable_n_2, io.sdn(i) ^ io.scn(i), false.B)
  }

  // sdn(2) logic depends on loc_rcvr_status
  tx_data_bits(2) := Mux(tx_enable_n_2, io.sdn(2) ^ io.scn(2),
                      Mux(io.loc_rcvr_status === OK, io.sdn(2) ^ io.scn(2) ^ true.B, false.B))

  // Recover tx_data(1) using sdn(1) and scn(1)
  val cext_err_n = io.sdn(1) ^ io.scn(1)
  tx_data_bits(1) := Mux(tx_enable_n_2, io.sdn(1) ^ io.scn(1), false.B)

  // Recover tx_data(0)
  val cext_n = io.sdn(0) ^ io.scn(0)
  tx_data_bits(0) := Mux(tx_enable_n_2, io.sdn(0) ^ io.scn(0), false.B)

  // For sdn(6) and sdn(7), recovery only when not in csreset
  tx_data_bits(6) := Mux(!csreset && tx_enable_n_2, io.sdn(6) ^ io.scn(6), false.B)
  tx_data_bits(7) := Mux(!csreset && tx_enable_n_2, io.sdn(7) ^ io.scn(7), false.B)

  // Assemble recovered tx_data
  io.recovered_tx_data := tx_data_bits.asUInt

  // Recover tx_error
  when (!io.tx_enable && io.recovered_tx_data === "hF".U) {
    tx_error := cext_n
  } .elsewhen (!io.tx_enable && io.recovered_tx_data =/= "hF".U) {
    tx_error := cext_err_n
  } .otherwise {
    tx_error := false.B
  }

  io.recovered_tx_error := tx_error
}
