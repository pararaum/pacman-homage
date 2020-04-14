
	.export	whiteout_spiral
	.include	"pseudo16.inc"
	.include	"globalzeropage.i"
	.import	whiteout_colour
	.import	screen4col
	.import	wait_single_frame

	.code
whiteout_spiral:
	lda	#$2e
	sta	whiteout_colour
	P_loadi	dstptr,screen4col
	P_loadi	srcptr,40
@bigloop:
	;; Move down.
	ldy	#0
@ctr1:	ldx	#24-1
@l1:	jsr	wait_single_frame
	lda	whiteout_colour
	sta	(dstptr),y
	P_add	srcptr,dstptr
	dex
	bpl	@l1
	;; Move right.
@ctr2:	ldx	#40-1
@l2:	jsr	wait_single_frame
	lda	whiteout_colour
	sta	(dstptr),y
	P_inc	dstptr
	dex
	bpl	@l2
	P_dec	dstptr		; Move to the bottom right corner.
	;; Move up.
	ldy	#0
@ctr3:	ldx	#24-1
@l3:	jsr	wait_single_frame
	P_sub	srcptr,dstptr
	lda	whiteout_colour
	sta	(dstptr),y
	dex
	bpl	@l3
	;; Move left.
@ctr4:	ldx	#39-1
@l4:	P_dec	dstptr
	jsr	wait_single_frame
	lda	whiteout_colour
	sta	(dstptr),y
	dex
	bpl	@l4
	P_add	srcptr,dstptr
	P_dec	dstptr
	dec	@ctr1+1
	dec	@ctr2+1
	dec	@ctr3+1
	dec	@ctr4+1
	jmp	@bigloop
	rts
