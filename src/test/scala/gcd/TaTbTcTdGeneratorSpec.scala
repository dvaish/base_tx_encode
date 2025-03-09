package encoder

import chisel3._
import chisel3.experimental.BundleLiterals._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.matchers.must.Matchers

class TaTbTcTdGeneratorSpec extends AnyFreeSpec with Matchers {

  "ConditionBasedSymbolGenerator should correctly determine symbols based on inputs" in {
    simulate(new TaTbTcTdGenerator) { dut =>

      println("Testing ConditionBasedSymbolGenerator...")

      // Test case 1: Normal operation
      dut.io.tx_enable_n.poke(true.B)
      dut.io.tx_enable_n1.poke(false.B)
      dut.io.tx_enable_n2.poke(true.B)
      dut.io.tx_enable_n3.poke(false.B)
      dut.io.tx_enable_n4.poke(true.B)

      dut.io.tx_error_n.poke(false.B)
      dut.io.tx_error_n1.poke(false.B)
      dut.io.tx_error_n2.poke(false.B)
      dut.io.tx_error_n3.poke(false.B)

      dut.io.csreset_n.poke(false.B)
      dut.io.txd.poke("h0F".U)

      dut.io.sdn_5_0.poke("b000000".U)
      dut.io.sdn_6_8.poke("b000".U)
      dut.clock.step()

      // Expected outputs for this test case
      dut.io.tA.expect(0.S)
      dut.io.tB.expect(0.S)
      dut.io.tC.expect(0.S)
      dut.io.tD.expect(0.S)

      // Test case 2: TX error triggered, expecting "xmt_err"
      dut.io.tx_enable_n.poke(true.B)
      dut.io.tx_enable_n1.poke(true.B)
      dut.io.tx_error_n.poke(true.B)
      dut.io.csreset_n.poke(false.B)
      dut.clock.step()

      // Expected outputs for "xmt_err"
      dut.io.tA.expect(0.S) // Adjust based on expected table values
      dut.io.tB.expect(2.S)
      dut.io.tC.expect(2.S)
      dut.io.tD.expect(0.S)

      // Test case 3: CSReset triggered
      dut.io.tx_error_n.poke(false.B)
      dut.io.csreset_n.poke(true.B)
      dut.clock.step()

      // Expected outputs for "CSReset"
      dut.io.tA.expect(2.S) // Adjust based on expected table values
      dut.io.tB.expect(-2.S)
      dut.io.tC.expect(-2.S)
      dut.io.tD.expect(2.S)

      println("All tests passed!")
    }
  }
}
