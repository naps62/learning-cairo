CONTRACT_ADDRESS=0x005b6f99077cb8eed5482cad25f2ea0d21d5f311ab29ded2e2d0d95c966ee7bb
TX_HASH=0x30d429e8bec2d81407466baf7f3afee52f656b949bc0f0075828e4abfff494b
ACCOUNT_ADDRESS=0x4c3153043c55f4f2b5fc14e4bef66c2c64a3f14dfe507daa13ebd2933366a45

main.compiled.json abi.json: main.cairo
	starknet-compile main.cairo --output main.compiled.json --abi abi.json

deploy: main.compiled.json
	starknet deploy --contract main.compiled.json

status: FORCE
	starknet tx_status --hash $(TX_HASH)

invoke: FORCE
	starknet invoke \
    --address $(CONTRACT_ADDRESS) \
    --abi abi.json \
    --function increase_balance \
    --inputs 4321

call: FORCE
	starknet call \
			--address $(CONTRACT_ADDRESS) \
			--abi abi.json \
			--function get_balance \
			--inputs $(ACCOUNT_ADDRESS)

FORCE: ;
