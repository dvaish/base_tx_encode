.PHONY: run clean test

run:
	sbt run
	vcs -full64 src/test/verilog/encoder/encoder_tb.sv -sverilog +incdir+. -R

test: 
	vcs -full64 src/test/verilog/encoder/encoder_tb.sv -sverilog +incdir+. -R

clean:
	@rm -r *.trn *.dsn *.key simv *.daidir obj_dir csrc .simvision simvision* 


test