TITLE Program Template			(template.asm)

; Program Description: This program prompts the user for a number n between [10...200] (asks for valid input if invalid)
						; If then displays n unsorted random numbers, the median, and a sorted list of the numbers
; Author: Emma Paul 
; Date Created: 11/19/2013
; Last Modification Date:

INCLUDE Irvine32.inc

; (insert symbol definitions here)
MIN		= 10
MAX		= 200
LO		= 100
HI		= 999 

; (insert variables here)
.data
sortTitle	BYTE	"Sorting Random Integers", 0
myName		BYTE	"Programmed by Emma Paul", 0
ranPrompt	BYTE	"This program generates random numbers in the range [100...999],", 0dh, 0ah, 
					"displays the original list, sortst the list, and calculates the", 0dh, 0ah,
					"median value. Finally, it displays the list sorted in descending order. ", 0 
numPrompt	BYTE	"How many numbers should be generated? [10...200]:  ", 0
errPrompt	BYTE	"Invalid Input", 0 
dspLst		BYTE	"The unsorted random numbers: ", 0
mdian		BYTE	"The median is: ", 0
srtLst		BYTE	"The sorted list: ", 0
numArray	DWORD	200 DUP(?)				; max size for array is 200, don't know capacity 
userReq		DWORD	?						; will be capacity, num of elements in array 
medianIDX	DWORD	?						; variable for index value of median 
medVAL		DWORD	?						; variable for value of median 
count		DWORD	-1						;
count1		DWORD   -1
tempVal		DWORD	0						; temp value to hold request 
lincount	DWORD	?						; keepts tally of line count 
lndiv		DWORD	10						; used to print 10 numbers per line 
remain1		DWORD	?						; variable to hold remainder for testing 
remain2		DWORD	?						; used for median 
x			DWORD	?

; (insert executable instructions here)
.code
main PROC
	call	RANDOMIZE				; lecture says to call right at beginning of main, Randomize Procedure in Irvine Library 
 ;pushes for intro  
	push	OFFSET	sortTitle		; 4 bytes, title , [esp+12]
	push	OFFSET	myName			; 4 bytes, my name [esp+8]
	push	OFFSET	ranPrompt		; 4 bytes, prompt for intro [esp+4]
	call	introduction			; introduces program, [esp]
 ;pushes for get data 
	push	OFFSET numPrompt		; 4 bytes, push num prompt for get data segment onto stack, [esp+12] 
	push	OFFSET errPrompt		; 4 bytes, push error prompt onto stack, [esp+8]
	push	OFFSET userReq			; 4 bytes, push address reference parameter of request onto stack, [esp+4]
	call	getData					; parameters: request (reference), [esp]
;pushes for fill array 
	push	OFFSET	numArray		; 4 bytes, @numArray, [esp+8]
	push	userReq					; 4 bytes, address of user request for count, [esp+4]
	call	fillArray				; parameters: numarray (reference), request(value), [esp]
;pushes for display list 	
	push	OFFSET	numArray		; [esp+12]
	push	userReq					; [esp+8]
	push	OFFSET	dspLst			; [esp+4]
	call	displayList				; parameters: numarray (reference), request(value), title(reference)
;pushes for sortList		
	push	OFFSET numArray			; [esp+16]
	push    tempVal					; [esp+12]
	push	count1					; [esp+8]
	push	userReq					; [esp+4]
	call	sortList				; parameters: numArray (reference), request(value)
;pushes for display sorted list 
	push	OFFSET	numArray		; [esp+12]
	push	userReq					; [esp+8]
	push	OFFSET	srtLst			; [esp+4]
	call	displaysortList
;pushes for display median 
	push	OFFSET	numArray		; @numArray, [esp+20]
	push	userReq					; @userReq? , [esp+16]
	push	OFFSET mdian			; [esp+12]
	push    remain2					; [esp+8]
	push    medianIdx				; [esp+4]
	call	displayMedian			; parameters: numarray (reference), request(value)

	exit							; exit to operating system
main ENDP

; (insert additional procedures here)
; ***************************************************************
; Procedure to introduce the program 
; Implementation note: accesses introduction variables by pushing them onto the stack 
; receives: variables: sortTitle, myName, and ranPrompt to introduce the program 
; calls: writestring and crlf 
; returns: 
; preconditions: 
; registers changed: edx 
; ***************************************************************
introduction PROC 
	push	ebp					; 4 bytes, save old ebp (address of request), 
	mov		ebp, esp			; set esp as base pointer 
	mov		edx, [ebp+16]		; mov sort title into edx 
	call	writeString 
	call	crlf
	call	crlf 
	mov		edx, [ebp+12]		; move myName into edx 
	call	writeString 
	call	crlf 
	call	crlf
	mov		edx, [ebp+8]		; move randprompt into edx 
	call	writeString 
	call	crlf 
	call	crlf
	pop		ebp					; (-4 bytes on stack) pop return address 
	ret		12
