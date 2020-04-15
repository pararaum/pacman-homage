
	.export	whiteout_spiral
	.include	"pseudo16.inc"
	.include	"globalzeropage.i"
	.import	whiteout_colour
	.import	screen4col
	.import	wait_single_frame
	.macpack	longbranch

	.code
whiteout_spiral:
	P_loadi	dstptr,screen4col
	P_loadi	counter16,40
	lda	#24-1
	sta	@ctr1+1
	sta	@ctr3+1
	lda	#40-1
	sta	@ctr2+1
	lda	#38-1
	sta	@ctr4+1
@bigloop:
	;; Move down.
	ldy	#0
@ctr1:	ldx	#24-1
@l1:
	lda	whiteout_colour
	sta	(dstptr),y
	P_add	counter16,dstptr
	dex
	bpl	@l1
	jsr	wait_single_frame
	;; Move right.
@ctr2:	ldx	#40-1
@l2:
	lda	whiteout_colour
	sta	(dstptr),y
	P_inc	dstptr
	dex
	bpl	@l2
	P_dec	dstptr		; Move to the bottom right corner.
	jsr	wait_single_frame
	;; Move up.
	ldy	#0
@ctr3:	ldx	#24-1
@l3:
	P_sub	counter16,dstptr
	lda	whiteout_colour
	sta	(dstptr),y
	dex
	bpl	@l3
	jsr	wait_single_frame
	;; Move left.
@ctr4:	ldx	#38-1
@l4:	P_dec	dstptr
	lda	whiteout_colour
	sta	(dstptr),y
	dex
	bpl	@l4
	jsr	wait_single_frame
	P_add	counter16,dstptr
	dec	@ctr1+1
	dec	@ctr2+1
	dec	@ctr3+1
	dec	@ctr4+1
	dec	@ctr1+1
	dec	@ctr2+1
	dec	@ctr3+1
	dec	@ctr4+1
	jpl	@bigloop
	rts
