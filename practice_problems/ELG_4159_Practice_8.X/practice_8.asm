#include<p16f917.inc>
    org 0x00
    goto START
    org 0x05
    
START
    first EQU 0x10 ;define constants
    counter EQU d'16'
        
    bsf STATUS,6 ;bank 3
    bsf STATUS,5
    movlw counter
    movwf 0x20
      
    movlw first ;point to the first address
    movwf FSR
 
    bsf STATUS,IRP ;bank 3, indirect addressing
    bsf FSR,7
    
    clrw 
    
MAIN
    addwf INDF,0 ;add the 2 numbers
    incf FSR
    decfsz 0x20
    goto MAIN
    
    bcf STATUS,RP0 ;bank 0
    bcf STATUS,RP1
    
    movwf 0x20 ;put the content 
    rrf 0x20,1 ;shift 4 times to the right
    bcf STATUS,C
    rrf 0x20,1
    bcf STATUS,C
    rrf 0x20,1
    bcf STATUS,C
    rrf 0x20,1
      
TERMINATE
    goto TERMINATE

    
END