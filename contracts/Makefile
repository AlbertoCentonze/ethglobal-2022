.PHONY: test fuzz

test:
	forge test -vv

fuzz: 
	FOUNDRY_FUZZ_RUNS=10000 make test
	