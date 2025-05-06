package encoder

import chisel3._
import chisel3.experimental.BundleLiterals._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.matchers.must.Matchers
import chisel3.util.Counter
// import {Condition, LookupTableModule}

class PulseShapingFilterSpec extends AnyFreeSpec with Matchers {

  "Encoder should output the correct values based on the test sequence" in {
    simulate(new PulseShapingFilter()) { dut =>

      var n = 0
      val p = (A: SInt, B: SInt, C: SInt, D: SInt) => {

      }

      // Initial State


      dut.reset.poke(true)
      dut.clock.step()
      dut.reset.poke(false)
      dut.clock.step()

      dut.io.A.poke(2.S(3.W))
      dut.io.B.poke(2.S(3.W))
      dut.io.C.poke(2.S(3.W))
      dut.io.D.poke(2.S(3.W))

    print(f"${dut.io.Ashaped.peek().litValue.toInt} ")
    print(f"${dut.io.Bshaped.peek().litValue.toInt} ")
    print(f"${dut.io.Cshaped.peek().litValue.toInt} ")
    println(f"${dut.io.Dshaped.peek().litValue.toInt}")

      dut.clock.step()

      dut.io.A.poke(2.S(3.W))
      dut.io.B.poke(2.S(3.W))
      dut.io.C.poke(2.S(3.W))
      dut.io.D.poke(-2.S(3.W))

    print(f"${dut.io.Ashaped.peek().litValue.toInt} ")
    print(f"${dut.io.Bshaped.peek().litValue.toInt} ")
    print(f"${dut.io.Cshaped.peek().litValue.toInt} ")
    println(f"${dut.io.Dshaped.peek().litValue.toInt}")

      dut.clock.step()

      dut.io.A.poke(0.S(3.W))
      dut.io.B.poke(0.S(3.W))
      dut.io.C.poke(0.S(3.W))
      dut.io.D.poke(0.S(3.W))

    print(f"${dut.io.Ashaped.peek().litValue.toInt} ")
    print(f"${dut.io.Bshaped.peek().litValue.toInt} ")
    print(f"${dut.io.Cshaped.peek().litValue.toInt} ")
    println(f"${dut.io.Dshaped.peek().litValue.toInt}")

      dut.clock.step()

    }
  }
}
