package encoder
import PcsCodeGroups._
import chisel3._
import chisel3.util._
// import org.chipsalliance.cde.config.{Parameters, Field, Config}
// import freechips.rocketchip.diplomacy._
// import freechips.rocketchip.regmapper._
// import freechips.rocketchip.subsystem._
// import freechips.rocketchip.tilelink._
class TxRxStateMachine extends Module {
  val io = IO(new Bundle {
    val rx_symb_vector            = Flipped(Decoupled(Vec(4, SInt(3.W))))
    val pcs_reset                 = Input(Bool())      // PCS Reset control
    val decoded_rx_symb_vector    = Input(UInt(8.W))   // From Decoder

    val rxd                       = Output(UInt(8.W))  // GMII: RX Data Bus
    val rx_dv                     = Output(Bool())     // GMII: RX Data Valid
    val rx_er                     = Output(Bool())     // GMII: RX Data Error
    val rxerror_status            = Output(Bool())     // Error status from PCS Rx

    val tx_enable                 = Input(Bool())      // Enables transmission
    val tx_error                  = Input(Bool())      // Indicates transmit error
    val symb_timer_done           = Input(Bool())      // Symbol timer expires
    val txd                       = Input(UInt(8.W))   // GMII: TX Data Bus
    val encoded_tx_symb_vector    = Input(Vec(4, SInt(3.W)))              // From Encoder

    val col                       = Output(Bool())                        // Collision indication
    val tx_symb_vector            = Decoupled(Vec(4, SInt(3.W)))          // Vector of quinary symbols for transmit
    
  })
  // TX STATE MACHINE
   io.tx_symb_vector.noenq()
   io.col := false.B

   val _1000BTtransmit = WireDefault(false.B)
   val _1000BTreceive = WireDefault(false.B)

   val PUDR        = io.tx_symb_vector.fire

   val txstate = RegInit(PcsTxState.IDLE)

