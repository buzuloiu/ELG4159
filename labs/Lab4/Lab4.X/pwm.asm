

;ELG 4159 Lab 4
;Group 16
;Paul Buzuloiu
;Manit Ginoya
;Nikhil Peri
    
;use AN0 because 16 mod 8 is 0
;CCP2 because 16 is even

#include<p16f917.inc>
    org 0x00
    goto START 
    org 0x05
    
    
__CONFIG _CP_OFF & _CPD_OFF & _BOD_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _MCLRE_ON & _FCMEN_OFF & _IESO_OFF
errorlevel -302 ; supress "register not in bank0, check page bits" message
    
START
    bsf STATUS,RP0;bank1
    bcf STATUS,RP1
    bsf TRISD,2 ;configure RD2 as temporary input
    
    movlw d'255'
    movwf PR2
    
    movlw b'01110000'
    movwf OSCCON
    
    bcf STATUS,RP0 ;bank 0
    
    movlw b'00111100' ;<5:4> as computed in part 1, <3:0> = 11xx for PWM
    movwf CCP2CON
    
    movlw b'11110000'
    movfw CCPR2L ;as computed in part 1
    
    movlw b'00000100' ;postscaler=0 prescaler=1 enable=yes
    movwf T2CON
    
    BANKSEL TRISD
    BCF TRISD,2
    
      
TERMINATE
    goto TERMINATE
    
END