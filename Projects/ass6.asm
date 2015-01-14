TITLE Program Template			(template.asm)

; Program Description: This program demonstrates low-level I/O procedures, (MACROS and PROCEDURES). 
;						It takes 10 unsigned integers that fit inside a 32 bit register from a user. 
;						It then displays the numbers entered by the user as well as the sum and average. 
;						It also verify's that the user's numbers are valid and prompts the user with an error message if it is invalid. 
; Author: Emma Paul 
; Date Created: 12/4/2013
; Last Modification Date:

INCLUDE Irvine32.inc
; (insert symbol definitions here)
;constants
ARRAY_LNGTH = 10

prgPrmpt MACRO titlebuf, disbuf
	push edx														; push ecx to specify max num of characters 
	mov edx, OFFSET titlebuf
	call writeString
	call crlf 
	call crlf 
	mov edx, OFFSET disbuf 
	call writeString 
	call crlf 
	call crlf
	pop edx 
ENDM



getString MACRO getStbuf, readStbuf, sizebuf				; display parameter and readstring parameter  														
	push edx												; push ecx to specify max num of characters 
	mov edx, OFFSET getStbuf
	call writeString
	pop edx 
	push ecx 
	push edx 
	push eax												; eax will hold number or characters in user string 
	mov edx, OFFSET readStbuf
	mov ecx, (SIZEOF readStbuf) - 1							; -1 to leave room for zero byte at end of string 
	call readString 
	mov sizebuf, eax										; store length of string for loop count in readValS
	pop eax
	pop edx
	pop ecx 
ENDM

.data
; (insert variables here)
prmpt1	BYTE	"Programming Assignment 6A: Designing low-level I/O procedures", 0dh, 0ah,
				"Written by: Emma Paul", 0
prmpt2	BYTE	"Please provide 10 unsigned (ie positive) integers.", 0dh, 0ah,
				"Each number needs to be small enough to fit inside a 32 bit register.", 0dh, 0ah,
				"After you have finished inputting the raw numbers I will display a list", 0dh, 0ah,
				"of the integers, their sum, and their average value.", 0
prmpt3	BYTE	"Please enter an unsigned number: ", 0
errMsg	BYTE	"ERROR: You did not enter an unsigned number or your number was too big.", 0dh, 0ah,
				"Please try again.", 0


userString	BYTE	 ARRAY_LNGTH DUP(?)									; buffer for the string entered by the user 
displayString	BYTE	 ARRAY_LNGTH  DUP(?)	
tempNum	DWORD	?														; used to hold number when converted to integer form 
temp	BYTE	?
stringSize DWORD 0
numArray	DWORD ARRAY_LNGTH DUP(?)
count DWORD ?
idxNum	DWORD ?

.code
main PROC
; (insert executable instructions here)

prgPrmpt prmpt1, prmpt2

;pushes for readVal procedure 
push OFFSET userString						; [esp+16] array to hold user numbers 
push OFFSET	disPlayString					; [esp+12]array to hold user numbers 
push ARRAY_LNGTH							; [esp+8]
push stringSize								; [esp+4] used for inner loop counter 
call ReadVal

;pushes for displayCal procedure 
;use array (converted) to fill array of DWORD to then do math 
;push OFFSET numArray						; [esp+20] DWORD array to hold converted ASCII numbers in their int form 


	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

readVal PROC
	push ebp
	mov	ebp, esp
	mov esi, [ebp + 20] ; @usertring  into esi
	mov edi, [ebp + 16] ; moves address of output into edi
	mov ecx, [ebp + 12] ; 10 in ecx for  loop counter 
 

counterLoop:
	mov count, ecx				; save count for outer loop 
	getString prmpt3, userString, stringSize
	mov ecx, [ebp+8]			; loop counter for inner loop is number of digits in string  
	mov stringSize, [ebp+8]    ; necessary? already saved?
	;mov ecx, eax could work too??? to save num of digits 
	mov idxNum, 0				; variable needs to be pushed onto stack?
	mov ebx, 10 
	
conversion loop: 
	mov eax, idxNum
	mul eax, ebx
	mov mulVal, eax			; save how much to multiply by for conversion 
	
	cld 
	lodsb						; loads al with string contents 
	cmp al, 48
	jle errorMsg
	cmp al, 57
	jge errorMsg
	sub al, 48
	mov tempNum, eax            ; save converted number 
	




imul ebx, 100
add ebx, eax
mov tempNum, eax 
mov [edi], tempnum 
add edi, 4						;go to next adress of array
loop convert


errorMsg:
	mov edx, OFFSET errMsg
	call writeString 
	jmp convert


popebp
readVal ENDP
END main