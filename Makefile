.PHONY: run clean

run:
	sbt run
	vcs -full64 src/test/verilog/encoder/encoder_tb.sv -sverilog +incdir+. -R
	rm -r *.trn *.dsn *.key simv *.daidir obj_dir csrc
	$(MAKE) clean

clean:
	@echo "Cleaning up..."
	rm -r *.trn *.dsn *.key simv *.daidir obj_dir csrc .simvision