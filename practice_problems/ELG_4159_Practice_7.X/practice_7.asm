;F_pi = F_osc/4 = 250/4 = 62.5 kHz
;that means that the timer ticks every 16us
;even with the default prescaler of 2, the timer can only tick for 0.008 seconds
;before overflowing, and we need 1second
; this turns out to be 256, and we have to tick 244 times, 
    ;this produces an actual delay of 0.999424 seconds
    ;an error of 0.000576s
    
    
    
#include <p16f917.inc>
org 0x00
goto Initialize
org 0x05
Initialize
; Configure I/O pins (3 lines maximum)
    bcf TRISA,5 ;set RA5 as an output
    
    
; Set internal oscillator frequency (2 lines maximum)
    movlw b'00000010'
    movwf OSCCON  
; Set TMR0 prescaler (2 lines maximum)
    movlw b'00000111'
    movwf OPTION_REG
; Turn off comparators
movlw 0x07
movwf CMCON0 ; turn off comparators
; Turn LED off (2 lines maximum)
    bcf STATUS,RP0
    bcf PORTA,5  
Main
; Initialize TMR0 interrupt flag (T0IF) and
; the timer?s initial value (3 lines maximum)
    bcf INTCON,T0IF
    movlw d'122'
    movwf TMR0
; Toggle LED (2 lines maximum)
    movlw b'00100000'
    xorwf PORTA,1
    TimingLoop
; A loop to wait for the necessary time delay before
; branching back to the appropriate line in the
; program (3 lines maximum)
    btfss INTCON,T0IF
    goto TimingLoop
    return
END ; directive ?end of program?