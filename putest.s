
	.import	unpucrunch

	.segment "STARTUP"
	cld
	cld
	jsr	_main
	lda	#0
	rts

	.SEGMENT "INIT"
	.SEGMENT "ONCE"
	
	.code
_main:
	ldx	#>crunched_data
	ldy	#<crunched_data
	jsr	unpucrunch
	lda	#5
	sta	$d020
	rts

	.data
crunched_data:
	.incbin	"test1.pucrunch",2 ;Skip load address...
	.dword	$A555555A
