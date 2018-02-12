; ELG4159
; Lab 2 (Problem 10 Tutorial 1)

#include <p16f917.inc>

; variable declarations

TIMER_INIT EQ 0x7D ; 125

initialize
; select internal clock for timer0
  BCF OPTION_REG, 5
; select pre-scaler for timer0 to 32
  BCF OPTION_REG, 4
; configure pre-scaler 2^32
  BSF OPTION_REG, 0
  BCF OPTION_REG, 1
  BSF OPTION_REG, 2
; set clock to 125KHz
  BSF STATUS, 0
  BSF OSCON, 4
  BCF OSCON, 5
  BCF OSCON, 6
; configure RA0 as output
  BCF TRISA, 0
; disable comparators
  MOVLW 0x07
  MOVWF CMCON0
; return to Bank 0
  BCF STATUS, 0
  GOTO main

main
  MOVLW TMR0, TIMER_INIT
  BSF INTCON, 5
  GOTO wait

wait
  BTSS INTCON, 2
  GOTO wait
; reset interrupt
  BCF INTCON, 5
  BCF INTCON, 2
  GOTO toggle

toggle
  BTSS PORTA, 0
  BCF PORTA, 0
  BTSC PORTA, 0
  BSF PORTA, 0
  GOTO main
