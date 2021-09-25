#
# Makefile that builds btest and other helper programs for the CS:APP data lab
# 
CC = gcc
#
# The -fwrapv flat instructs the GCC optimizer than overflows
# wrap around using 2's complement addition. This disables
# optimizations that can make specific problems hard to solve.
#
CFLAGS = -O0 -g -Wall -fwrapv
LIBS = -lm

default:
	@echo "Run one of make [ test-coding | test-correctness | test-ops | test-score | test-count ]"
	@echo "Or, run make grade to run all steps and get overall grade"

test-coding: btest 
	@echo "This will report coding rules violations"
	./dlc -z bits.c
	-rm bits.p.c

test-correctness: btest
	@echo "This will check if your functions are correct"
	./bddcheck/check.pl -g bits.c

test-ops: btest
	@echo "This will show illegal operations in your code"
	./dlc -Z bits.c
	-rm bits.p.c

test-score: btest
	@echo "This will report per-function scores, but 'make grade' shows overall grade"
	./bddcheck/check.pl -g -r 2

test-count: btest
	@echo "This reports the number of operations per function"
	./dlc -W1 -il -e bits.c
	-rm bits.p.c

grade: btest
	@echo Running tests..
	./driver.pl

btest: btest.c bits.c decl.c tests.c btest.h bits.h
	$(CC) $(CFLAGS) $(LIBS) -o btest bits.c btest.c decl.c tests.c

# Forces a recompile. Used by the driver program. 
btestexplicit:
	$(CC) $(CFLAGS) $(LIBS) -o btest bits.c btest.c decl.c tests.c 

clean:
	rm -f *.o btest *~


