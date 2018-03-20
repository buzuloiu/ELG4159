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
    
    movlw b'01010000'
    movfw CCPR2L ;as computed in part 1
    
    movlw b'00000100' ;postscaler=0 prescaler=1 enable=yes
    movwf T2CON
    
    bsf STATUS,RP0 ;configure RD2 back to output
    BCF TRISD,2
      
TERMINATE
    goto TERMINATE
    
END