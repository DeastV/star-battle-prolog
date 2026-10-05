# Star Battle Prolog Solver Makefile

SWIPL ?= swipl

.PHONY: all test repl clean

all: test

test:
	cd src && $(SWIPL) -l projecto.pl -g run_tests -t halt ../tests/test_solver.pl

repl:
	cd src && $(SWIPL) -l projecto.pl

clean:
	find . -type f -name "*~" -delete
	find . -type f -name "*.swp" -delete
	find . -type f -name ".swipl_history" -delete
