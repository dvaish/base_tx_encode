package encoder

import chisel3._

class ScGenerator extends Module {

    // TODO: Define this SEND_Z
    val SEND_Z = 1.U

	val io = IO(new Bundle {
		val tx_enable = Input(Bool())
		val tx_mode = Input(UInt(1.W))
		val sxn = Input(Vec(4, Bool()))
		val syn = Input(Vec(4, Bool()))
		val sgn = Input(Vec(4, Bool()))
		val n = Input(UInt(32.W))
		val n0 = Input(UInt(32.W)) 
        val scn = Output(Vec(8, Bool()))
    })

    for (i <- 4 to 7) {
        when (io.tx_enable) {
            io.scn(i) := io.sxn(i-4)
        } .otherwise {
            io.scn(i) := 0.B
        }
    }

    for (i <- 1 to 3) {
        when (io.tx_mode === SEND_Z) {
            io.scn(i) := 0.B
        } .elsewhen ((io.n - io.n0) % 2.U === 0.U) {
            io.scn(i) := io.syn(i)
        } .otherwise {
            io.scn(i) := io.syn(i) ^ 1.B
        }
    }

    when (io.tx_mode === SEND_Z) {
        io.scn(0) := 0.B
    } .otherwise {
        io.scn(0) := io.syn(0)
    }
}
