compile: test_compiled.json

main.compiled.json: main.cairo
	cairo-compile main.cairo --output main.compiled.json

run: main.compiled.json
	cairo-run \
		--program=main.compiled.json \
		--print_output \
		--layout=small \
		--program_input=amm_input.json