   switch (txstate) {
    is (PcsTxState.IDLE) {
      _1000BTtransmit := false.B
      io.col := false.B
      io.tx_symb_vector.enq(V(-2, -2, -2, -2))

      when (!io.tx_enable && PUDR) {
        txstate := PcsTxState.IDLE
      }.elsewhen (io.tx_enable && !io.tx_error && PUDR) {
        txstate := PcsTxState.SSD1_VECTOR
      }.elsewhen (io.tx_enable && io.tx_error && PUDR) {
        txstate := PcsTxState.SSD1_VECTOR_ERROR
      }.otherwise{
        txstate := PcsTxState.IDLE
      }
    }
    is (PcsTxState.SSD1_VECTOR) {
      _1000BTtransmit := true.B
      io.col := _1000BTreceive
      io.tx_symb_vector.enq(V(+2, +2, +2, +2))

      when (!io.tx_error && PUDR) {
        txstate := PcsTxState.SSD2_VECTOR
      }.elsewhen (io.tx_error && PUDR) {
        txstate := PcsTxState.SSD2_VECTOR_ERROR
      }.otherwise{
        txstate := PcsTxState.SSD1_VECTOR
      }
    }

    is (PcsTxState.SSD2_VECTOR) {
      _1000BTtransmit := true.B
      io.col := _1000BTreceive
      io.tx_symb_vector.enq(V(+2, +2, +2, -2))

      when (io.tx_enable && !io.tx_error && PUDR) {
        txstate := PcsTxState.TRANSMIT_DATA
      }.elsewhen (!io.tx_enable && !io.tx_error && PUDR) {
        txstate := PcsTxState.CSReset1
      }.elsewhen (io.tx_error && PUDR) {
        txstate := PcsTxState.TRANSMIT_ERROR
      }.otherwise{
        txstate := PcsTxState.SSD2_VECTOR
      }
    }
    

    is (PcsTxState.SSD1_VECTOR_ERROR) {
      _1000BTtransmit := true.B
      io.col := _1000BTreceive
      io.tx_symb_vector.enq(V(+2, +2, +2, +2))

      when (PUDR) {
        txstate := PcsTxState.SSD2_VECTOR_ERROR
      }.otherwise{
        txstate := PcsTxState.SSD1_VECTOR_ERROR
      }
    }

    is (PcsTxState.SSD2_VECTOR_ERROR) {
      _1000BTtransmit := true.B
      io.col := _1000BTreceive
      io.tx_symb_vector.enq(V(+2, +2, +2, +2))

      when (PUDR) {
        txstate := PcsTxState.TRANSMIT_ERROR
      }.otherwise{
        txstate := PcsTxState.SSD2_VECTOR_ERROR
      }
    }

    is (PcsTxState.TRANSMIT_DATA) {
      _1000BTtransmit := true.B
      io.col := _1000BTreceive
      io.tx_symb_vector.enq(io.encoded_tx_symb_vector)

      when (io.tx_enable && !io.tx_error && PUDR) {
        txstate := PcsTxState.TRANSMIT_DATA
      }.elsewhen (!io.tx_enable && !io.tx_error && PUDR) {
        txstate := PcsTxState.CSReset1
      }.elsewhen (io.tx_error && PUDR) {
        txstate := PcsTxState.TRANSMIT_ERROR
      }.otherwise{
        txstate := PcsTxState.TRANSMIT_DATA
      }
    }
    is (PcsTxState.TRANSMIT_ERROR) {
      _1000BTtransmit := true.B
      io.col := _1000BTreceive
      io.tx_symb_vector.enq(V(0,+2,+2,0))

      when (io.tx_enable && !io.tx_error && PUDR) {
        txstate := PcsTxState.TRANSMIT_DATA
      }.elsewhen (!io.tx_enable && !io.tx_error && PUDR) {
        txstate := PcsTxState.CSReset1
      }.elsewhen (io.tx_error && PUDR) {
        txstate := PcsTxState.TRANSMIT_ERROR
      }.otherwise{
        txstate := PcsTxState.TRANSMIT_ERROR
      }
    }

    is (PcsTxState.CSReset1) {
      _1000BTtransmit := false.B
      io.col := false.B
      io.tx_symb_vector.enq(V(+2,-2,-2,+2))

      when (PUDR) {
        txstate := PcsTxState.CSReset2
      }.otherwise{
        txstate := PcsTxState.CSReset1
      }
    }

    is (PcsTxState.CSReset2) {
      _1000BTtransmit := false.B
      io.col := false.B
      io.tx_symb_vector.enq(V(+2,-2,-2,+2))

      when (PUDR) {
        txstate := PcsTxState.ESD1
      }.otherwise{
        txstate := PcsTxState.CSReset2
      }
    }

    is (PcsTxState.ESD1) {
      _1000BTtransmit := false.B
      io.col := false.B
      io.tx_symb_vector.enq(V(+2, +2, +2, +2))

      when (PUDR) {
        txstate := PcsTxState.ESD2
      }.otherwise{
        txstate := PcsTxState.ESD1
      }
    }

    is (PcsTxState.ESD2) {
      _1000BTtransmit := false.B
      io.col := false.B
      io.tx_symb_vector.enq(V(+2, +2, +2, -2) )

      when (PUDR) {
        txstate := PcsTxState.IDLE
      }.otherwise{
        txstate := PcsTxState.ESD2
      }
    }


   }

  // RX STATE MACHINE
   io.rx_symb_vector.nodeq()
   io.rxd := RegInit(0.U(8.W)) // Wire(UInt())
   io.rx_dv := false.B
   io.rx_er := false.B
   io.rxerror_status := false.B

   val rxHist = ShiftRegisters(io.rx_symb_vector.bits, 3, io.rx_symb_vector.fire) // rx_hist(0) = rx_n, rx_hist(1) = rx_n-1, etc.
   val Rx_n = io.rx_symb_vector.bits          // incoming
   val Rx_n_minus1 = rxHist(0)                // 1‑cycle old
   val Rx_n_minus2 = rxHist(1)                // 2‑cycle old
   val Rx_n_minus3 = rxHist(2)                // 3‑cycle old
   val PUDI        = io.rx_symb_vector.fire

   val state = RegInit(PcsRxState.IDLE)

