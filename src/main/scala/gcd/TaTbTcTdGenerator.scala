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

    val tA = Output(SInt(8.W)) // TAn
    val tB = Output(SInt(8.W)) // TBn
    val tC = Output(SInt(8.W)) // TCn
    val tD = Output(SInt(8.W)) // TDn
  })

  // Instantiate ConditionEncoder
  val conditionEncoder = Module(new ConditionEncoder)
  conditionEncoder.io.tx_enable_n := io.tx_enable_n
  conditionEncoder.io.tx_enable_n1 := io.tx_enable_n1
  conditionEncoder.io.tx_enable_n2 := io.tx_enable_n2
  conditionEncoder.io.tx_enable_n3 := io.tx_enable_n3
  conditionEncoder.io.tx_enable_n4 := io.tx_enable_n4
  conditionEncoder.io.tx_error_n := io.tx_error_n
  conditionEncoder.io.tx_error_n1 := io.tx_error_n1
  conditionEncoder.io.tx_error_n2 := io.tx_error_n2
  conditionEncoder.io.tx_error_n3 := io.tx_error_n3
  conditionEncoder.io.csreset_n := io.csreset_n
  conditionEncoder.io.txd := io.txd

  // Instantiate LookupTableModule
  val lookupTableModule = Module(new LookupTableModule)
  lookupTableModule.io.condition := conditionEncoder.io.condition
  lookupTableModule.io.sdn_5_0 := io.sdn_5_0
  lookupTableModule.io.sdn_6_8 := io.sdn_6_8

  // Connect outputs
  io.tA := lookupTableModule.io.tA
  io.tB := lookupTableModule.io.tB
  io.tC := lookupTableModule.io.tC
  io.tD := lookupTableModule.io.tD
}