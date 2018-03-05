// Write an assembly program for a PIC16F917 to generate a PWM signal of
// 31.2 kHz at pin CCP2 with a PIC?s main oscillator frequency of 8 MHz and a
// duty cycle ratio of 80%.
    
#include <p16f917.inc>
    
    org 0x00
    goto START 
    org 0x05
    
START
    bcf STATUS,RP1// bank 1 for OSCCON, TRISD,PR2
    bsf STATUS,RP0
    
    MOVLW b'01110000' //internal oscillator to 8MHz
    MOVWF OSCCON
    
    bcf TRISD,2 //set RD2 as input temporarily
    
    MOVLW d'63' //PR2 as Calculated
    MOVWF PR2
    
             
    bcf STATUS,RP0 //bank 0 for T2CON,CCP2CON,CCPR2L<5:4>
    
    movlw b'00110011';setting initial values
    movwf CCP2CON
    
    movlw b'00011100' ;2 LSBs of initial value, and setting pwm mode
    movwf CCPR2L
    
    movlw b'00000100' ;timer2 on, prescaler 1, postscaler 0
    movwf T2CON
    
    
    bsf STATUS,RP0 //set pin RC2 as output

    bcf TRISD,2 //set RD2 as output
    
TERMINATION
    GOTO TERMINATION
    
end
