TITLE Program Template			(template.asm)

; Program Description: Program that calculates prime numbers. It prompts the user asking for the number of prime numbers they would like to be displayed (between 1-200).
					; It displays an error message if the user enters a number not b/w 1-200. Then it prints the number of prime numbers the user asks for, providing at least 3 spaces between the numbers and prints 10 numbers per line. 
; Author: Emma Paul 
; Date Created: November 9, 2013 
; Last Modification Date: November 11, 2013 

INCLUDE Irvine32.inc
; (insert symbol definitions here)

.data
; (insert variables here)
;constants 
UPPERLIMIT = 200 ; highest integer user input can be 
LOWERLIMIT = 1   ; lowest integer user input can be


;intro variables 
intro		BYTE	"Prime Numbers", 0
progBy		BYTE	"Programmed by Emma Paul", 0

;get user data variables 
prompt		BYTE	"Please enter the number of prime numbers you would like to see. ", 0dh, 0ah, 
					"I'll accept a number request that is between 1-200. ", 0
getNum		BYTE	"Please enter the number of primes to display [1...200]: ", 0
errorMSG	BYTE	"That number is out of range! Please try again. ", 0

;show primes/is prime variables 
spaces		BYTE	"   ", 0
runningNum	DWORD	12			; start runningNum at 11 (where prime calculation loop starts) 
count		DWORD	5			; start num count at 5 (in order to exclude 2, 3, 5, 7, and 11)
userNum		DWORD	?			; variable to store user number in 
lineRemainder		DWORD	?
divTen		DWORD	10
numis1		BYTE	"2", 0
numis2		BYTE	"2   3", 0
numis3		BYTE	"2   3   5", 0
numis4		BYTE	"2   3   5   7", 0
numis5		BYTE	"2   3   5   7   11", 0

;farewell variables 
goodbye		BYTE	"Results certified by Emma. Goodbye!", 0
 

.code
main PROC
; (insert executable instructions here)

call introduction   ; Procedure 1
call getUserData	; Procedure 2
call showPrimes		; Procedure 3
call farewell		; Procedure 4

	exit		; exit to operating system
main ENDP

; (insert additional procedures here)

;Procedure 1: introductrion procedure 
	introduction PROC
	mov		edx, OFFSET intro 
	call	writeString 
	call	crlf
	mov		edx, OFFSET progBy
	call	writeString 
	call	crlf 
	call	crlf
ret
introduction ENDP

;Procedure 2: get user data procudes 
getUserData PROC
	mov		edx, OFFSET prompt 
	call	writeString 
	call	crlf 
	call	crlf
	mov		edx, OFFSET getNum
	call	writeString 
	call	readInt				; number gets stored in eax
	call	crlf
	call	validate
ret
getUserData ENDP

;Sub-Procedure of Procedure 2: validates whether or not user number is [1...200] and prompts for correct input if necessary
validate PROC
	validateLOOP:
		cmp		eax, UPPERLIMIT
		jg		errorReport 
		cmp		eax, LOWERLIMIT 
		jl		errorReport
		mov		userNum, eax				; stores valid user number in userNum
		jmp		exitValidate

	errorReport: 
		mov		edx, OFFSET errorMSG
		call	writeString 
		mov		edx, OFFSET getnum
		call	writeString 
		call	readInt 
		jmp		validateLoop

	exitValidate:
ret
validate ENDP

;Procedure 3: shows prime numbers 
showPrimes PROC
	mov		userNum, eax			; stores user number in variable 

	mov		eax, userNum			;first check if user number is 1, 2, 3, 4, or 5
	cmp		eax, 1
	je		print1Num
	cmp		eax, 2
	je		print2Nums
	cmp		eax, 3
	je		print3Nums
	cmp		eax, 4
	je		print4Nums
	mov		eax, userNum
	cmp		eax, 5
	je		print5Nums

	mov		edx, OFFSET	numis5		;print primes 2, 3, 5, 7, and 11
	call	writeString
	mov		edx, OFFSET	spaces
	call	writeString
	call	isPrime				; if user number is greater than 4, go to isPrime
	jmp		exitShowPrimes

	print1Num: 
		mov		edx, OFFSET numis1
		call	writeString 
		call	crlf 
		jmp		exitShowPrimes

	print2Nums: 
		mov		edx, OFFSET numis2
		call	writeString 
		call	crlf 
		jmp		exitShowPrimes

	print3Nums: 
		mov		edx, OFFSET numis3
		call	writeString 
		call	crlf 
		jmp		exitShowPrimes

	print4Nums: 
		mov		edx, OFFSET numis4
		call	writeString 
		call	crlf 
		jmp		exitShowPrimes

	print5Nums: 
		mov		edx, OFFSET numis5
		call	writeString 
		call	crlf 
		jmp		exitShowPrimes

	exitShowPrimes:
ret
showPrimes	ENDP

;Sub-Procedure of procedure 3: is Prime Procedure: calculates whether current number is a prime, incrementing number at the end 
isPrime PROC

	isPrimeLoop:
		mov		eax, runningNum
		cdq
		mov		ebx, 2
		div		ebx					; divides eax num by 2
		cmp		edx , 0				; compare remainder to 0 (is it divisible by 2?)
		je		increMentNumber
		mov		eax, runningNum
		cdq
		mov		ebx, 3
		div		ebx
		cmp		edx, 0
		je		incrementNumber
		mov		eax, runningNum
		cdq
		mov		ebx, 5
		div		ebx
		cmp		edx, 0
		je		incrementNumber 
		mov		eax, runningNum
		cdq
		mov		ebx, 7
		div		ebx
		cmp		edx, 0
		je		incrementNumber
		mov		eax, runningNum
		cdq
		mov		ebx, 11
		div		ebx
		cmp		edx, 0
		je		incrementNumber
		jmp		formatLinesLoop


	formatLinesLoop: 
		mov eax, count						; nothing important is in eax, start count at 1 
		cdq									; dword to qword (needed for some reason)
		div	divTen							; automatically divides eax/limiter and stores quotient in eax 
		mov lineRemainder, edx					; remainder automatically goes to edx 
		cmp lineRemainder, 0					; if remainder is 0 we know we want to hit return because its a multiple of 10 with no remainder
		je	newline 
		jmp printPrime						; if formatting isn't necessary then we will continue printing 

	newline: 
		call crlf
		jmp printPrime

	printPrime:
		mov		ebx, count
		cmp		ebx, userNUM
		je		exitPrintPrime				; when the count (number or primes) equals the user number 
		add		ebx, 1 
		mov		count, ebx					; store count 
		mov		eax, runningNum
		call	writeDec
		mov		edx, OFFSET spaces
		call	writeString 
		mov		eax, runningNum
		add		eax, 1
		mov		runningNum, eax
		jmp		isPrimeLOOP

	incrementNumber: 
		mov		eax, runningNum
		add		eax, 1							; increments running number by 1
		mov		runningNum, eax
		jmp		isPrimeLOOP

	exitPrintPrime:
ret
isPrime	ENDP

;Procedure 4: Farewell procedure 
farewell PROC
	call	crlf
	call	crlf
	mov		edx, OFFSET goodbye
	call	writeString 
	call	crlf
ret
farewell ENDP

END main