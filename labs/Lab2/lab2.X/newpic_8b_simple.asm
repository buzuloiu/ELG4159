; ELG4159
; Lab 2 (Problem 10 Tutorial 1)
#include <p16f917.inc>

; variable declarations
TIMER_INIT EQU d'125'

    org 0x00
    goto initialize
    org 0x05
 
initialize

    ; set clock to 125KHz
    BSF STATUS,RP0 ;bank1
    BCF STATUS,RP1
    
    
    CLRF ANSEL
      
    MOVLW b'00000100'
    MOVWF OPTION_REG

    MOVLW b'00010000'
    MOVWF OSCCON
    ; configure RA0 as output
  
    BCF TRISA,0
    ; disable comparators
    MOVLW 0x07
    MOVWF CMCON0
    ; return to Bank 0
    BCF STATUS,RP0
    BCF STATUS,RP1

    BSF INTCON,T0IE
    GOTO main

main
    BCF INTCON,T0IF
    MOVLW TIMER_INIT
    MOVWF TMR0
    GOTO wait_m
  
terminate
    GOTO terminate

  
wait_m
    BTFSS INTCON,T0IF
    GOTO wait_m
    GOTO toggle

toggle	
    MOVLW b'00000001'
    XORWF PORTA,1
    GOTO main

  
END