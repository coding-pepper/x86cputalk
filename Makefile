out/*.o: src/*.s
	python3 make.py $<

dist/x86cputalk: out/*.o
	ld -m elf_x86_64 $^ -o $@

# targets

clean:
	rm -rf dist/*
	rm -rf out/*

run: dist/x86cputalk
	./dist/x86cputalk ex/test.ct