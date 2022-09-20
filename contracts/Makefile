.PHONY: test fuzz

test:
	MATIC_RPC_URL="https://rpc.ankr.com/polygon" forge test -vv

fuzz: 
	FOUNDRY_FUZZ_RUNS=10000 make test
