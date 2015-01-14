TITLE MASM Template						(main.asm)


; Program Description: A program that asks the user to provide 2 numbers, performs arithmetic on those numbers, and prints the results to the console 
; Author: Emma Paul 
; Date Created: 10/10/2013
; Last Modification Date: 10/13/2013

INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data

; (insert variables here)
; written variables 
intro		BYTE	"Elementary Arithmetic by Emma Paul", 0
prompt		BYTE	"Please enter 2 numbers, and I'll show you the sum, difference, product, quotient, and remainder.", 0
num1Prompt	BYTE	"First number: ", 0dh, 0ah, 0
num2Prompt	BYTE	"Second number: ", 0dh, 0ah, 0
addSign		BYTE	" + ", 0
subSign		BYTE	" - ", 0
mulSign		BYTE	" x ", 0
divSign		BYTE	" ", 246, " ", 0
remSign		BYTE	"  remainder ", 0
equSign		BYTE	" = ", 0
bye			BYTE	"Impressed? Bye!!", 0

; unknown number variables (provided by user)
num1	DWORD	? ; dont' know what num1 is yet (user input num1)
num2	DWORD	? 

; unknown arithmetic result variabls 
addSum	DWORD	?
subSum	DWORD	? 
mulSum  DWORD   ?
divSum	DWORD	?
remain	DWORD	?

.code
main PROC

;intro 
mov edx, OFFSET intro ; moves intro into edx (string register)
call writeString	  ; writes intro
call crlf			  ; his return on console (ie new line)
call crlf
call crlf

;prompt
mov edx, OFFSET prompt		; moves prompt into edx 
call writeString		
call crlf
call crlf
call crlf

mov edx, OFFSET num1Prompt	; prompt for first number 
call writeString
call readInt				; reads user input and it gets stored in the eax 
call crlf
mov num1, eax				; moves user input into num1 variable 
mov edx, OFFSET num2Prompt  ; moves 2nd number prompt into edx
call writeString			; writes 2nd prompt 
call readInt				; reads in 2nd number from user input  and is stored in eax
call crlf
mov num2, eax				; assigns 2nd number from user into variable num2

;addition 
mov eax, num1				; moves num1 into eax
mov ebx, num2				; moves num2 into ebx
add eax, ebx				; adds first number to second number 
mov addsum, eax				; assigns sum addition value to addsum variable 

;subtraction 
mov eax, num1
mov ebx, num2 
sub eax, ebx				; subtracts 2nd number from first number 
mov subsum, eax				; assigns subtraction sum value to addsum variable 

;multiplication 
mov eax, num1
mov ebx, num2 
imul eax, ebx				; multiplies first number by second number 
mov mulsum, eax				; assigns multiplication sum value to addsum variable 

;divison 
mov eax, num1
cdq							; double to quad word (to deal with overflow for division operation)
mov ebx, num2 
div ebx						; divides first number by second number 
mov divsum, eax				; assigns quotient value to divsum variable
mov remain, edx				; assigns remainder value to remain variable 

;print addition value 
mov eax, num1				; moves num1 into eax
call writeDec				; prints num1
mov edx, OFFSET addSign		; moves "+" to edx
call writeString			; writes "+"
mov eax, num2				; moves num 2 to eax
call writeDec				; writes num2
mov edx, OFFSET equSign		; moves "=" to edx
call writeString			;" prints "=" 
mov eax, addsum				; moves addSum value to eax
call writedec				; writes add sum value 
call crlf					; hits return (on console) 
call crlf

;print subtraction value 
mov eax, num1
call writeDec 
mov edx, OFFSET subSign
call writeString 
mov eax, num2
call writeDec
mov edx, OFFSET equSign
call writeString  
mov eax, subsum
call writedec
call crlf 
call crlf

;print multiplication value 
mov eax, num1
call writeDec 
mov edx, OFFSET mulSign
call writeString 
mov eax, num2
call writeDec
mov edx, OFFSET equSign
call writeString 
mov eax, mulsum
call writedec 
call crlf
call crlf

;print quotient remainder value 
mov eax, num1
call writeDec 
mov edx, OFFSET divSign
call writeString 
mov eax, num2
call writeDec
mov edx, OFFSET equSign
call writeString 
mov eax, divsum
call writedec
mov edx, OFFSET remSIGN
call writeString
mov eax, remain
call writedec
call crlf
call crlf

;print goodbye 
mov edx, OFFSET bye 
call writeString
call crlf
call crlf

; (insert executable instructions here)

	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

END main