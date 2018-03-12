; ELG4159
;group 16
;Paul Buzuloiu
;Manit Ginoya
;Nikhil Peri
#include <P16F917.inc>

	
	__CONFIG    _CP_OFF & _CPD_OFF & _BOD_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _MCLRE_ON & _FCMEN_OFF & _IESO_OFF
	errorlevel -302		; supress "register not in bank0, check page bits" message

; variable declarations
TIMER_INIT EQU d'125'

org 0x00
goto initialize
org 0x05
 
initialize

	; set clock to 125KHz
	BCF STATUS,RP1
	BSF STATUS,RP0 ;bank1
	BCF TRISA,0

	CLRF ANSEL

	MOVLW b'00010000'
	MOVWF OSCCON

	MOVLW b'10000100'
	MOVWF OPTION_REG

	; configure RA0 as output
	; disable comparators
	MOVLW 0x07
	MOVWF CMCON0
	; return to Bank 0
	BCF STATUS,RP0
	BSF INTCON,T0IE

	GOTO main

main
	BCF INTCON,T0IF
	MOVLW b'01111101'
	
	MOVWF TMR0
	
	call waitm
	call toggle
	goto main
  
waitm
	BTFSS INTCON,T0IF
	goto waitm
	return

toggle	
	MOVLW b'00000001'
	XORWF PORTA,1
	return
	

	

  
END