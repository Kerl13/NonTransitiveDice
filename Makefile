.PHONY: all part1 part2 clean

all:
	@echo "Part 1: make part1"
	@echo "Part 2: make part2"
	@echo "Part 3: make part3"

part1: check
	./$<

part2: generate
	./$<

part3: optimal
	./$<

check: src/check.pl
	swipl -o $@ -c $<

generate: src/generate.pl
	swipl -o $@ -c $<

optimal: src/optimal.pl
	swipl -o $@ -c $<

clean:
	rm -f check generate optimal
