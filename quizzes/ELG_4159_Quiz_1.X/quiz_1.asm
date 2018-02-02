;This is the solution to quiz 1 for ELG4159, February 2018
    
#include<p16F917.inc>
    numofneg equ 0x36
    temp equ 0x37
    counter equ 0x38
 
    org 0x00
    goto START
    org 0x05
    
START
    BSF STATUS,RP0
    BSF STATUS,RP1
    BSF STATUS,IRP
    
    MOVLW 0x24
    MOVWF counter
    MOVLW d'0'
    MOVWF numofneg
    MOVLW b'10010010'
    MOVWF FSR
    
NEXT
    MOVF INDF,0
    MOVWF temp
    BTFSS temp 
    GOTO NUMBER_IS_NONNEGATIVE
    call ABS
    MOVF temp,0
    MOVWF INDF
    INCF numofneg
    
NUMBER_IS_NONNEGATIVE
    INCF FSR
    DECFSZ counter,1
    GOTO NEXT
    
TERMINATION
    GOTO TERMINATION
    
ABS
    COMF temp
    INCF temp
    return
END