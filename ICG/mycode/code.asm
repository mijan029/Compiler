.MODEL SMALL
.STACK 100H
.DATA

		number DB "00000$"
.CODE

	main proc
		mov ax, @DATA
		mov ds, ax
		push bp
		mov bp, sp
		sub sp, 2
		sub sp, 2
		sub sp, 2
		mov ax,3
		push ax
		pop ax
		mov [bp-2], ax
		push ax
		pop ax
		mov ax,8
		push ax
		pop ax
		mov [bp-4], ax
		push ax
		pop ax
		mov ax,6
		push ax
		pop ax
		mov [bp-6], ax
		push ax
		pop ax
		mov ax, [bp-2]
		push ax
		mov ax,3
		push ax
		pop bx
		pop ax
		cmp ax,bx
		je L1
		mov ax,0
		jmp L2
L1:
		mov ax,1
L2:
		push ax
		pop ax
		cmp ax,0
		je L3
		mov ax, [bp-4]
		call print_from_ax
		add sp,0
		jmp L4
L3:
L4:
		mov ax, [bp-4]
		push ax
		mov ax,8
		push ax
		pop bx
		pop ax
		cmp ax,bx
		jl L5
		mov ax,0
		jmp L6
L5:
		mov ax,1
L6:
		push ax
		pop ax
		cmp ax,0
		je L7
		mov ax, [bp-2]
		call print_from_ax
		add sp,0
		jmp L8
L7:
		mov ax, [bp-6]
		call print_from_ax
		add sp,0
L8:
		mov ax, [bp-6]
		push ax
		mov ax,6
		push ax
		pop bx
		pop ax
		cmp ax,bx
		jne L9
		mov ax,0
		jmp L10
L9:
		mov ax,1
L10:
		push ax
		pop ax
		cmp ax,0
		je L11
		mov ax, [bp-6]
		call print_from_ax
		add sp,0
		jmp L12
L11:
		mov ax, [bp-4]
		push ax
		mov ax,8
		push ax
		pop bx
		pop ax
		cmp ax,bx
		jg L13
		mov ax,0
		jmp L14
L13:
		mov ax,1
L14:
		push ax
		pop ax
		cmp ax,0
		je L15
		mov ax, [bp-4]
		call print_from_ax
		add sp,0
		jmp L16
L15:
		mov ax, [bp-2]
		push ax
		mov ax,5
		push ax
		pop bx
		pop ax
		cmp ax,bx
		jl L17
		mov ax,0
		jmp L18
L17:
		mov ax,1
L18:
		push ax
		pop ax
		cmp ax,0
		je L19
		mov ax, [bp-2]
		call print_from_ax
		add sp,0
		jmp L20
L19:
		mov ax,0
		push ax
		pop ax
		mov [bp-6], ax
		push ax
		pop ax
		mov ax, [bp-6]
		call print_from_ax
		add sp,0
L20:
L16:
L12:
		mov ax,0
		push ax
		pop ax
		jmp L21
L21:
		add sp,6
		mov ax,4ch
		int 21H
	main endp

	PRINT_NEWLINE PROC
        PUSH AX
        PUSH DX
        MOV AH, 2
        MOV DL, 0Dh
        INT 21h
        MOV DL, 0Ah
        INT 21h
        POP DX
        POP AX
        RET
    PRINT_NEWLINE ENDP
	print_from_ax proc  ;print what is in ax
		push ax
		push bx
		push cx
		push dx
		push si
		lea si,number
		mov bx,10
		add si,4
		cmp ax,0
		jnge negate
		print:
		xor dx,dx
		div bx
		mov [si],dl
		add [si],'0'
		dec si
		cmp ax,0
		jne print
		inc si
		lea dx,si
		mov ah,9
		int 21h
		pop si
		pop dx
		pop cx
		pop bx
		pop ax
		call PRINT_NEWLINE
		ret
		negate:
		push ax
		mov ah,2
		mov dl,'-'
		int 21h
		pop ax
		neg ax
		jmp print
	print_from_ax endp
END MAIN

