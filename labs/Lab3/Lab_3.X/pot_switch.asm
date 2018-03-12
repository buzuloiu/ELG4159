;Group 16
;Paul Buzuloiu
;Manit Ginoya
;Nikhil Peri

;we use pin RA0 because 16 mod 8 is 0
;we use pin RA1 because 17 mod 8 is 1

    
    
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
    BSF TRISA,1 ;Set RA1 to input temporarily
    MOVLW b'11110000' ; set 4 pins as outputs
    MOVWF TRISB
    BCF TRISD,4
    
    BANKSEL PORTC
    BSF PORTD,4

    BANKSEL ANSEL 
    BSF ANSEL,0 ;Set RA0 to analog
    BCF ANSEL,1 ;Set RA1 to digital temporarily

    BANKSEL  OSCCON
    MOVLW b'00100000' ;Set F_osc to  250 kHz
    MOVWF OSCCON

    BANKSEL OPTION_REG
    MOVLW b'10000111' ;set timer0 prescaler to 256
    MOVWF OPTION_REG

    BANKSEL ADCON0
    MOVLW b'10000001' ;Right justify, enable ADC
    MOVWF ADCON0
    CALL SampleTime ; Wait for Acquisiton delay
    goto LOOP

LOOP
    ;BSF ADCON0,GO ;Start conversion for the first time
    call DELAY_T ;sample for a whole second
    call PROCESS_DATA
    call TOGGLE_POT
    GOTO LOOP

TERMINATE
    goto TERMINATE

TOGGLE_POT
    BANKSEL PORTD ;toggle LED0
    MOVLW b'00010000'
    XORWF PORTD,1
    
    
    BANKSEL ADCON0
    MOVLW b'00000100'
    XORWF ADCON0,1
    
    BANKSEL ANSEL
    MOVLW b'00000011'
    XORWF ANSEL,1
    CALL SampleTime
    return
    
PROCESS_DATA
    BTFSC ADCON0,GO ; Wait until conversion finishes
    GOTO PROCESS_DATA
    
    BANKSEL ADRESL ;move LSBs of ADC result to WREG
    MOVF ADRESL,0
    
    
    BANKSEL PORTB ;put result of ADC in PORTB
    MOVWF PORTB
    
    BSF ADCON0,GO ;Start conversion again

    
    BTFSS INTCON,T0IF ;wait until timer overflows (1 second)
    goto PROCESS_DATA
    return

SampleTime ;acquisition delay subroutine, waits 2 microseconds
    BANKSEL INTCON ;move to bank 0
    bcf INTCON,T0IF ;clear timer 0 interrupt flag
    MOVLW d'254' ;set timer0 initial value for tAD
    MOVWF TMR0
    call TimingLoop
    return
    
DELAY_T
    BANKSEL INTCON ;move to bank 0
    bcf INTCON,T0IF ;clear timer 1 interrupt flag
    MOVLW d'12' ;set timer0 initial value for 1 second
    MOVWF TMR0
    return
    
TimingLoop
    BTFSS INTCON,T0IF ;wait until timer overflows (2 microseconds)
    goto TimingLoop
    return

END
