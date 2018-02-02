#include<p16f917.inc>
    org 0x00
    goto START
    org 0x05
    
START
    
    ;some initialization shit
    counter EQU d'8' ;we have 8 array elements to add
    ;point to first address with FSR
    ;select indirect addressing
    
MAIN
    ;set carry to 0?
    ;point to the least significant bits of the index of your array
    ;add the least significant 8 bits of both arrays, and the carry bit
    
    decfsz counter
    goto MAIN
    
    
TERMINATE
    goto TERMINATE ;infinite loop

STORE_OVERFLOW
    ;keep track of the carry from the status register
    ;select bank 1
    ;put the carry you stored earlier in the 

END