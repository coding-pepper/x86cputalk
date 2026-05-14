
out/main.o: src/main.s src/include.s
	nasm -f elf64 $< -o $@

out/exit.o: src/exit.s src/include.s
	nasm -f elf64 $< -o $@

out/writef.o: src/writef.s src/include.s
	nasm -f elf64 $< -o $@

dist/x86cputalk: out/main.o out/writef.o out/exit.o
	ld $^ -o $@

# targets

clean:
	rm -rf dist/*
	rm -rf out/*

run: dist/x86cputalk
	./dist/x86cputalk ex/test.ct