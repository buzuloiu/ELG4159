; ELG4159 
; Lab 0 (Problem 10 Tutorial 1)
; Problem: Modified Problem 10 of problem set:
; Count the # of registers in Bank 1- 0xB0 through 0xB4, that have '1010' is their LSB and store that result in [0x44h, 3].
; THIS VERSION IS BUGGY.


#include <p16f917.inc>

; variable declarations
COUNTER	EQU	0x44;

;------------------------------------------------------------------------------------------------------------
; BLOCK #: 1
; GOAL : Load first instruction of code into 0x00 and mention the address from which the next instruction of your code gets stored.
; BUGGY : NO.
; SIMULATOR FEATURE : output console and error messages

		org 0x00	; Load first instruction of code into 0x00 of program memory
		GOTO initialize	; This will be stored in 0x00
		org 0x05	; Since addresses 1-4 of program memory are reserved, explicitly ;mention that the next instruction in your code gets stored starting 					;0x05 in program memory.
;--------------------------------------------------------------------------------------------------------------
; BLOCK #: 2
; GOAL : Go to Bank 1; since that is where addresses are being searched for the desired value.
; BUGGY : NO. (error was in STATUS RP0 instruction  and the wrong address for 
		;line 45); SIMULATOR FEATURE : Breakpoints, PIC Memory views->SFRs.

initialize
		CLRW		;
		CLRF FSR		;
		CLRF INDF		;
		BCF STATUS, IRP;	 Bank 0,1: The addresses you use in FSR determine if Bank 0 or 1.
		BCF STATUS, RP1; 	 Bank 1 : RP1 = 0, RP0 = 1.
		BSF STATUS, RP0;        ;used to select 00 instead of 01
;--------------------------------------------------------------------------------------------------------------
		MOVLW 0Fh	; Move AND value to be used to W
		MOVWF 0x20	; Mov contents of W to address: This is where AND value will be stored.
		MOVLW 0Ah	; Move XOR value to be used to W
		MOVWF 0x21	; Move contents of W to address: This is where XOR value will be stored.
		CLRW		;
		MOVWF COUNTER	; Storing counter value as 0 in this address.  
		MOVLW 0xB0	; Initialize starting address in Bank 1 to search from.
		MOVWF FSR	; Move the initialized starting address to FSR.

		MOVLW 0Ah	; inserting 2 of the registers with our test value of 0Ah
		MOVWF 0xB0	; 0x44 should have 2 as final answer
		MOVWF 0xB3	;
		GOTO main	;

main
		MOVF 0x20, W	; Move ANDing value to W
		ANDWF INDF, 1	; AND result stored in address INDF is pointing to, store result there as well.
		MOVF 0x21, W	; Move XORing value to W
		XORWF INDF, W	; XOR result stored in address INDF is pointing to, store result there as well.
		BTFSC STATUS, Z; if Z = 0, then XOR result not 0h, => tested address does not have 0Ah in LSB, so skip inc. ctr.
		INCF COUNTER, 1	; Increase counter if tested address contains 0Ah in LSB i.e. XOR result is 0, i.e. Z = 1.
		GOTO next_address; 
;--------------------------------------------------------------------------------------------------------------
; BLOCK #: 3
; GOAL : Move to the next address to search and check if the last address to search, i.e 0xB4 is reached.
; BUGGY : NO. (off by one error in the counter, using bit test instead of XOR)
; SIMULATOR FEATURE : Breakpoints, PIC memory views->SFRs and ->File Registers (choose symbol view).

next_address
		INCF FSR, 1	;  Inc. FSR value by 1 to move to next address using indirect addressing
		MOVLW 0xB5      ; Move the end address to the work register
		XORWF FSR, W	; XOR the address 
		BTFSS STATUS, Z	; Check if 0xB4 has been reached.
		GOTO main	;
		CALL transfer_ctr_value_to_bank3;
		GOTO fin;
;--------------------------------------------------------------------------------------------------------------
; BLOCK #: 4
; GOAL : Transfer final counter value from :[0x44, 1] to desired location: [0x44,3].
; BUGGY : NO. (was not actually selecting bank 3 (using BCF not BSF)
; SIMULATOR FEATURE : Breakpoints, PIC memory views->SFRs and ->File Registers (choose symbol view) and Watch window to monitor COUNTER.

transfer_ctr_value_to_bank3
		; store ctr in bank 3 44h
		MOVF COUNTER, W	; Moving final ctr result to W
		BSF STATUS, RP1 ; Setting destination bank to bank 3
		BSF STATUS, RP0 ; 
		MOVWF 44h	; This should move to 44h of bank 3 i.e. to 1C4 in File Register Address terms
		RETURN		;

fin 		
		GOTO fin		; 
		END			;
    
