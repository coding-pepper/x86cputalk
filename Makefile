
out/main.o: src/main.s src/include.s
	nasm -f elf64 $< -o $@

out/exit.o: src/exit.s src/include.s
	nasm -f elf64 $< -o $@

out/writef.o: src/writef.s src/include.s
	nasm -f elf64 $< -o $@

out/memcmp.o: src/memcmp.s src/include.s
	nasm -f elf64 $< -o $@

out/open.o: src/open.s src/include.s
	nasm -f elf64 $< -o $@

out/fread.o: src/fread.s src/include.s
	nasm -f elf64 $< -o $@

out/brk.o: src/brk.s src/include.s
	nasm -f elf64 $< -o $@

dist/x86cputalk: out/main.o out/writef.o out/exit.o out/memcmp.o out/open.o out/fread.o out/brk.o
	ld -nostdlib --build-id=none $^ -o $@
	strip $@

# targets

clean:
	rm -rf dist/*
	rm -rf out/*

build: dist/x86cputalk

run: dist/x86cputalk
	./dist/x86cputalk ex/concept.ct dist/dev.o