#include <p16f917.inc>
    
    out_hi equ 0x21
    out_lo equ 0x20
    
    org 0x00
    goto START
    org 0x05
    
START
    
    bcf STATUS,RP1 ;bank 1 for TRISA, ANSEL, OSCCON, ADCON1
    bsf STATUS,RP0
    
    BSF TRISA,0 ;input, analog
    BSF ANSEL,0
    
    MOVLW b'01110000'
    MOVWF OSCCON
    
    MOVLW b'01010000'
    MOVWF ADCON1
    
    bcf STATUS,RP0 ;bank 0 for ADCON0
    
    movlw b'10000001'
    movwf ADCON0
    
    call SAMPLETIME; wait sample time, and start acquisition
    BSF ADCON0,GO
    
LOOP
    BTFSC ADCON0,GO ; wait till conversion is done
    goto LOOP
    
    BANKSEL ADRESH
    movf ADRESH,0 ;move result to wreg
    movwf out_hi
    
    BANKSEL ADRESL
    movf ADRESL,0
    movwf out_lo

TERMINATE
    goto TERMINATE

SAMPLETIME
    ;idk some waiting thing for 2T_ad (which is 4us)

END