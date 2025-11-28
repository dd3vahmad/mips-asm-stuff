# Makefile for running SPIM/QtSPIM from command line
# Usage: make run

SPIM = qtspim
SRC = mips.asm

# -file: load this program
# -exception: use default exception handler
# -quiet: suppress the SPIM banner
# -nostatus: hide register/memory dumps
# -nofileio: forbid File I/O syscalls (class-safe)
SPIM_FLAGS = -file $(SRC) -exception -quiet -nostatus

run:
	$(SPIM) $(SPIM_FLAGS)

dev:
	$(SPIM) $(SRC)

debug:
	$(SPIM) -file $(SRC)

clean:
	rm -f *.log *.txt *.db *.obj
