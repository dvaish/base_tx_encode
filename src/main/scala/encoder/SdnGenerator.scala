package encoder 

import chisel3._
import chisel3.util.ShiftRegister

class SdGenerator extends Module {
	val io = IO(new Bundle {
		val tx_enable = Input(Bool())
        val tx_error = Input(Bool())
        val scn = Input(Vec(8, Bool()))
        val tx_data = Input(UInt(8.W))
        val loc_rcvr_status = Input(Bool())
        val sdn = Output(Vec(8, Bool()))
        val csreset = Output(Bool())
    })
    
    // TODO: Check this
    val OK = 1.U 
    val tx_enable_n_2 = ShiftRegister(io.tx_enable, 2)

    // CSN Generation
    val csreset = tx_enable_n_2 && (!io.tx_enable)
    val cs_n = Wire(UInt(3.W))
    val cs_n_1 = ShiftRegister(cs_n, 1)

    val cext_n = Wire(Bool())
    val cext_err_n = Wire(Bool())

    // CSN Generation
    when (tx_enable_n_2) {
        cs_n(1) := io.sdn(6) ^ cs_n_1(0)
        cs_n(2) := io.sdn(7) ^ cs_n_1(1)
    } .otherwise {
        cs_n(1) := 0.B
        cs_n(2) := 0.U(1.W)
    }
    cs_n(0) := cs_n_1(2)

    // SDN Generation
    io.sdn(8) := cs_n(0)

    when ((!csreset) && (tx_enable_n_2)) {
        io.sdn(7) := io.scn(7) ^ io.tx_data(7)
        io.sdn(6) := io.scn(6) ^ io.tx_data(6)
    } .elsewhen (csreset) {
        io.sdn(7) := cs_n_1(1)
        io.sdn(6) := cs_n_1(0)
    } .otherwise {
        io.sdn(7) := io.scn(7)
        io.sdn(6) := io.scn(6)
    }

    for (i <- 3 to 5) {
        when (tx_enable_n_2) {
            io.sdn(i) := io.scn(i) ^ io.tx_data(i)
        } .otherwise {
            io.sdn(i) := io.scn(i)
        }
    }

    when (tx_enable_n_2) {
        io.sdn(2) := io.scn(2) ^ io.tx_data(2)
    } .elsewhen (io.loc_rcvr_status === OK) {
        io.sdn(2) := io.scn(2) ^ 1.U
    } .otherwise {
        io.sdn(2) := io.scn(2)
    }


    when ((!io.tx_enable) && (io.tx_data === "hF".U)) {
        cext_n := io.tx_error
    } .otherwise {
        cext_n := 0.B
    }

    when ((!io.tx_enable) && !(io.tx_data === "hF".U)) {
        cext_err_n := io.tx_error
    } .otherwise {
        cext_err_n := 0.U(1.W)
    }

    when (tx_enable_n_2) {
        io.sdn(1) := io.scn(1) ^ io.tx_data(1)
    } .otherwise {
        io.sdn(1) := io.scn(1) ^ cext_err_n
    }

    when (tx_enable_n_2 === 1.U) {
        io.sdn(0) := io.scn(0) ^ io.tx_data(0)
    } .otherwise {
        io.sdn(0) := io.scn(0) ^ cext_n
    }
}

