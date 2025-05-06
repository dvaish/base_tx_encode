package encoder

import chisel3._

class SideStreamScrambler(master: Boolean, init: UInt) extends Module {
	/* 
	master: Boolean   	= 	Specifies if this instance is a master or slave. 
							Changes the LFSR being used.
	init: 	UInt(33.W)	= 	Specifies the initial state of the LFSR
	*/
	val io = IO(new Bundle {
        val scrn = Output(Vec(33, Bool()))
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

	io.scrn := lfsr
}