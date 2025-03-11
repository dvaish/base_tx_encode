package encoder 

import chisel3._
import chisel3.experimental.BundleLiterals._
import chisel3.simulator.EphemeralSimulator._
import org.scalatest.freespec.AnyFreeSpec
import org.scalatest.matchers.must.Matchers
// import SideStreamScrambler

class SideStreamScramblerSpec extends AnyFreeSpec with Matchers {

  val init = 1.U(33.W)

  "Gcd should calculate proper greatest common denominator" in {
    simulate(new SideStreamScrambler(true, init)) { dut =>

        dut.reset.poke(true.B)
        dut.clock.step()
        dut.reset.poke(false.B)
        dut.clock.step()

        for (i <- 1 to 33) {
            val output = dut.io.scrn.peek()
            dut.clock.step()
        }
 
    }
  }
}