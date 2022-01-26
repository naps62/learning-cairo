compile: test_compiled.json

%:
	cairo-compile $@.cairo --output $@.compiled.json
	cairo-run \
		--program=$@.compiled.json \
		--print_output \
		--layout=small \
		--tracer
