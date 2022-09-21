.PHONY: test fuzz

test:
	forge test -vvv

fuzz: 
	FOUNDRY_FUZZ_RUNS=10000 make test
