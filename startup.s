	.import	_main
	.segment "STARTUP"
	cld
	cld
	sei
	lda	#$35		; Set to I/O only.
	sta	$1
	;;  Clear BSS
	ldx	#0
	txa
clearloop:
	sta	$0200,x
	sta	$0300,x
	dex
	bne	clearloop
	ldx	#$ff
	txs
	jsr	_main
	lda	#$37
	sta	$1
	jmp	64738
	.byte	"   "
	.byte $14,$08,$05,$20,$37,$14,$08,$20,$04,$09,$16,$09,$13,$09,$0f,$0e
	.byte	"   "
	.BYTE	"THE 7TH DIVISION"
