# .PHONY: run clean test

# run:
# 	sbt run
# 	vcs -full64 src/test/verilog/encoder/encoder_tb.sv -sverilog +incdir+. -R

# test: 
# 	vcs -full64 src/test/verilog/encoder/encoder_tb.sv -sverilog +incdir+. -R

# clean:
# 	@rm -r *.trn *.dsn *.key simv *.daidir obj_dir csrc .simvision simvision* 


.PHONY: run clean test

run:
	sbt run
	vcs -full64 src/test/verilog/encoder/encoder_txrx_tb.sv -sverilog +incdir+. -R
	cp Encoder_TXRX_SM.sv /scratch/eecs251b-abg/sp25-chipyard-aniket-sadashiva/vlsi/encoder

test: 
	vcs -full64 src/test/verilog/encoder/encoder_txrx_tb.sv -sverilog +incdir+. -R
	python channel_model.py
	vcs -full64 src/test/verilog/encoder/FFE_tb.sv -sverilog +incdir+. -R
	vcs -full64 src/test/verilog/encoder/lapdfd_tb.sv -sverilog +incdir+. -R

clean:
	@rm -r *.trn *.dsn *.key simv *.daidir obj_dir csrc .simvision simvision*

test_ffe:
	vcs -full64 src/test/verilog/encoder/FFE_tb.sv -sverilog +incdir+. -R
test_fd:
	vcs -full64 src/test/verilog/encoder/lapdfd_tb.sv -sverilog +incdir+. -R


