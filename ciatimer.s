
	.export	ciatimer_init
	.export ciatimer_store
	.export	ciatimer_retrieve

	.macpack	generic

	.code
ciatimer_init:
	lda	#0		; Stop timer B
	sta	$dc0f
	lda	#$ff
	sta	$dc05		; TIMAHI
	sta	$dc04		; TIMALO
	sta	$dc07		; TIMBHI
	sta	$dc06		; TIMBLO
	;; http://www.unusedino.de/ec64/technical/project64/mapping_c64.html
; 	56335         $DC0F          CIACRB
;	Control Register B
;	
;	Bit 0:  Start Timer B (1=start, 0=stop)
;	Bit 1:  Select Timer B output on Port B (1=Timer B output appears on
;	        Bit 7 of Port B)
;	Bit 2:  Port B output mode (1=toggle Bit 7, 0=pulse Bit 7 for one
;	        cycle)
;	Bit 3:  Timer B run mode (1=one-shot, 0=continuous)
;	Bit 4:  Force latched value to be loaded to Timer B counter (1=force
;	        load strobe)
;	Bits 5-6:  Timer B input mode
;	           00 = Timer B counts microprocessor cycles
;	           01 = Count signals on CNT line at pin 4 of User Port
;	           10 = Count each time that Timer A counts down to 0
;	           11 = Count Timer A 0's when CNT pulses are also present
;	Bit 7:  Select Time of Day write (0=writing to TOD registers sets
;	        alarm, 1=writing to TOD registers sets clock)
;	
;	Bits 0-3.  This nybble performs the same functions for Timer B that
;	Bits 0-3 of Control Register A perform for Timer A, except that Timer
;	B output on Data Port B appears at Bit 7, and not Bit 6.
;	
;	Bits 5 and 6.  These two bits are used to select what Timer B counts.
;	If both bits are set to 0, Timer B counts the microprocessor machine
;	cycles (which occur at the rate of 1,022,730 cycles per second).  If
;	Bit 6 is set to 0 and Bit 5 is set to 1, Timer B counts pulses on the
;	CNT line, which is connected to pin 4 of the User Port.  If Bit 6 is
;	set to 1 and Bit 5 is set to 0, Timer B counts Timer A underflow
;	pulses, which is to say that it counts the number of times that Timer
;	A counts down to 0.  This is used to link the two numbers into one
;	32-bit timer that can count up to 70 minutes with accuracy to within
;	1/15 second.  Finally, if both bits are set to 1, Timer B counts the
;	number of times that Timer A counts down to 0 and there is a signal on
;	the CNT line (pin 4 of the User Port).
;	
;	Bit 7.  Bit 7 controls what happens when you write to the Time of Day
;	registers.  If this bit is set to 1, writing to the TOD registers sets
;	the ALARM time.  If this bit is cleared to 0, writing to the TOD
;	registers sets the TOD clock.
	lda	#%01010001
	sta	$dc0f
	rts

	.bss
	;; http://www.oxyron.de/html/registers_cia.html
ciatimer_starttime:
	.res	4
ciatimer_endtime:
	.res	4

	.code
ciatimer_store:
	ldx	#4-1
@l:	lda	$dc04,x
	sta	ciatimer_starttime,x
	dex
	bpl	@l
	rts

	.code
ciatimer_retrieve:
	ldx	#4-1
@l:	lda	$dc04,x
	sta	ciatimer_endtime,x
	dex
	bpl	@l
	lda	ciatimer_starttime
	sub	ciatimer_endtime
	tay
	lda	ciatimer_starttime+1
	sbc	ciatimer_endtime+1
	tax
	lda	ciatimer_starttime+2
	sbc	ciatimer_endtime+2
	rts
	
