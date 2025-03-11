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
    val tx_enable_n = Input(Bool())       // Current TX Enable (n)
    val tx_enable_n1 = Input(Bool())    // TX Enable (n-1)
    val tx_enable_n2 = Input(Bool())    // TX Enable (n-2)
    val tx_enable_n3 = Input(Bool())    // TX Enable (n-3)
    val tx_enable_n4 = Input(Bool())    // TX Enable (n-4)

    val tx_error_n = Input(Bool())        // Current TX Error
    val tx_error_n1 = Input(Bool())     // TX Error (n-1)
    val tx_error_n2 = Input(Bool())     // TX Error (n-2)
    val tx_error_n3 = Input(Bool())     // TX Error (n-3)
    
    val csreset_n = Input(Bool())         // Convolutional Encoder Reset
    val txd = Input(UInt(8.W))          // TXD Input

    val condition = Output(Condition()) // Output condition encoding
  })

  // Default condition
  io.condition := Condition.Normal

  // Encoding of Error Indication (xmt_err)
  when(io.tx_error_n && (io.tx_enable_n && io.tx_enable_n2)) { // If tx_error =1 when the condition (tx_enable * tx_enable(n-2) ) = 1
    io.condition := Condition.xmt_err
  }
  
  // Encoding of Convolutional Encoder Reset (CSReset)
  .elsewhen(!io.tx_error_n && io.csreset_n) { //
    io.condition := Condition.CSReset
  }

  // Encoding of Carrier Extension during Convolutional Encoder Reset
  .elsewhen(io.tx_error_n && io.csreset_n) { //If tx_error =0 when the variable csreset = 1
    when(io.txd === "h0F".U) {
      io.condition := Condition.CSExtend
    }.otherwise {
      io.condition := Condition.CSExtend_Err
    }
  }

  // Encoding of Start-of-Stream Delimiter (SSD)
  .elsewhen(io.tx_enable_n && !io.tx_enable_n2) {
    when(io.tx_enable_n && !io.tx_enable_n1) {
      io.condition := Condition.SSD1
    }.elsewhen(io.tx_enable_n1 && !io.tx_enable_n2) {
      io.condition := Condition.SSD2
    }
  }

  // Encoding of End-of-Stream Delimiter (ESD)
  .elsewhen(!io.tx_enable_n2 && io.tx_enable_n4) {
    when(io.tx_error_n && io.tx_error_n1 && io.tx_error_n2 && io.txd =/= "h0F".U) {
      io.condition := Condition.ESD_Ext_Err
    }.elsewhen(io.tx_error_n && io.tx_error_n1 && io.tx_error_n2 && io.tx_error_n3 && io.txd =/= "h0F".U) {
      io.condition := Condition.ESD_Ext_Err
    }.elsewhen(!io.tx_enable_n2 && io.tx_enable_n3) {
      io.condition := Condition.ESD1
    }.elsewhen(!io.tx_enable_n3 && io.tx_enable_n4 && !io.tx_error_n && !io.tx_error_n1) {
      io.condition := Condition.ESD2_Ext_0
    }.elsewhen(!io.tx_enable_n3 && io.tx_enable_n4 && !io.tx_error_n && io.tx_error_n1 && io.tx_error_n2 && io.tx_error_n3) {
      io.condition := Condition.ESD2_Ext_1
    }.elsewhen(!io.tx_enable_n3 && io.tx_enable_n4 && io.tx_error_n && io.tx_error_n1 && io.tx_error_n2 && io.tx_error_n3 && io.txd === "h0F".U) {
      io.condition := Condition.ESD2_Ext_2
    }
  }
}
