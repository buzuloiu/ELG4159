__CONFIG _CP_OFF & _CPD_OFF & _BOD_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _MCLRE_ON & _FCMEN_OFF & _IESO_OFF
errorlevel -302 ; supress "register not in bank0, check page bits" message
    
    
#include <p16f917.inc>

    ;group 16
    ;A is 0
    ;B is 1
    ;T is 1 second
    
    ;Write an assembly program to continuously sample an analog 
    ;input signal into a 10-bit binary value. 

    
    
    org 0x00
    goto START
    org 0x05

START
    BANKSEL ADCON1 ;
    MOVLW b'01110000' ;ADC Frc clock
    MOVWF ADCON1 ;
    BANKSEL TRISA ;
    BSF TRISA,0 ;Set RA0 to input
    BANKSEL ANSEL ;
    BSF ANSEL,0 ;Set RA0 to analog
    BANKSEL ADCON0 ;
    MOVLW b'10000001' ;Right justify,
    MOVWF ADCON0 ;Vdd Vref, AN0, On
    CALL SampleTime ;Acquisiton delay
    
    
LOOP
    BTFSC ADCON0,GO ;Is conversion done?
    GOTO LOOP;No, test again
    call PROCESS_DATA
    BSF ADCON0,GO ;Start conversion again
    GOTO LOOP

    
TERMINATE
    goto TERMINATE

PROCESS_DATA
    NOP ;this is where the bits would be read from ADRESH and ADRESL
    ;for the purpose of this prelab, I don't think anything further needs to be done here
    return
    
SampleTime
    NOP ;this is where there would be a delay of time before they start converting
    ;someone should implement this, including the initialization of timer0 at the beginning
    return 
    
END