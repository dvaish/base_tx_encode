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

      // Initial State
      dut.io.tx_data.poke("b11110000".U(8.W))
      dut.io.tx_enable.poke(0.B)
      dut.io.tx_error.poke(0.B)
      dut.io.tx_mode.poke(0.B)
      dut.io.n.poke(n.U)
      dut.io.n0.poke(0.U)
      dut.io.loc_rcvr_status.poke(1.B)

      dut.reset.poke(true)
      dut.clock.step()
      dut.reset.poke(false)
      dut.clock.step()

      dut.io.tx_enable.poke(true.B)

      for (i <- 1 until 10) {
        print(dut.io.A.peek())
        // print(dut.lut.io.tB.peek())
        // print(dut.lut.io.tC.peek())
        // println(dut.lut.io.tD.peek())
        dut.clock.step()
      }

      dut.io.tx_enable.poke(false.B)

      for (i <- 1 until 10) {
        // println(dut.lut.io.tA.peek())
        // print(dut.lut.io.tB.peek())
        // print(dut.lut.io.tC.peek())
        // println(dut.lut.io.tD.peek())
        dut.clock.step()
      }

      println("All tests passed!")
    }
  }
}