introduction ENDP

; ***************************************************************
; Procedure to get a number [10...200] 
; Implementation note: This procedures access its parameters by seeting up a "stack frame" 
;					   and referencing parameters relative to the top of the system stack 
; receives: variables: numPrompt, errPrompt
;			user data: user request for a number [10....200]
; calls:	writeString, readInt 
; returns:  error message if invalid input, or stores valid number 
; preconditions: MINNUM < MAXNUM in order to work 
; registers changed: eax, edx, ebx  
; ***************************************************************
getData PROC 
	push	ebp						; 4 bytes onto stack, save old return address
	mov		ebp, esp				; set esp as base pointer
promptLoop: 
	mov		edx, [ebp+16]			; move numPrompt into edx 
	call    Writestring				; prompt user
	call    readInt					; get user number and stores in eax 
	cmp		eax, MIN				; num request < 10? 
	jl		invalidInput			; if request < 10, go to error message 
	cmp		eax, MAX				; num request > 200? 
	jg		invalidInput			; if request > 200, go to error message 
	mov		ebx, [ebp+8]			; mov ebx to address of userReq in ebx 
	mov		[ebx], eax				; once user num is valid,store request at adress ebx points to  
	jmp		endloops				; jump to end procedure if num is valid 

invalidInput: 
	call	crlf
	mov		edx, [ebp+12]			; error Prompt 
	call	writeString 
	call	crlf
	call	crlf
	jmp		promptLoop

endLoops: 
	pop		ebp						; pops OLD return address 
	ret		12						; return 12 bytes that were pushed before procedure called 
getData ENDP

; ***************************************************************
; Procedure to fill numArray with random numbers 
; receives: address of array and value of request on system stack
; returns: array with random numbers starting @numArray
; preconditions:
; registers changed: eax, ebx, ecx, edi
; ***************************************************************
fillArray PROC 
	push	ebp						; 4 bytes, save old return address
	mov		ebp, esp				; set ebp as base pointer 
	mov		ecx, [ebp+8]			; user request moved to ecx 
	mov		edi, [ebp + 12]			; @numArray in edi 
again: 
	mov		eax, HI					
	sub		eax, LO					; range = hi - lo + 1
	inc		eax 
	call	RandomRange				; randomrange procedure from irvine library, result in eax is in [0...range-1] 
	add		eax, LO					; add lo to eax 
	mov		[edi], eax				; store random number in first address of array 
	add		edi, 4					; increment to next array index 
	 	
	loop	again
	
	pop ebp							; (-4) pop old return address 
	ret 8
fillArray ENDP

; ***************************************************************
; Procedure to display the list of unsorted, random numbers. 
; receives: address of array and user request on system stack
; returns: list 
; preconditions: list is not empty 
; registers changed: eax, ebx, ecx, edi
; ***************************************************************
displayList PROC 
	push ebp					; 4 bytes 
	mov	 ebp, esp				; ebp as base pointer 
	mov	 esi, [ebp+16]			; adress of numArray[0] into esi 
	mov  ecx, [ebp+12]
	mov  edx, [ebp+8]			; move display list string into edx 
	call writestring 
	call crlf
	mov	 eax, 1
	mov	 count, eax				; start count at 1 ? 

moreloop: 
	mov		eax, [esi]			; get contents of numArray[0]
	call	writeDec 
	mov		eax, count			; when count its 10 
	cdq
	div		lndiv				; count / 10 = 0? (new line) 
	mov		remain1, edx			; store remainder in variable remain (in edx from division) 
	cmp		remain1, 0
	jne		tabloop
	je		newline
	

newLine: 
	call crlf
	jmp  endLoop

tabloop: 
	mov		al, TAB				; prints a tab 
	call	writeChar

endLoop:
	inc		count				; increase count for looping 
	add		esi, 4				; go to address of next element in array 
	loop	moreLoop

endMoreLoop: 	
	pop		ebp
	ret		12
