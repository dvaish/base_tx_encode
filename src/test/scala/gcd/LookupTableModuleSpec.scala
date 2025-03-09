package encoder

import chisel3._
import chisel3.experimental.BundleLiterals._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.matchers.must.Matchers

class LookupTableModuleSpec extends AnyFreeSpec with Matchers {

  "LookupTableModule should correctly map inputs to outputs" in {
    simulate(new LookupTableModule) { dut =>

      println("Testing LookupTableModule...")

      // Test case 1: Normal condition lookup
      dut.io.condition.poke(Condition.Normal)
      dut.io.sdn_5_0.poke("b111111".U)
      dut.io.sdn_6_8.poke("b111".U)
      dut.clock.step()
      dut.io.tA.expect(-2.S)
      dut.io.tB.expect(-1.S)
      dut.io.tC.expect(-2.S)
      dut.io.tD.expect(2.S)

      // Test case 2: lookupTable_xxxxxx entry
      dut.io.condition.poke(Condition.CSReset)
      dut.io.sdn_6_8.poke("b111".U)
      dut.io.sdn_5_0.poke("b000011".U)
      dut.clock.step()
      dut.io.tA.expect(2.S)
      dut.io.tB.expect(-1.S)
      dut.io.tC.expect(-2.S)
      dut.io.tD.expect(2.S)

      println("All tests passed!")
    }
  }
}
