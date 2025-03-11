package encoder

import chisel3._
import chisel3.util.ShiftRegister
import chisel3.util.ShiftRegisters

class Encoder(master: Boolean, init: UInt) extends Module {
    val io = IO(new Bundle {
        val tx_enable = Input(Bool())
        val tx_mode = Input(Bool())
        val tx_error = Input(Bool())
        val tx_data = Input(UInt(8.W))
        val n = Input(UInt(32.W)) // TODO: Width unknown
        val n0 = Input(UInt(32.W))
        val loc_rcvr_status = Input(Bool())
    })

    val lfsr = new SideStreamScrambler(master, init)


    val sxyg = new SxygGenerator()

    sxyg.io.scrn := lfsr.io.scrn


    val sc = new ScGenerator()

    sc.io.tx_enable := io.tx_enable
    sc.io.tx_mode := io.tx_mode
    sc.io.sxn := sxyg.io.sxn
    sc.io.syn := sxyg.io.syn
    sc.io.sgn := sxyg.io.sgn
    sc.io.n := io.n
    sc.io.n0 := io.n0


    val sd = new SdGenerator()

    sd.io.tx_enable := io.tx_enable
    sd.io.tx_error := io.tx_error
    sd.io.scn := sc.io.scn
    sd.io.tx_data := io.tx_data
    sd.io.loc_rcvr_status := io.loc_rcvr_status


    val ce = new ConditionEncoder()

    ce.io.tx_enable := io.tx_enable
    ce.io.tx_error := io.tx_error
    ce.io.csreset_n := sd.io.csreset
    ce.io.tx_data := io.tx_data


    val lut = new LookupTableModule()

    lut.io.condition := ce.io.condition
    lut.io.sdn_5_0 := sd.io.sdn.asUInt(5, 0)
    lut.io.sdn_6_8 := sd.io.sdn.asUInt(8, 6)

    // At the end of this pipeline, we have tA, tB, tC, tD
}