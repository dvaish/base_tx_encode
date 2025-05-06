# TX Encoder

`make run` will elaborate the Encoder and run the testbench. Under the hood, it is using `sbt run` to elaborate and `vcs` to simulate the test harness. Note that port names are manually ported over for now. This also runs `clean`

`make clean` cleans up the workspace and removes all of the test collateral.
