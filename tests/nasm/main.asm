section	.text
    global _start

_start:

    xor	eax, eax
    lea	edx, [rax+len]
    mov	al, 1
    mov	esi, msg
    mov	edi, eax
    syscall

    xor	edi, edi
    lea	eax, [rdi+60]
    syscall

section	.rodata

msg	db 'hello, world', 0xa
len	equ	$ - msg