  switch (state) {
    is (PcsRxState.IDLE) {
      io.rx_symb_vector.ready := true.B
      _1000BTreceive := false.B
      io.rxerror_status := false.B
      io.rx_dv := false.B
      io.rx_er := false.B
      io.rxd := "h00".U

      when (!isIdle(Rx_n) && PUDI) {
        state := PcsRxState.NON_IDLE_DETECT
      }.otherwise{
        state := PcsRxState.IDLE
      }
    }
    is (PcsRxState.NON_IDLE_DETECT) { 
        io.rx_symb_vector.ready := true.B

        _1000BTreceive := true.B
        io.rxerror_status := false.B
        io.rx_dv := false.B
        io.rx_er := false.B
        io.rxd := "h00".U

        when (PUDI && isSSD1(Rx_n_minus1) && isSSD2(Rx_n)) {
          state := PcsRxState.SSD1_VECTOR
        }.elsewhen(PUDI && !(isSSD1(Rx_n_minus1) && isSSD2(Rx_n))) {
          state := PcsRxState.BAD_SSD
        }.otherwise{
          state := PcsRxState.NON_IDLE_DETECT
        }
      }
      is (PcsRxState.BAD_SSD) {
        io.rx_symb_vector.ready := true.B

        _1000BTreceive := true.B
        io.rxerror_status := true.B
        io.rx_dv := false.B
        io.rx_er := true.B
        io.rxd := "h0E".U


        when (PUDI && isIdle(Rx_n)) {
          state := PcsRxState.IDLE
        }.otherwise{
          state := PcsRxState.BAD_SSD
        }
      }
      is (PcsRxState.SSD1_VECTOR) {
        io.rx_symb_vector.ready := true.B

        _1000BTreceive := true.B
        io.rxerror_status := false.B
        io.rx_dv := true.B
        io.rx_er := false.B
        io.rxd := "h55".U

        when (PUDI) {
          state := PcsRxState.SSD2_VECTOR
        }.otherwise{
          state := PcsRxState.SSD1_VECTOR
        }
      }
      is (PcsRxState.SSD2_VECTOR) {
        io.rx_symb_vector.ready := true.B

        _1000BTreceive := true.B
        io.rxerror_status := false.B
        io.rx_dv := true.B
        io.rx_er := false.B
        io.rxd := "h55".U

        when (PUDI) {
          state := PcsRxState.RECEIVE
        }.otherwise{
          state := PcsRxState.SSD2_VECTOR
        }
      }
      is (PcsRxState.RECEIVE) {
        io.rx_symb_vector.ready := true.B

        _1000BTreceive := true.B
        io.rxerror_status := false.B
        io.rx_dv := true.B
        io.rx_er := false.B
        io.rxd := io.decoded_rx_symb_vector

        when (PUDI && isDataCodeGroup(Rx_n)) {
          state := PcsRxState.RECEIVE
          io.rx_er := false.B
        }.elsewhen (PUDI && isIdle(Rx_n)) {
          io.rx_er := true.B
          state := PcsRxState.IDLE
        }.elsewhen (PUDI && isCSReset(Rx_n)) {
          io.rx_er := false.B
          io.rx_dv := false.B
          _1000BTreceive := false.B
          state := PcsRxState.CSReset
        }.elsewhen (PUDI && isXmtErr(Rx_n)) {
          io.rx_er := true.B
          state := PcsRxState.RECEIVE
        }.otherwise{
          state := PcsRxState.RECEIVE
        }
      }
      is (PcsRxState.CSReset) {
        io.rx_symb_vector.ready := true.B

        _1000BTreceive := false.B
        io.rxerror_status := false.B
        io.rx_dv := false.B
        io.rx_er := false.B
        io.rxd := io.decoded_rx_symb_vector

        when (PUDI && isCSReset(Rx_n)) {
          state := PcsRxState.ESD1
        }.otherwise{
          state := PcsRxState.CSReset
        }
      }
      is (PcsRxState.ESD1) {
        io.rx_symb_vector.ready := true.B
        
        _1000BTreceive := false.B
        io.rxerror_status := false.B
        io.rx_dv := false.B
        io.rx_er := false.B
        io.rxd := io.decoded_rx_symb_vector

        when (PUDI && isESD1(Rx_n)) {
          state := PcsRxState.ESD2
        }.otherwise{
          state := PcsRxState.ESD1
        }
      }
      is (PcsRxState.ESD2) { //maybe can be removed
        io.rx_symb_vector.ready := true.B
        
        _1000BTreceive := false.B
        io.rxerror_status := false.B
        io.rx_dv := false.B
        io.rx_er := false.B
        io.rxd := io.decoded_rx_symb_vector

        when (PUDI && isESD2(Rx_n)) {
          state := PcsRxState.IDLE
        }.otherwise{
          state := PcsRxState.ESD2
        }
      }
  }


  


}
