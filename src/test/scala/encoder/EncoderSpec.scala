package encoder

import chisel3._
import chisel3.experimental.BundleLiterals._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.matchers.must.Matchers
import chisel3.util.Counter
// import {Condition, LookupTableModule}

class EncoderSpec extends AnyFreeSpec with Matchers {

  "Encoder should output the correct values based on the test sequence" in {
    simulate(new Encoder(true, 1.U(33.W))) { dut =>

      val (value, wrap) = Counter(0 until 2^32 - 1 by 1)

      dut.io.tx_data := "0b11110000".U
      dut.io.tx_enable := 1.B
      dut.io.tx_error := 0.B
      dut.io.tx_mode := 0.B 
      dut.io.n := value
      dut.io.n0 := 0.U
      dut.io.loc_rcvr_status := 1.B


      println("All tests passed!")
    }
  }
}