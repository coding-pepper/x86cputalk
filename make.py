import sys, os

i = sys.argv[1]

os.system(f"nasm -f elf64 {i} -o {i.replace('src/', 'out/').replace('.s', '.o')}")