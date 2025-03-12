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

      var n = 0

      dut.io.tx_data.poke("b11110000".U(8.W))
      dut.io.tx_enable.poke(1.B)
      dut.io.tx_error.poke(0.B)
      dut.io.tx_mode.poke(0.B)
      dut.io.n.poke(n.U)
      dut.io.n0.poke(0.U)
      dut.io.loc_rcvr_status.poke(1.B)

      dut.reset.poke(true)
      dut.clock.step()
      dut.reset.poke(false)
      dut.clock.step()

      for (i <- 1 to 10) {
        dut.clock.step()
        n = n + 1
        dut.io.n.poke(n.U)
      }

      println("All tests passed!")
    }
  }
}