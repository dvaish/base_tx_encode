package encoder

import chisel3._

class SxygGenerator extends Module {
	val io = IO(new Bundle {
		val scrn = Input(Vec(33, Bool()))
		val sxn = Output(Vec(4, Bool()))
		val syn = Output(Vec(4, Bool()))
		val sgn = Output(Vec(4, Bool()))
	})

	val x = io.scrn(4) ^ io.scrn(6)
	val y = io.scrn(1) ^ io.scrn(5)

	io.syn(0) := io.scrn(0)
	io.syn(1) := io.scrn(3) ^ io.scrn(8)
	io.syn(2) := io.scrn(6) ^ io.scrn(16)
	io.syn(3) := io.scrn(9) ^ io.scrn(14) ^ io.scrn(19) ^ io.scrn(24)
	
	io.sxn(0) := io.scrn(4) ^ io.scrn(6)
	io.sxn(1) := io.scrn(7) ^ io.scrn(9) ^ io.scrn(12) ^ io.scrn(14) 
	io.sxn(2) := io.scrn(10) ^ io.scrn(12) ^ io.scrn(20) ^ io.scrn(22)
	io.sxn(3) := io.scrn(13) ^ io.scrn(15) ^ io.scrn(18) ^ io.scrn(20) ^ io.scrn(23) ^ io.scrn(25) ^ io.scrn(28) ^ io.scrn(30)
	
	io.sgn(0) := io.scrn(1) ^ io.scrn(5)
	io.sgn(1) := io.scrn(4) ^ io.scrn(8) ^ io.scrn(9) ^ io.scrn(13)
	io.sgn(2) := io.scrn(7) ^ io.scrn(11) ^ io.scrn(17) ^ io.scrn(21)
	io.sgn(3) := io.scrn(10) ^ io.scrn(14) ^ io.scrn(15) ^ io.scrn(19) ^ io.scrn(20) ^ io.scrn(24) ^ io.scrn(25) ^ io.scrn(29)
	
}