disPlayList ENDP
; ***************************************************************
; Procedure to sort the array of number in descending order 
; receives: address of array and value of count on system stack
; returns: array is sorted after procedure 
; preconditions: array is not empty
; registers changed: eax, ebx, edi, esi
; ***************************************************************

sortList PROC
	push ebp
	mov ebp, esp
	mov esi, [ebp+16]							; count1 
	mov ebx, [ebp+12]						    ; temp value in ebx 
	mov eax, [ebp+8]							; user request in eax 					
	dec eax										; request - 1
	mov [ebp+12], eax							; request -1 in temp 

outerLoop:
    inc esi
    mov edi, [ebp+16]							; count1
	mov eax, [ebp+8]							;request -1
    cmp esi, eax								; compare count1 (k) to request -1 
    je endLoop									; jump if equal to end (no more elements in array)

innerLoop:
	mov ebx, [ebp+12]							; tempVal, request 
	inc edi										; j = k + 1    
	cmp edi, ebx								; j < request? 
	je outerLoop							    ; if so jump out of inner loop 

compare:
	mov eax, [numArray + edi * 4]				; i into eax 
	mov ebx, [numArray + edi * 4 + 4]			; j into ebx 
	cmp ebx, eax								; i > j? 
	jle innerLoop								; if not, no swap necessary 

swap:
	mov [numArray + edi * 4], ebx				; put j into @i 
	mov [numArray + edi * 4 + 4], eax			; and i into @j
	jmp innerLoop

endLoop:
	pop ebp
	ret 16
sortList ENDP


; ***************************************************************
; Procedure to display the list of sorted, random numbers. 
; receives: address of array and user request on system stack
; returns: prints sorted list 
; preconditions: array is not empty 
; registers changed: eax, ebx, ecx, edi, esi
; ***************************************************************
displaySortList PROC 
	push ebp					; 4 bytes 
	mov	 ebp, esp				; ebp as base pointer 
	mov	 esi, [ebp+16]			; adress of numArray[0] into esi 
	mov  ecx, [ebp+12]
	mov  edx, [ebp+8]			; move display list string into edx 
	call crlf
	call writestring 
	call crlf
	mov	 eax, 1
	mov	 count, eax				; start count at 1 ? 

moreloop: 
	mov		eax, [esi]			; get contents of numArray[0]
	call	writeDec 
	mov		eax, count			; when count its 10 
	cdq
	div		lndiv				; count / 10 = 0? (new line) 
	mov		remain1, edx		; store remainder in variable remain (in edx from division) 
	cmp		remain1, 0
	jne		tabloop
	je		newline
	

newLine: 
	call crlf
	jmp  endLoop

tabloop: 
	mov		al, TAB				; prints a tab 
	call	writeChar

endLoop:
	inc		count				; increase count for looping 
	add		esi, 4				; go to address of next element in array 
	loop	moreLoop

endMoreLoop: 	
	pop		ebp
	ret		12
disPlaySortList ENDP
								
; ***************************************************************
; Procedure to display the value of the median index (calculates in necessary)
; receives: address of array, user request
; returns: prints median value 
; preconditions: 
; registers changed: eax, ebx, edx, edi, esi
; ***************************************************************

displayMedian PROC 
	push ebp 
	mov	 ebp, esp 
	mov  esi, [ebp+24]								; @numArray
	mov	 eax, [ebp+20]								; user req in edx 
	cdq
	mov ebx, 2
	div	ebx
	mov [ebp+8], eax								; store median 
	mov [ebp+12], edx								; store remainder 
	cmp	edx, 0
	je	findMedian
	jne	printMedian

printMedian: 
	mov edx, [ebp+16]				; "the median is"
	call crlf
	call crlf
	call writeString 
	mov edx, [ebp+8]				; median index into edx
	mov eax, [numArray + edx*4]		; get value of median index into eax 
	call writeDec 
	call crlf 
	call crlf 
	jmp endLoop 

printNewMedian: 
	mov edx, [ebp+16]
	call crlf 
	call crlf 
	call writeString 
	mov eax, [ebp+8]
	call writeDec 
	call crlf 
	jmp endLoop

findMedian: 
	mov edx, [ebp+8]								; meadian index 
	mov eax, [numArray + edx * 4]					; put value at median address into eax 
	mov ebx, [numArray + edx *4 + 4]				; go to next index value
	add	eax, ebx
	mov ebx, 2
	cdq
	div	ebx											; find average 
	mov [ebp+8], eax								; store median 
	jmp printNewMedian

endloop: 
	pop ebp 
	ret 20
displayMedian ENDP
	

END main