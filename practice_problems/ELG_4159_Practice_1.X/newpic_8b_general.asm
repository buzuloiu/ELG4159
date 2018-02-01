#include <p16f917.inc>

    ; Initialization
    org 0x00
    goto START
    org 0x05
    
START
    const EQU 0xff ;defining the value to be placed in the registers
    first equ 0x2c
    last equ 0x6F
    counter equ 0x70
    
    
    
    bcf STATUS,6
    bcf STATUS,5
    
    movlw 0x44 
    movwf 0x70

    
    bcf STATUS,IRP ;bank 0 indirect addressing
    movlw last
    movwf FSR ;point to the last address
    bcf FSR, 7 ; finish selecting bank 0 for indirect addressing
    
    

    

 
MAIN
    
    movlw const ;put the constant in the address
    movwf INDF 
    decf FSR ;point to the previous address
   
    decfsz counter ;check if we have moved the correct number of addresses
    goto MAIN
    
    
INFINITY
    goto INFINITY
    
END
 