all: os-image.bin

# Combine bootloader and kernel into a single disk image
os-image.bin: boot.bin kernel.bin
	cat boot.bin kernel.bin > os-image.bin

# Compile bootloader assembly
boot.bin: boot.asm
	nasm -f bin boot.asm -o boot.bin

# Link kernel object into raw binary format
kernel.bin: kernel.o
	ld -m elf_i386 -T linker.ld -o kernel.bin --oformat binary kernel.o

# Compile C kernel to 32-bit object file (-ffreestanding means no standard library)
kernel.o: kernel.c
	gcc -m32 -ffreestanding -c kernel.c -o kernel.o

clean:
	rm -f *.bin *.o os-image.bin