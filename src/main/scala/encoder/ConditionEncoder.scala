package encoder 

import chisel3._
import chisel3.util._
// import chisel3.experimental.ChiselEnum

/** Enum for condition values */
object Condition extends ChiselEnum {
  val Normal, xmt_err, CSExtend_Err, CSExtend, CSReset,
      SSD1, SSD2, ESD1, ESD2_Ext_0, ESD2_Ext_1, ESD2_Ext_2,
      ESD_Ext_Err, Idle_CarrExt = Value
}

/** Module for Encoding Condition Based on TX Error and TX Enable Signals */
class ConditionEncoder extends Module {
  val io = IO(new Bundle {
    val tx_enable = Input(Bool())       // Current TX Enable (n)

    val tx_error = Input(Bool())        // Current TX Error
    
    val csreset_n = Input(Bool())         // Convolutional Encoder Reset
    val tx_data = Input(UInt(8.W))          // TXD Input

    val condition = Output(Condition()) // Output condition encoding
  })

  val tx_enable_n_1 :: tx_enable_n_2 :: tx_enable_n_3 :: tx_enable_n_4 :: Nil = ShiftRegisters(io.tx_enable, 4)
  val tx_error_n_1 :: tx_error_n_2 :: tx_error_n_3 :: Nil = ShiftRegisters(io.tx_error, 3)


  // Default condition
  io.condition := Condition.Normal

  // Encoding of Error Indication (xmt_err)
  when(io.tx_error && (io.tx_enable && tx_enable_n_2)) { // If tx_error =1 when the condition (tx_enable * tx_enable(n-2) ) = 1
    io.condition := Condition.xmt_err
  }
  
  // Encoding of Convolutional Encoder Reset (CSReset)
  .elsewhen(!io.tx_error && io.csreset_n) { //
    io.condition := Condition.CSReset
  }

  // Encoding of Carrier Extension during Convolutional Encoder Reset
  .elsewhen(io.tx_error && io.csreset_n) { //If tx_error =0 when the variable csreset = 1
    when(io.tx_data === "h0F".U) {
      io.condition := Condition.CSExtend
    }.otherwise {
      io.condition := Condition.CSExtend_Err
    }
  }

  // Encoding of Start-of-Stream Delimiter (SSD)
  .elsewhen(io.tx_enable && !tx_enable_n_2) {
    when(io.tx_enable && !tx_enable_n_1) {
      io.condition := Condition.SSD1
    }.elsewhen(tx_enable_n_1 && !tx_enable_n_2) {
      io.condition := Condition.SSD2
    }
  }

  // Encoding of End-of-Stream Delimiter (ESD)
  .elsewhen(!tx_enable_n_2 && tx_enable_n_4) {
    when(io.tx_error && tx_error_n_1 && tx_error_n_2 && io.tx_data =/= "h0F".U) {
      io.condition := Condition.ESD_Ext_Err
    }.elsewhen(io.tx_error && tx_error_n_1 && tx_error_n_2 && tx_error_n_3 && io.tx_data =/= "h0F".U) {
      io.condition := Condition.ESD_Ext_Err
    }.elsewhen(!tx_enable_n_2 && tx_enable_n_3) {
      io.condition := Condition.ESD1
    }.elsewhen(!tx_enable_n_3 && tx_enable_n_4 && !io.tx_error && !tx_error_n_1) {
      io.condition := Condition.ESD2_Ext_0
    }.elsewhen(!tx_enable_n_3 && tx_enable_n_4 && !io.tx_error && tx_error_n_1 && tx_error_n_2 && tx_error_n_3) {
      io.condition := Condition.ESD2_Ext_1
    }.elsewhen(!tx_enable_n_3 && tx_enable_n_4 && io.tx_error && tx_error_n_1 && tx_error_n_2 && tx_error_n_3 && io.tx_data === "h0F".U) {
      io.condition := Condition.ESD2_Ext_2
    }
  }

}
