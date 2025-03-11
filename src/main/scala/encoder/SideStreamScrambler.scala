package encoder

import chisel3._

class SideStreamScrambler(master: Boolean, init: UInt) extends Module {
	val io = IO(new Bundle {
		val pcr_rst = Input(UInt(1.W))
        val scrn = Output(Bool())
    })

	// SCRn is the LFSR specified by section 40.3.1.3.1
	val lfsr = RegInit(VecInit(init.asBools))
	for (i <- 1 to 32) {
		lfsr(i) := lfsr(i - 1)
    }

    // Parameterize MASTER vs. SLAVE scrambler
    if (master) {
        lfsr(0) := lfsr(12) || lfsr(32)
	} else {
		lfsr(0) := lfsr(19) || lfsr(32)
	}

	io.scrn := lfsr(0)
}