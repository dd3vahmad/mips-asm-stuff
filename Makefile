# Makefile for running MARS with a simple command
# Usage: make mipsE

# Path to the JAR
MARS_JAR = Mars4_5.jar

# Default source file (edit as needed)
SRC = mips.asm

# Flags for MARS (editable)
# -noGui: runs in CLI mode
# -asm: assemble only
# -exe: assemble + run
# -nc: no warnings about compact code
MARS_FLAGS = nc sm

# Run your MIPS program
mipsE:
	java -jar $(MARS_JAR) $(MARS_FLAGS) $(SRC)

# For assembling only (no execution)
assemble:
	java -jar $(MARS_JAR) a $(SRC)

# Clean junk files created by MARS
clean:
	rm -f *.log *.txt *.db *.obj

# Debug run (prints syscall trace)
debug:
	java -jar $(MARS_JAR) $(MARS_FLAGS) me $(SRC)
