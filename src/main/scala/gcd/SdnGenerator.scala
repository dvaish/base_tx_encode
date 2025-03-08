package encoder 

import chisel3._
import chisel3.util.ShiftRegister

class SdGenerator extends Module {
	val io = IO(new Bundle {
		val tx_enable = Input(Bool())
        val tx_err = Input(Bool())
        val scn = Input(Vec(8, Bool()))
        val sdn = Output(Vec(8, Bool()))
        val txd = Input(UInt(8.W))
        val loc_rcvr_status = Input(Bool())
    })
    
    // TODO: Check this
    val OK = 1.U 
    val tx_enable_n_2 = ShiftRegister(io.tx_enable, 2)

    // CSN Generation
    val csreset = tx_enable_n_2 && (!io.tx_enable)
    val csn = Wire(UInt(3.W))
    val csn_1 = ShiftRegister(csn, 1)

    val cextn = Wire(Bool())
    val cext_errn = Wire(Bool())

    // CSN Generation
    when (tx_enable_n_2) {
        csn(1) := io.sdn(6) ^ csn_1(0)
        csn(2) := io.sdn(7) ^ csn_1(1)
    } .otherwise {
        csn(1) := 0.B
        csn(2) := 0.U(1.W)
    }
    csn(0) := csn_1(2)

    // SDN Generation
    io.sdn(8) := csn(0)

    when ((!csreset) && (tx_enable_n_2)) {
        io.sdn(7) := io.scn(7) ^ io.txd(7)
        io.sdn(6) := io.scn(6) ^ io.txd(6)
    } .elsewhen (csreset) {
        io.sdn(7) := csn_1(1)
        io.sdn(6) := csn_1(0)
    } .otherwise {
        io.sdn(7) := io.scn(7)
        io.sdn(6) := io.scn(6)
    }

    for (i <- 3 to 5) {
        when (tx_enable_n_2) {
            io.sdn(i) := io.scn(i) ^ io.txd(i)
        } .otherwise {
            io.sdn(i) := io.scn(i)
        }
    }

    when (tx_enable_n_2) {
        io.sdn(2) := io.scn(2) ^ io.txd(2)
    } .elsewhen (io.loc_rcvr_status === OK) {
        io.sdn(2) := io.scn(2) ^ 1.U
    } .otherwise {
        io.sdn(2) := io.scn(2)
    }


    when ((!io.tx_enable) && (io.txd === "hF".U)) {
        cextn := io.tx_err
    } .otherwise {
        cextn := 0.B
    }

    when ((!io.tx_enable) && !(io.txd === "hF".U)) {
        cext_errn := io.tx_err
    } .otherwise {
        cext_errn := 0.U(1.W)
    }

    when (tx_enable_n_2) {
        io.sdn(1) := io.scn(1) ^ io.txd(1)
    } .otherwise {
        io.sdn(1) := io.scn(1) ^ cext_errn
    }

    when (tx_enable_n_2 === 1.U) {
        io.sdn(0) := io.scn(0) ^ io.txd(0)
    } .otherwise {
        io.sdn(0) := io.scn(0) ^ cextn
    }
}

