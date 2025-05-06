package encoder 

import chisel3._
import chisel3.util._

class AnBnCnDnGenerator extends Module {
  val io = IO(new Bundle {
    val sgn = Input(UInt(4.W))      // Sg[3:0]
    val tx_enable = Input(Bool()) // tx_enable_n
    val tA = Input(SInt(3.W))
    val tB = Input(SInt(3.W))
    val tC = Input(SInt(3.W))
    val tD = Input(SInt(3.W))
    val A = Output(SInt(3.W))
    val B = Output(SInt(3.W))
    val C = Output(SInt(3.W))
    val D = Output(SInt(3.W))
  })

  val tx_enable_n_1 :: tx_enable_n_2 :: tx_enable_n_3 :: tx_enable_n_4 :: Nil = ShiftRegisters(io.tx_enable, 4)

  // Compute Srev
  val Srev = tx_enable_n_2 || tx_enable_n_4

  // Compute SnA, SnB, SnC, SnD
  val SnA = Mux((io.sgn(0) ^ Srev), -1.S, 1.S)
  val SnB = Mux((io.sgn(1) ^ Srev), -1.S, 1.S)
  val SnC = Mux((io.sgn(2) ^ Srev), -1.S, 1.S)
  val SnD = Mux((io.sgn(3) ^ Srev), -1.S, 1.S)

  // Compute A, B, C, D
  io.A := io.tA * SnA
  io.B := io.tB * SnB
  io.C := io.tC * SnC
  io.D := io.tD * SnD
  
}