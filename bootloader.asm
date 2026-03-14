[ORG 0x7c00] ; <-- The assembler will make this code load at this specified physical address 
[BITS 16] ; Specify assembler to assemble for 16-bit (real mode)

start:

	cli ; Set IF to 0 (false)
	cld ; Set DF to 0 (false)
	xor ax, ax ; Clear ax
	mov ds, ax ; Clear ds
	mov es, ax ; Clear es
	mov fs, ax ; Clear fs (optional)
	mov gs, ax ; Clear gs (optional)
	mov ss, ax ; Clear ss
	mov sp, 0x7c00 ; <-- Stack grows down from here 
	sti ; Set IF to 1 (true)

	mov si, msg ; Load msg address into si
	xor bh, bh ; Clear bh 
	mov ah, 0x0e ; Select teletype output

output:

	lodsb ; Load string byte at DS:SI to AL and increment SI
	test al, al ; Use bitwise to check if al is 0 (end of string)
	je finish ; Jump to finish if AL = 0
	int 0x10 ; Call BIOS video services
	jmp output ; Jump to output

finish:

	hlt ; Halt until the next interrupt
	jmp finish ; Jump to finish (stop)

	msg: db 'Boot successful!' , 13, 10, 0 ; Define msg, with a newline

times 510 - ($-$$) db 0 ; Pad boot sector
dw 0xAA55 ; Define final two bytes: (55 , AA) (boot signature)
