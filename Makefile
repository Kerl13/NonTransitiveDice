DEPS = src/misc.pl

.PHONY: all part1 part2 clean

all:
	@echo "Part 1: make part1"
	@echo "Part 2: make part2"
	@echo "Part 3: make part3"

part1: check
	./$<

part2: generate
	./$<

check: src/check.pl $(DEPS)
	swipl -o $@ -c $<

generate: src/generate.pl $(DEPS)
	swipl -o $@ -c $<

clean:
	rm -f check generate
