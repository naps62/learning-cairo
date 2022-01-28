compile: test_compiled.json

04-hints:
	cairo-compile $@.cairo --output $@.compiled.json
	cairo-run \
		--program=$@.compiled.json \
		--print_output \
		--layout=small \
		--program_input=$@.input.json

%:
	cairo-compile $@.cairo --output $@.compiled.json
	cairo-run \
		--program=$@.compiled.json \
		--print_output \
		--layout=small
