#include<p16f917.inc>
    
    org 0x00
    goto START
    org 0x05
    
START
    counter EQU 0x29 ;address of the counter 
    temp EQU 0x28 ;temporary variable
 
    bsf STATUS,RP0 ;bank 3, direct addressing
    bsf STATUS,RP1
    
    movlw d'12';counter value
    movwf counter
    
    movlw d'0' ;initial values
    movwf 0x30
    
    movlw d'1' ;initial values
    movwf 0x31
    
    movlw 0x00 ; store the first temp value
    movwf temp
    
    movlw 0x31 ;point to the last given value
    movwf FSR
    
    bsf STATUS,IRP ;bank3, indirect addressing
    bsf FSR,7
    
    
MAIN
    
    
    ;computing n using temp(n-2) and n-1
    movf temp,0 ;move n-2 to the work register
    addwf INDF,0 ;add n-1 to n-2
    incf FSR,1 ;point to n
    movwf INDF ;store the sum of n-1 and n-2 in n
    
    ;storing n-1 in temp to be used as n-2
    decf FSR,1 ;point to n-1
    movf INDF,0;store n-1 in temp
    movwf temp 
    incf FSR,1 ;point to n again
    
    
    decfsz counter ;decrease the counter, when it runs out, stop iterating
    goto MAIN
    
TERMINATE
    goto TERMINATE

END