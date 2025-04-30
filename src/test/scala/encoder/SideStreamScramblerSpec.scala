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

        for (i <- 1 to 33) {
            val output = dut.io.scrn(0).peek().litValue.toInt
            println(output)
            dut.clock.step()
        }
 
    }
  }
}