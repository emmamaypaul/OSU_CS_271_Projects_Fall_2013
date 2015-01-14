TITLE Program Template			(template.asm)

; Program Description:
; Author:
; Date Created:
; Last Modification Date:

INCLUDE Irvine32.inc

; (insert symbol definitions here)

.data
;constants
UPPERLIMIT = 46 ; highest integer user input can be 
LOWERLIMIT = 0  ; lowest integer user input can be

; (insert variables here)
fib_title	BYTE	"Fibonacci Numbers", 0
myName		BYTE	"Programmed by Emma Paul", 0
getName		BYTE	"What's your name?", 0
hello		BYTE	"Hello, ", 0
prompt1		BYTE	"Enter the number of Fibonacci terms to be displayed", 0
prompt2		BYTE	"Give the number as an integer in the range [1...46].", 0
prompt3		BYTE	"How many Fibonacci terms do you want?", 0
error_1		BYTE	"Out of range. Enter a number in [1...46].", 0
farewell	BYTE	"Result certified by Leonardo Pisano.", 0
			BYTE	"Goodbye, ", 0


fibnum			DWORD	? 
tempFibNum		DWORD	? 
count			DWORD	1		; start count at 1 to increment while printing rather than decrementing the user num
divFive			DWORD	5
remainder		DWORD	?
userName	BYTE	33 DUP(0)	;string to be entered by user

.code
main PROC
; (insert executable instructions here)

;intro 
mov		edx, OFFSET	fib_title
call	writestring 
call	Crlf 
call	Crlf
mov	edx, OFFSET	myname 
call	writestring 
call	Crlf
call	Crlf


;get user name 
mov		edx, OFFSET getName		; move name prompt into edx 
call	writestring				; ask 
call	crlf
call	Crlf					; return 
mov		edx, OFFSET userName 
mov		ecx, 50					; set ECX to the maximum number of characters the user can enter
call	ReadString				; reads name into edx 
mov		edx, OFFSET hello
call	crlf
call	writeString 
mov		edx, OFFSET username 
call	writestring
call	crlf 
call	Crlf

;prompt to get fibnum
mov edx, OFFSET prompt1
call writeString 
call crlf
call	Crlf
mov edx, OFFSET prompt2
call writeString
call crlf
call	Crlf

userNumber:
	mov edx, OFFSET prompt3
	call writeString
	call crlf
	call readInt 
	cmp		eax, LOWERLIMIT				; compare n to 0 
	jle		errorReport					; if n =< 0, go to error message 
	cmp		eax, UPPERLIMIT				; compare n to 46
	jg		errorReport					; if n > 46
	jmp		fib_Start_Block					; go to calculating fib numbers 

errorReport:
	mov	edx, OFFSET	error_1
	call crlf
	call writeString
	call crlf 
	jmp userNumber						; jump back to getting user number after error message 

fib_Start_block: 
	mov ebx, 1							; start ebx at 1 
	mov edx, 0							; start edx at 0
	mov ecx, eax						; put the fib number into ecx for storage 
 

L1:										; iteration loop to produce fib numbers (growing in order)
	mov eax, ebx						; put ebx into eax (ebx is used for storage, free at this point)
	add eax, edx						; adds 1st fib number (edx) to 2nd fib number (eax)
	mov ebx, edx						; mov edx to ebx to free edx 
	mov edx, eax						; put sum of 1st and 2nd fib number to edx
	call writeDec						; print fib num
	mov tempFibNum, edx					; stores value of edx 

; when count is divisible by 5 we will do a line break and hit return in order to print 5 per line 
	mov eax, count						; nothing important is in eax, start count at 1 
	cdq									; dword to qword (needed for some reason)
	div	divFive							; automatically divides eax/limiter and stores quotient in eax 
	mov remainder, edx					; remainder automatically goes to edx 
	cmp remainder, 0					; if remainder is 0 we know we want to hit return because its a multiple of 5 with no remainder
	jne tabs
	je	newline 

newline: 
	call crlf
	jmp loopEnd

tabs: 
	mov al, TAB							; you put tab in AL since it's so small 
	call writeChar						; writes the tab 
	cmp	count, 36						; makes it look nice at the 36th number visually 
	jge loopend 
	call writechar						; writes another tab 

loopend: 
	mov edx, tempFibNum 
	inc count 
	loop L1

	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

END main