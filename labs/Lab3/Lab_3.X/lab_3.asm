;Group 16
;Paul Buzuloiu
;Manit Ginoya
;Nikhil Peri  

;we use pin RA0 because 16 mod 8 is 0    
    
;Write an assembly program to continuously sample an analog 
;input signal into a 10-bit binary value. 
    
    __CONFIG _CP_OFF & _CPD_OFF & _BOD_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _MCLRE_ON & _FCMEN_OFF & _IESO_OFF
errorlevel -302 ; supress "register not in bank0, check page bits" message
    
    
#include <p16f917.inc>  
    
    org 0x00
    goto START
    org 0x05

START
    BANKSEL ADCON1 
    MOVLW b'01010000' ;set ADC Prescaler to 16
    MOVWF ADCON1 
    
    BANKSEL TRISA 
    BSF TRISA,0 ;Set RA0 to input
    
    BANKSEL ANSEL 
    BSF ANSEL,0 ;Set RA0 to analog
       
    BANKSEL  OSCCON
    MOVLW b'01110000' ;Set F_osc to 8MHz
    MOVWF OSCCON
    
    BANKSEL OPTION_REG
    MOVLW b'10000001' ;set timer0 prescaler to 4
    MOVWF OPTION_REG
        
    BANKSEL ADCON0 
    MOVLW b'10000001' ;Right justify, enable ADC
    MOVWF ADCON0 
    CALL SampleTime ; Wait for Acquisiton delay
       
LOOP
    BTFSC ADCON0,GO ; Wait until conversion finishes
    GOTO LOOP
    call PROCESS_DATA
    BSF ADCON0,GO ;Start conversion again
    GOTO LOOP
   
TERMINATE
    goto TERMINATE

PROCESS_DATA
    NOP 
    ;this is where the bits would be read from ADRESH and ADRESL
    ;for the purpose of this prelab, I don't think anything further needs to be done here
    ;the analog signal has been converted to 10 bit digital, stored in ADRESH and ADRSEL
    return
    
SampleTime ;acquisition delay subroutine, waits 2 microseconds
    BANKSEL INTCON ;move to bank 0
    bcf INTCON,T0IF ;clear timer 1 interrupt flag
    MOVLW d'255' ;set timer0 initial value
    MOVWF TMR0
    call TimingLoop 
    return 
    
TimingLoop
    BTFSS INTCON,T0IF ;wait until timer overflows (2 microseconds)
    goto TimingLoop
    return
    
END