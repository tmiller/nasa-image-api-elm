SRC = src/Main.elm
OUT = elm.js
MIN = elm.min.js

.PHONY: production dev clean


production: clean $(MIN)

$(OUT): $(SRC)
	elm make --optimize $< --output=$@

$(MIN): $(OUT)
	closure-compiler --compilation_level ADVANCED --warning_level QUIET --js $< --js_output_file $@

dev:
	elm-live $(SRC) --output=$(OUT) --pushstate --debug

clean:
	rm -f $(OUT) $(MIN)