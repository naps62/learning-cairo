compile: test_compiled.json

main.compiled.json: main.cairo
	cairo-compile main.cairo --output main.compiled.json

batch1: main.compiled.json
	cairo-run \
		--program=main.compiled.json \
		--print_output \
		--layout=small \
		--program_input=voting_input.json

batch2: main.compiled.json
	cairo-run \
		--program=main.compiled.json \
		--print_output \
		--layout=small \
		--program_input=voting_input2.json
