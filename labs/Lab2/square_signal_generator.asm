; ELG4159
; Lab 2 (Problem 10 Tutorial 1)

#include <p16f917.inc>

; variable declarations

TIMER_INIT EQU d'125'

 
 org 0x00
 goto initialize
 org 0x05
 
initialize
    ; select internal clock for timer0
      BCF OPTION_REG,5
    ; select pre-scaler for timer0 to 32
      BCF OPTION_REG,4
    ; configure pre-scaler 2^32
      BSF OPTION_REG,0
      BCF OPTION_REG,1
      BSF OPTION_REG,2


    ; set clock to 125KHz
      BSF STATUS,0
      BSF OSCCON,4
      BCF OSCCON,5
      BCF OSCCON,6
    ; configure RA0 as output
      BCF TRISA,0
    ; disable comparators
      MOVLW 0x07
      MOVWF CMCON0
    ; return to Bank 0
      BCF STATUS,0
      BSF INTCON, 5
      GOTO main

main
    BCF INTCON,T0IF
    MOVLW TIMER_INIT
    MOVWF TMR0
    GOTO wait
  
terminate
     GOTO terminate

  
wait
    BTFSS INTCON,T0IF
    GOTO wait
    GOTO toggle


toggle	
    MOVLW b'00000001'
    XORWF PORTA,1
    GOTO main

  
END