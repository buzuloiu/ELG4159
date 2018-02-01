;************************************************************************************
;   Filename:      WaterLevelController.asm                                          
;   Date:          January 25,2008                                          
;   File Version:  1.00                                                                  
;                                                                      
;************************************************************************************
;                                                                     
;    Files required:                                                  
;          WaterLevelController.inc                                                           
;************************************************************************************
;                                                                     
;    Notes:                                                           
;     This project shows the status of a Water Level Controller
;                                                        
;************************************************************************************
	#include	<WaterLevelController.inc> 			; this file includes variable definitions and pin assignments	

;************************************************************************************
  org 0x00
	goto	Initialize

  org 0x05

;************************************************************************************
; Initialize - Initialize comparators, internal oscillator, I/O pins, 
;	analog pins, variables	
;
;************************************************************************************
Initialize
	bsf		STATUS,RP0		; we'll set up the bank 1 Special Function Registers first

; Configure I/O pins for project	

;---- Student Complete Section below
	
	movlw		b'00000011'		;bits 0 and 1 are inputs, the rest are outputs 
	movwf		TRISA			;configure I/O	
	clrf		TRISB
;---- Student Complete Section above


; Set internal oscillator frequency
	movlw	b'01110000'		; 8Mhz
	movwf	OSCCON
; Set TMR0 parameters
	movlw	b'10000110'		; PORTB pull-up disabled, TMR0 Prescaler 1:128
	movwf	OPTION_REG		
; Turn off comparators
	movlw	0x07
	movwf	CMCON0			; turn off comparators
; Turn off Analog 
	clrf	ANSEL


;************************************************************************************
; Note - When SW2 is pressed, the LED is toggled, and the debounce routine for SW2 is
;        initiated.  Debouncing a switch is necessary to prevent one button press from 
;        being read as more than one button press by the microcontroller.  A 
;        microcontroller can read a button so fast that contact jitter in the switch 
;        may be interpreted as more than one button press.
;
;************************************************************************************

		

Main
;---- Student Complete Section below
	bcf STATUS, RP0 ;bank 0 
	clrw
	
	btfss SW2  
	movlw b'00000010'
	xorwf PORTB,1
	btfss SW2  
	goto DebounceStateSW2 ;check SW2, but debounce it
	
	clrw
	btfss SW3 
	movlw b'00000100'
	xorwf PORTB,1
	btfss SW3  
	goto DebounceStateSW3 ;check SW3, but debounce it
	
	;check if you are below the water amount
	btfsc SENSOR_HI 
	bcf PUMP_ON 
	
	btfss SENSOR_HI
	bsf PUMP_ON

;---- Student Complete Section above
goto Main



DebounceStateSW2				; Wait here until SW2 is released
	btfss	SW2
	goto	DebounceStateSW2
	clrf	TMR0			; Once released clear TMR0 and the TMR0 interrupt flag
	bcf		INTCON,T0IF		;  in preparation to time 16ms

DebounceState2SW2				; State2 makes sure than SW2 is unpressed for 16ms before
	btfss	SW2					;  returning to look for the next time SW2 is pressed
	goto	DebounceStateSW2	; If SW2 is pressed again in this state then return to State1
	btfss	INTCON,T0IF 		; Else, continue to count down 16ms
	goto	DebounceState2SW2	; Time = TMR0_max * TMR0 prescaler * (1/(Fosc/4)) = 256*128*0.5E-6 = 16.4ms
	return

DebounceStateSW3				; Wait here until SW2 is released
	btfss	SW3
	goto	DebounceStateSW3
	clrf	TMR0			; Once released clear TMR0 and the TMR0 interrupt flag
	bcf		INTCON,T0IF		;  in preparation to time 16ms

DebounceState2SW3					; State2 makes sure than SW2 is unpressed for 16ms before
	btfss   SW3					;  returning to look for the next time SW2 is pressed
	goto	DebounceStateSW3	; If SW2 is pressed again in this state then return to State1
	btfss	INTCON,T0IF 		; Else, continue to count down 16ms
	goto	DebounceState2SW3		; Time = TMR0_max * TMR0 prescaler * (1/(Fosc/4)) = 256*128*0.5E-6 = 16.4ms
	return	

	END						; directive 'end of program'
