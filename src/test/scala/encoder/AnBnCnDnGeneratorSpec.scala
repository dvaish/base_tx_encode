package encoder

import chisel3._
import chisel3.experimental.BundleLiterals._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.matchers.must.Matchers

class AnBnCnDnGeneratorSpec extends AnyFreeSpec with Matchers {

  "AnBnCnDnGenerator should correctly determine outputs based on inputs" in {
    simulate(new AnBnCnDnGenerator) { dut =>

      println("Testing SignRandomizationModule...")

      // Test case 1: No sign reversal
      dut.io.sgn.poke("b0000".U)
      dut.io.tx_enable.poke(false.B)
      dut.io.tA.poke(1.S)
      dut.io.tB.poke(2.S)
      dut.io.tC.poke(-2.S)
      dut.io.tD.poke(1.S)
      dut.clock.step()
      dut.io.A.expect(1.S)
      dut.io.B.expect(2.S)
      dut.io.C.expect(-2.S)
      dut.io.D.expect(1.S)

      // Test case 2: Sign reversal on A
      dut.io.sgn.poke("b0001".U)
      dut.io.tx_enable.poke(false.B)
      dut.clock.step()
      dut.io.A.expect(-1.S)
      dut.io.B.expect(2.S)
      dut.io.C.expect(-2.S)
      dut.io.D.expect(1.S)

      // Test case 3: Global sign reversal
      dut.io.sgn.poke("b0110".U)
      dut.io.tx_enable.poke(true.B)
      dut.clock.step()
      dut.io.A.expect(-1.S)
      dut.io.B.expect(2.S)
      dut.io.C.expect(-2.S)
      dut.io.D.expect(-1.S)

      // Test case 4: Mixed sign reversal
      dut.io.sgn.poke("b1010".U)
      dut.io.tx_enable.poke(true.B)
      dut.clock.step()
      dut.io.A.expect(-1.S)
      dut.io.B.expect(2.S)
      dut.io.C.expect(2.S)
      dut.io.D.expect(1.S)

      println("All tests passed!")
    }
  }
}