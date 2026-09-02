;intel_syntax noprefix
extern putchar

section .data

section .text
global main

main:
	mov ax, 2
	mov bx, 4
	mul bx
	jmp print_ax
print_ax:
	mov si, ax
	mov dx, 5
	mov edi, 1
	call putchar
	jmp exit

exit:
	mov ax, 60
	syscall
