	.import	_main
	.import	__BSSMEM_START__
	.import __BSSMEM_SIZE__
	.macpack	cbm

CLEAR_VALUE = 0

	.segment "LOADADDR"
	.export __LOADADDR__
__LOADADDR__:	.word $03fc

	.segment "STARTUP"
	cld
	jmp	skip
;	.ifndef	NDEBUG
;	scrcode	" !DEBUG VERSION DO NOT SPREAD! "
;	.endif
;	.byte	"   "
;	scrcode	"THE 7TH DIVISION"
;	.byte	"   "
		; character codes (1000 bytes)
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$7E,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$7C,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$7C,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$61,$A0,$62,$A0,$FB,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$6C,$A0,$7B,$7C,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$61,$A0,$FE,$A0,$FC,$A0,$FB,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$6C,$A0,$A0,$A0,$7B,$7C,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$61,$A0,$FE,$A0,$A0,$A0,$FC,$A0,$FB,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$6C,$A0,$A0,$A0,$A0,$A0,$7B,$7C,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$61,$A0,$FE,$A0,$A0,$A0,$A0,$A0,$FC,$A0,$FB,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$7E,$A0,$A0,$A0,$A0,$A0,$7C,$7B,$7C,$A0,$A0,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$61,$A0,$A0,$A0,$62,$62,$62,$62,$7B,$A0,$A0,$A0,$FB,$A0,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$62,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$62,$A0,$7C,$A0,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$61,$A0,$FE,$A0,$A0,$A0,$A0,$A0,$A0,$EC,$E2,$FB,$FC,$A0,$FB,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$6C,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$7E,$A0,$A0,$A0,$7B,$7C,$A0,$A0,$A0,$A0,$20,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$61,$A0,$FE,$A0,$61,$7C,$E2,$A0,$A0,$A0,$A0,$6C,$62,$A0,$FC,$A0,$FB,$A0,$A0,$A0,$20,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$7F,$7B,$A0,$A0,$7C,$61,$A0,$A0,$A0,$A0,$A0,$A0,$7C,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$61,$A0,$E1,$A0,$62,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$E1,$A0,$A0,$A0,$A0,$A0,$FB,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$E1,$A0,$A0,$FC,$7B,$A0,$A0,$A0,$A0,$A0,$FE,$A0,$A0,$A0,$A0,$A0,$7C,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$61,$A0,$7B,$A0,$A0,$A0,$A0,$A0,$FC,$A0,$A0,$A0,$6C,$A0,$A0,$A0,$A0,$A0,$6C,$A0,$FB,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$6C,$61,$A0,$A0,$A0,$A0,$A0,$A0,$FC,$A0,$6C,$A0,$A0,$A0,$A0,$EC,$A0,$FE,$7B,$7C,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$61,$A0,$FE,$A0,$A0,$E1,$A0,$A0,$A0,$A0,$EC,$A0,$FE,$A0,$A0,$A0,$A0,$7E,$A0,$A0,$FC,$A0,$FB,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$7E,$6C,$A0,$A0,$61,$A0,$FB,$A0,$A0,$A0,$61,$A0,$A0,$A0,$A0,$A0,$EC,$A0,$FE,$A0,$A0,$7B,$7C,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$FE,$A0,$A0,$A0,$7B,$A0,$FB,$A0,$A0,$7E,$E1,$A0,$A0,$A0,$E2,$A0,$6C,$A0,$A0,$A0,$FC,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$6C,$A0,$A0,$A0,$A0,$A0,$7B,$A0,$7C,$E2,$E2,$A0,$E2,$E2,$A0,$A0,$62,$A0,$A0,$A0,$A0,$A0,$7B,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0
	.byte	 $A0,$A0,$A0,$A0,$A0,$A0,$A0,$7B,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$6C,$A0,$A0,$A0,$A0,$A0,$A0,$A0,$A0

skip:	sei
	jsr	clearbss
	jsr	clearzp
	lda	#$35		; Set to I/O only.
	sta	$1
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
