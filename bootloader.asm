[ORG 0x7C00] ; <-- 0x7C00 (0000:7C00) is the address, in which BIOS loads the first sector of a bootable disk.
[BITS 16] ; <-- Tell assembler we will be using 16-bit instructions & data.

START:

        CLI ; <-- Clear IF
        CLD ; <-- Clear DF

        XOR AX, AX
        MOV DS, AX
        MOV ES, AX
        MOV FS, AX ; <-- Optional
        MOV GS, AX ; <-- Optional
        MOV SS, AX
        MOV SP, 0x8400 ; <-- Stack grows downwards from here.

        STI ; <-- Set IF

        MOV AX, 0x03 ; <-- Set text mode
        INT 0x10 ; <-- Call BIOS

        MOV AX, 0xB800 ; <-- Copy start value of VGA text mode memory into AX
        MOV ES, AX ; <-- ES = 0xB800
        XOR DI, DI ; <-- DI = 0

        MOV SI, MSG ; <-- Copy address of MSG into SI

OUTPUT_LOOP:

        LODSB
        TEST AL, AL
        JZ FINISH
        MOV AH, 0xCF ; <-- WHITE ON RED
        STOSW
        JMP OUTPUT_LOOP

FINISH:

        HLT
        JMP FINISH

        MSG DB 'BOOT SUCCESSFUL!',0 ; <-- Define MSG

TIMES 510 - ($-$$) DB 0 ; <-- Boot sector padding
DW 0xAA55 ; <-- Define 16-bit value (boot signature)
