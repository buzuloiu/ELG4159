#include<p16f917.inc>
    
    org 0x00
    goto START
    org 0x05
    
START
    total EQU 0x30 ;the quantity of GPRs to check
    target EQU 0x50 ;the address that contains your value to compare to
    result EQU 0x51 ;the address where the result will be stored
    first EQU 0x20 ; the first address you have to check
 
    movlw first ;point to the first address to check
    movwf FSR
    
    movlw total ;keep a counter in the address 0x52
    movwf 0x52
   
   ;uncomment below for a test of having a matching value at the last address 
   ;********************************
   ;movlw 0xFF ;just for test!!!!!
   ;movwf 0x4F
   ;movlw 0xFF
   ;movwf 0x50
   ;*******************************
    
    bcf STATUS,7; indirect addressing
    bcf FSR,7
 
MAIN
    
    movf  target,0 ;put the value to compare to in the work reg
    XORWF INDF,0 ;compare it to the value pointed to by FSR
    btfsc STATUS,Z; if status,Z is 0, it's not a match, if 1, it's a match
    goto MATCH_FOUND
    
    incf FSR,1 ; point to the next address to be checked
          
    decfsz 0x52 ;decrement the counter, stop iterating if it's 0
    goto MAIN
    
    goto NO_MATCH
    
TERMINATE
    goto TERMINATE ; infinite loop

MATCH_FOUND
    MOVF FSR,0 ;move the address of the match to the result register
    MOVWF result
    bcf result,7    ;clear the MSB of that register
    goto TERMINATE
    
NO_MATCH
    bsf result,7    ;set the MSB of the result register to 1
    goto TERMINATE
    
END