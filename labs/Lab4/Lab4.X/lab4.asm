;ELG 4159 Lab 4
;Group 16
;Paul Buzuloiu
;Manit Ginoya
;Nikhil Peri
    
;use AN0 because 16 mod 8 is 0
;CCP2 because 16 is even
    
  
__CONFIG _CP_OFF & _CPD_OFF & _BOD_OFF & _PWRTE_ON & _WDT_OFF & _INTRC_OSC_NOCLKOUT & _MCLRE_ON & _FCMEN_OFF & _IESO_OFF
errorlevel -302 ; supress "register not in bank0, check page bits" message

temp_msb_A = 0x20;some GPR
temp_lsb_A = 0x21;the next GPR
temp_msb_B = 0x22;some GPR
temp_lsb_B = 0x23;the next GPR

seven_counter = 0x24;the next next GPR

#include<p16f917.inc>
    org 0x00
    goto START 
    org 0x05
    
START
    ;configure PWM
    bsf STATUS,RP0;bank1
    bcf STATUS,RP1
    bsf TRISD,2 ;configure RD2 as temporary input
    movlw d'255'
    movwf PR2
    movlw b'01110000'
    movwf OSCCON
    bcf STATUS,RP0 ;bank 0
    movlw b'00000100' ;postscaler=0 prescaler=1 enable=yes
    movwf T2CON
    bsf STATUS,RP0 ;configure RD2 back to output
    BCF TRISD,2
    
    ;configure ADC
    BANKSEL ADCON1
    MOVLW b'01010000' ;set ADC Prescaler to 16
    MOVWF ADCON1
    BANKSEL TRISA
    BSF TRISA,0 ;Set RA0 to input
    BANKSEL ANSEL 
    BSF ANSEL,0 ;Set RA0 to analog
    BANKSEL OPTION_REG
    MOVLW b'10000111' ;set timer0 prescaler to 256
    MOVWF OPTION_REG
    BANKSEL ADCON0
    MOVLW b'00000001' ;Left justify, enable ADC
    MOVWF ADCON0
    call SampleTime
    goto MAIN
    
MAIN
    BANKSEL ADCON0
    BTFSC ADCON0,GO ; Wait until conversion finishes
    GOTO MAIN
    call move_adc_to_temp
    call right_shift_10_bit;divide by 8
    call right_shift_10_bit
    call right_shift_10_bit
    call multiply_10_bit_by_7
    bsf STATUS,RP0;bank1
    bcf STATUS,RP1
    bsf TRISD,2 ;configure RD2 as temporary input
    call move_temp_to_analog
    banksel STATUS
    bsf STATUS,RP0 ;configure RD2 back to output
    BCF TRISD,2
    BANKSEL ADCON0
    BSF ADCON0,GO ;Start conversion again
    goto MAIN
      
TERMINATE
    goto TERMINATE
    
move_adc_to_temp
    BANKSEL ADRESH ;get MSBs and move them to temp
    MOVF ADRESH,0
    MOVWF temp_msb_A
    BANKSEL ADRESL ;get LSBs and move them to temp
    MOVF ADRESL,0
    BCF STATUS,RP0
    MOVWF temp_lsb_A
    return
    
move_temp_to_analog
    BCF STATUS,RP1 ;bank 0 for the temp registers
    BCF STATUS,RP0
    RLF temp_msb_B,1
    RLF temp_msb_B,0
    ;move temp to work reg
    BANKSEL CCP2CON
    movwf CCP2CON ;<5:4> as computed in part 1, <3:0> = 11xx for PWM
    BSF CCP2CON,3 
    BSF CCP2CON,2
    BCF CCP2CON,1
    BCF CCP2CON,0
    BCF STATUS,RP0;get LSBs from temp
    MOVF temp_lsb_B,0
    BANKSEL CCPR2L
    movwf CCPR2L ;as computed in part 1
    return
    
right_shift_10_bit
    BCF STATUS,RP0
    BCF STATUS,RP1
    RRF temp_msb_A,0 ;if a 1 is carried out, it will automatically be carried into temp_lsb
    MOVLW temp_msb_A
    MOVLW temp_msb_B
    RRF temp_lsb_A,0
    MOVLW temp_lsb_A
    MOVLW temp_lsb_B
    return
    
multiply_10_bit_by_7
    BCF STATUS,RP0
    BCF STATUS,RP1
    MOVLW d'7'
    MOVF seven_counter
    call multiply_10_bit_by_7_2
    return
    
multiply_10_bit_by_7_2
    MOVLW temp_lsb_A
    ADDWF temp_lsb_B,1
    ;add work reg to number
    BTFSC STATUS,C ;check if LSBs had a carry
    INCF temp_msb_B,1
    MOVLW temp_msb_A
    ADDWF temp_msb_B,1
    DECFSZ seven_counter,1
    goto multiply_10_bit_by_7_2
    return
    
SampleTime ;acquisition delay subroutine, waits 2 microseconds
    BANKSEL INTCON ;move to bank 0
    BCF INTCON,T0IF ;clear timer 0 interrupt flag
    MOVLW d'254' ;set timer0 initial value for tAD
    MOVWF TMR0
    call TimingLoop
    return
    
TimingLoop
    BTFSS INTCON,T0IF ;wait until timer overflows (2 microseconds)
    goto TimingLoop
    return
    
END