;intel_syntax noprefix
section .data

section .text
global _start
_start:
	mov ax, 2
	mov bx, 4
	mul bx
	jmp exit
exit:
	mov ax, 60
	syscall
