	.include	"memoryconfig.i"
	.import	_main
	.import	__BSSMEM_START__
	.import __BSSMEM_SIZE__
	.macpack	cbm

CLEAR_VALUE = 0

	.segment "LOADADDR"
	.export __LOADADDR__
__LOADADDR__:	.word $03fc	; If this changes make sure to check the "crunch" and "run" section of the Makefile!

	.segment "STARTUP"
	cld
	jmp	skip
	.ifndef	NDEBUG
	scrcode	" !DEBUG VERSION DO NOT SPREAD!          "
	.endif
;	.byte	"   "
;	scrcode	"THE 7TH DIVISION"
;	.byte	"   "
	.incbin	"logo.80x50.raw"
	
skip:	sei
	memoryconfig_io		; Set to I/O only.
	jsr	clearbss
	jsr	clearzp
	ldx	#$ff
	txs
	jsr	_main
	lda	#$37
	sta	$1
	jmp	64738
clearzp:
	ldx	#2
@l:	sta	$00,x
	inx
	bne	@l
	rts
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
