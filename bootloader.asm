[ORG 0]

BOOTSEG EQU 0x07C0 ; This is the segment we use to boot, it's where BIOS loads our bootloader.asm
INITSEG EQU 0x9000 ; We use this to move out of the way before anything serious
VGA_ATTR EQU 0x0F ; Attribute byte for VGA printing
STACK_PTR EQU 0x8400 ; This is our stack pointer value
VGASEG EQU 0xB800 ; This is our VGA text mode segment

START:

        CLI ; Disable interrupts
        CLD ; Confirm the direction flag is cleared

        MOV AX, BOOTSEG
        MOV DS, AX
        MOV ES, AX

        XOR AX, AX
        MOV FS, AX
        MOV GS, AX

        MOV AX, INITSEG
        MOV SS, AX
        MOV SP, STACK_PTR

        MOV AX, 0x03
        INT 0x10

        MOV AX, VGASEG
        MOV ES, AX
        XOR DI, DI

        MOV SI, MSG

OUTPUT_LOOP:

        LODSB
        OR AL, AL
        JZ FINISH
        MOV AH, VGA_ATTR
        STOSW
        JMP OUTPUT_LOOP

FINISH:

        HLT
        JMP FINISH

        MSG DB 'BOOT SUCCESSFUL!',0 ; <-- Message to print

TIMES 510 - ($-$$) DB 0 ; Bootloader padding
DW 0xAA55 ; Boot signature ( 55, AA )
