; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««

;                 Build this with the "Project" menu using
;                       "Console Assemble and Link"

; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««

.486                                    ; create 32 bit code
.model flat, stdcall                    ; 32 bit memory model
option casemap :none                    ; case sensitive

include \masm32\include\windows.inc     ; always first
include \masm32\macros\macros.asm       ; MASM support macros

; -----------------------------------------------------------------
; include files that have MASM format prototypes for function calls
; -----------------------------------------------------------------
include \masm32\include\masm32.inc
include \masm32\include\gdi32.inc
include \masm32\include\user32.inc
include \masm32\include\kernel32.inc

; ------------------------------------------------
; Library files that have definitions for function
; exports and tested reliable prebuilt code.
; ------------------------------------------------
includelib \masm32\lib\masm32.lib
includelib \masm32\lib\gdi32.lib
includelib \masm32\lib\user32.lib
includelib \masm32\lib\kernel32.lib

.data 
	str1 db 'ABCDEFA', 00h
	str2 db 'ABCDEFAA', 00h
.code                       ; Tell MASM where the code starts

; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««

start:                          ; The CODE entry point to the program
    call main
    exit

; «««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««««

main:	
	push ebp
	mov ebp,esp
	push 4
	push 2
	call Pow
	pop ebx
	pop ebx
	print str$(eax),10
	
	push offset str2
	push offset str1
	call Strcmp
	pop ebx
	pop ebx
	print str$(eax),10
	
	
	push 7
	call fibo
	pop ebx
	print str$(eax),10
	pop ebx
	pop ebp
	ret
	
Pow:	
	push ebp
	mov ebp,esp
	push ecx
	mov eax, 1 ; eax = base
	mov ecx, [ebp+12] ; ecx = exponent parameter2
	powloop:
		mul DWORD PTR[ebp+8] ; eax *= base parameter1
		loop powloop
		
	pop ecx
	pop ebp
	ret
	
Strcmp:
	push ebp
	mov ebp,esp
	push ebx
	push esi
	xor ebx,ebx 
	
	charcmp:
		mov esi,[ebp+8]  ;esi = &str1
		mov al,[esi+ebx*1] ;al = str1[ebx]
		mov esi,[ebp+12] ;esi = &str2
		sub al,[esi+ebx*1] ; str1[ebx]-str2[ebx]
		jne continue 
			mov esi,[ebp+8]
			cmp byte ptr[esi+ebx*1],00h ;if we reach the end of str1
			je continue
			mov esi,[ebp+12]
			cmp byte ptr[esi+ebx*1],00h ;if we reach the end of str2
			je continue
			inc ebx
			jmp charcmp
	
	continue:
	movsx eax,al
	pop esi
	pop ebx
	pop ebp
	ret
	
fibo:
	push ebp
	mov ebp,esp
	push ecx
	push ebx
	mov ecx,[ebp+8] 
	cmp ecx,2 
	ja not1or2 ; if n>2 return 1
	mov eax,1 
	JMP theend
	
	not1or2: ; else
		dec ecx 
		push ecx
		call fibo ;eax = fibo(n-1)
		pop ecx
		mov ebx,eax ; ebx = eax -> ebx = fibo(n-1)
		dec ecx
		push ecx
		call fibo ;eax = fibo(n-2) 
		pop ecx
		add eax,ebx ;eax += ebx -> eax = fibo(n-1)+fibo(n-2)
	
	theend:
	pop ebx
	pop ecx
	pop ebp
	ret
end start                       ; Tell MASM where the program ends
