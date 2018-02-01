#include<p16f917.inc>

    org 0x00
    goto START
    org 0x05
    
START
    counter EQU 0x70
    last EQU 0x6F
    first EQU 0x2C
    total EQU d'68'
 
    movlw total
    movwf counter
    
    movlw last ;point the FSR to the last address
    movwf FSR
    
    bcf STATUS,IRP ;indirect adressing 
    bcf FSR,7
       
 
MAIN
    movf counter, 0
    movwf INDF
    decf FSR
    
    decfsz counter
    goto MAIN
    
TERMINATE
    goto TERMINATE
END