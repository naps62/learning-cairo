CONTRACT_ADDRESS=0x03ff4b9436b784cefa44a988c62b99e665de82819c3b05f238bd39389c6387c6
TX_HASH=0x741783b7dbb393ae014fccb5ae0cba1a2020ed36ed405a893e129926e5401ef

main.compiled.json abi.json: main.cairo
	starknet-compile main.cairo --output main.compiled.json --abi abi.json

deploy: main.compiled.json
	starknet deploy --contract main.compiled.json

increase: FORCE
	starknet invoke \
		--address $(CONTRACT_ADDRESS) \
		--abi abi.json \
		--function increase_balance \
		--inputs 1234

status: FORCE
	starknet tx_status --hash $(TX_HASH)

call: FORCE
	starknet call \
		--address $(CONTRACT_ADDRESS) \
		--abi abi.json \
		--function get_balance

FORCE: ;
