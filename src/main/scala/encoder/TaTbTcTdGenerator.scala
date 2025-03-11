package encoder 

import chisel3._
import chisel3.util._

class TaTbTcTdGenerator extends Module {
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

    val sdn_5_0 = Input(UInt(6.W)) // 6-bit Sdn[5:0]
    val sdn_6_8 = Input(UInt(3.W)) // 3-bit Sdn[6:8]

    val condition = Input(Condition())

    val tA = Output(SInt(3.W)) // TAn
    val tB = Output(SInt(3.W)) // TBn
    val tC = Output(SInt(3.W)) // TCn
    val tD = Output(SInt(3.W)) // TDn
  })

  // Instantiate ConditionEncoder
  val ce = Module(new ConditionEncoder)
  ce.io.tx_enable := io.tx_enable_n
  ce.io.tx_error := io.tx_error_n
  ce.io.csreset_n := io.csreset_n
  ce.io.tx_data := io.txd

  // Instantiate LookupTableModule
  val lut = Module(new LookupTableModule)
  lut.io.condition := ce.io.condition
  lut.io.sdn_5_0 := io.sdn_5_0
  lut.io.sdn_6_8 := io.sdn_6_8

  // Connect outputs
  io.tA := lut.io.tA
  io.tB := lut.io.tB
  io.tC := lut.io.tC
  io.tD := lut.io.tD
}