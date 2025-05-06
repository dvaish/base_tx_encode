package encoder
class PulseShapingFilter extends Module {
  val io = IO(new Bundle {
    val A = Input(SInt(3.W))
    val B = Input(SInt(3.W))
    val C = Input(SInt(3.W))
    val D = Input(SInt(3.W))
    val Ashaped = Output(UInt(16.W))  // Thermometer code
    val Bshaped = Output(UInt(16.W))
    val Cshaped = Output(UInt(16.W))
    val Dshaped = Output(UInt(16.W))
  })

  val Areg = RegInit(0.S(3.W))
  val Breg = RegInit(0.S(3.W))
  val Creg = RegInit(0.S(3.W))
  val Dreg = RegInit(0.S(3.W))

  Areg := io.A
  Breg := io.B
  Creg := io.C
  Dreg := io.D

  def toThermometer(value: SInt): UInt = {
    val shifted = (value >> 2).asSInt
    val clamped = shifted.asUInt //Mux(shifted < 0.S, 0.U, shifted.asUInt)
    val level = Mux(clamped > 15.U, 15.U, clamped)(3,0) // Ensure 4-bit max
    (1.U << level) - 1.U & Fill(16, 1.U) // e.g., level=3 => "0000_0000_0000_0111"
  }

  val AshapedInt = (io.A * 3.S) + Areg
  val BshapedInt = (io.B * 3.S) + Breg
  val CshapedInt = (io.C * 3.S) + Creg
  val DshapedInt = (io.D * 3.S) + Dreg

  io.Ashaped := toThermometer(AshapedInt)
  io.Bshaped := toThermometer(BshapedInt)
  io.Cshaped := toThermometer(CshapedInt)
  io.Dshaped := toThermometer(DshapedInt)
}

// package encoder

// import chisel3._
// import chisel3.util._
// import chisel3.Bundle

// class PulseShapingFilter extends Module {
//     val io = IO(new Bundle {
//         val A = Input(SInt(3.W))
//         val B = Input(SInt(3.W))
//         val C = Input(SInt(3.W))
//         val D = Input(SInt(3.W))
//         val Ashaped = Output(SInt(6.W))
//         val Bshaped = Output(SInt(6.W))
//         val Cshaped = Output(SInt(6.W))
//         val Dshaped = Output(SInt(6.W))
//     })

//     val Areg = RegInit(0.S(3.W))
//     val Breg = RegInit(0.S(3.W))
//     val Creg = RegInit(0.S(3.W))
//     val Dreg = RegInit(0.S(3.W))

//     Areg := io.A
//     Breg := io.B
//     Creg := io.C
//     Dreg := io.D

//     io.Ashaped := (io.A * 3.S) + Areg 
//     io.Bshaped := (io.B * 3.S) + Breg 
//     io.Cshaped := (io.C * 3.S) + Creg 
//     io.Dshaped := (io.D * 3.S) + Dreg 


// }