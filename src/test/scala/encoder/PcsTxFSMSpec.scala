package encoder

import chisel3._
import chisel3.experimental.BundleLiterals._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.matchers.must.Matchers

class PcsTxFSMSpec extends AnyFreeSpec with Matchers {

  "PcsTxFSM should correctly transition between states and control outputs" in {
    simulate(new PcsTxFSM) { dut =>

      println("Testing PcsTxFSM...")

      val SEND_N = 0.U

      // Helper: Start in disabled state
      dut.io.pcs_reset.poke(true.B)
      dut.io.link_status.poke(false.B)
      dut.io.tx_mode.poke(1.U) // not SEND_N
      dut.io.TX_EN.poke(false.B)
      dut.io.TX_ER.poke(false.B)
      dut.clock.step()

      // Check we are in DisableDataTransmission
      dut.io.tx_enable.expect(false.B)
      dut.io.tx_error.expect(false.B)
      dut.io.state.expect(PcsTxFSM.State.DisableDataTransmission)

      // Enable condition: pcs_reset = 0, link_status = true, tx_mode = SEND_N
      dut.io.pcs_reset.poke(false.B)
      dut.io.link_status.poke(true.B)
      dut.io.tx_mode.poke(SEND_N)
      dut.clock.step()

      // Expect transition to EnableDataTransmission
      dut.io.state.expect(PcsTxFSM.State.EnableDataTransmission)

      // Drive TX_EN and TX_ER, check outputs match
      dut.io.TX_EN.poke(true.B)
      dut.io.TX_ER.poke(true.B)
      dut.clock.step()
      dut.io.tx_enable.expect(true.B)
      dut.io.tx_error.expect(true.B)

      // Change tx_mode ≠ SEND_N → should return to DisableDataTransmission
      dut.io.tx_mode.poke(2.U) // != SEND_N
      dut.clock.step()
      dut.io.state.expect(PcsTxFSM.State.DisableDataTransmission)
      dut.io.tx_enable.expect(false.B)
      dut.io.tx_error.expect(false.B)

      println("All tests passed!")
    }
  }
}
