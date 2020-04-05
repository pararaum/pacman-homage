	.import	_main
	.segment "STARTUP"
	.import	__BSSMEM_START__
	.import __BSSMEM_SIZE__

CLEAR_VALUE = 0

	cld
	clv
	bvc	skip
	.byte	"   "
	.byte $14,$08,$05,$20,$37,$14,$08,$20,$04,$09,$16,$09,$13,$09,$0f,$0e
	.byte	"   "
	.BYTE	"THE 7TH DIVISION"
skip:	sei
	jsr	clearbss
	lda	#$35		; Set to I/O only.
	sta	$1
	ldx	#$ff
	txs
	jsr	_main
	lda	#$37
	sta	$1
	jmp	64738
clearbss:
	lda	#<__BSSMEM_START__ ; Set pointer to the beginning of BSS
	sta	bssptr+1
	lda	#>__BSSMEM_START__
	sta	bssptr+2
	lda	#CLEAR_VALUE	; Clear value
	ldx	#0		; Clear X
	ldy	#>__BSSMEM_SIZE__ ; Number of pages to clear
bssptr:	sta	$aaaa,x		; Clear a page
	dex
	bne	bssptr
	inc	bssptr+2	; Increment to next page.
	dey			; Decrement page counter
	bne	bssptr		; Loop
	;;  See https://github.com/cc65/cc65/blob/master/libsrc/common/zerobss.s
	lda	bssptr+2	; Get high byte.
	sta	restptr+2	; Copy to the pointer to clear the rest.
	lda	#<__BSSMEM_START__ ; Pointer LO byte.
	sta	restptr+1
	lda	#CLEAR_VALUE	; Clear value
	ldx	#<__BSSMEM_SIZE__ ; Remaining number of bytes.
	beq	out		  ; If zero then we are done.
restptr:	sta	$AAAA,x
	dex
	bne	restptr
out:	rts
