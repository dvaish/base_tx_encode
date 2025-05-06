import chisel3._
import chisel3.util._

object PcsTxFSM {
  object State extends ChiselEnum {
    val DisableDataTransmission, EnableDataTransmission = Value
  }
  val SEND_I = 0.U 
  val SEND_N = 1.U  
  val SEND_Z = 2.U  
}

class PcsTxFSM extends Module {
  import PcsTxFSM._
  import PcsTxFSM.State._

  val io = IO(new Bundle {
    val pcs_reset = Input(Bool())
    val link_status = Input(Bool()) // TRUE = OK, FALSE = FAIL
    val tx_mode = Input(UInt(2.W)) // Assuming 2-bit encoding
    val TX_EN = Input(Bool())
    val TX_ER = Input(Bool())
    val tx_enable = Output(Bool())
    val tx_error = Output(Bool())
    val state = Output(State())
  })

  val state = RegInit(DisableDataTransmission)
  io.tx_enable := false.B
  io.tx_error := false.B
  io.state := state

  switch(state) {
    is(DisableDataTransmission) {
      io.tx_enable := false.B
      io.tx_error := false.B

      when(io.pcs_reset === false.B && io.link_status === true.B && io.tx_mode === SEND_N && io.TX_EN === false.B && io.TX_ER === false.B) {
        state := EnableDataTransmission
      }
    }

    is(EnableDataTransmission) {
      io.tx_enable := io.TX_EN
      io.tx_error := io.TX_ER

      when(io.tx_mode =/= SEND_N || io.pcs_reset === true.B || io.link_status === false.B) {
        state := DisableDataTransmission
      }
    }
  }
}
