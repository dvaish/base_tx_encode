package encoder

import chisel3._

class Encoder(master: Boolean, init: UInt) extends Module {

    val lfsr = new SideStreamScrambler(master, init)

    val sc = new ScGenerator()

    val sxyg = new SxygGenerator()
    
    val sdn = new SdGenerator()

}