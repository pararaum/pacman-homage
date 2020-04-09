
	.export	scroller_init
	.export	scroller_advance
	.export	scroller_copypos2vic
	.export	spriteregshadow

	.include	"pseudo16.inc"
	.include	"memoryconfig.i"
	.macpack	generic

	.importzp	counter16
	.importzp	dstptr
	.importzp	tmp16
	.import	framecounter
	.import	spritescroller

	.bss
spriteregshadow:
	.res	8*2		; Sprite positions
spriteregshadowmsb:
	.res	1		; Sprite MSBs
	
	.data
sprite_y_pos:	.byte	250-21*2
real_sprite_xpos:
	.word	1+48*0, 1+48*1, 1+48*2, 1+48*3, 1+48*4, 1+48*5, 1+48*6, 1+48*7

	.zeropage
tmpxpos:	.res	2


	.code
scroller_init:
	ldx	#0
@l1:	lda	sprite_y_pos
	sta	spriteregshadow+1,x
	lda	#0
	sta	spriteregshadow,x
	inx
	inx
	cpx	#8*2
	bne	@l1
	.ifndef NDEBUG
	lda	1
	pha
	memoryconfig_ram
	ldx	#0
@dbg1:	txa
	sta	spritescroller,x
	dex
	bne	@dbg1
	pla
	sta	1
	.endif
	rts
	.data
msbtab:
	.byte	1,2,4,8,16,32,64,128

	.code
scroller_advance:
	ldx	#0
@loop:
	sec
	lda	real_sprite_xpos,x
	sbc	#1
	sta	real_sprite_xpos,x
	bcs	@nounderflow
	dec	real_sprite_xpos+1,x
	bpl	@nounderflow
	txa			; Spritenumber*2 into A
	lsr			; divide by two so that spritenumber is in A
	jsr	scroller_new_chars
	lda	#<(1+48*7+24+8)	; The left border has a width of 24 pixels.
	sta	real_sprite_xpos,x
	lda	#>(1+48*7+24+8)
	sta	real_sprite_xpos+1,x
@nounderflow:
	inx
	inx
	cpx	#16
	bne	@loop
	rts

;;; Input: A=sprite number
;;; Modifies: A/Y
scroller_new_chars:
	pha
	P_loadi	dstptr,spritescroller
	pla
	sta	counter16
	lda	#0
	sta	counter16+1
	.repeat	6		; *64
	asl	counter16
	rol	counter16+1
	.endrepeat
	P_add	counter16,dstptr
	ldy	#63
	lda	framecounter
@copy:	sta	(dstptr),y
	dey
	bne	@copy
	rts

scroller_copypos2vic:
	ldx	#0
	stx	$d010		; Clear all MSBs!
@l:	lda	sprite_y_pos
	sta	$d000+1,x
	lda	real_sprite_xpos,x
	sta	tmpxpos
	lda	real_sprite_xpos+1,x
	sta	tmpxpos+1
	P_loadi	tmp16,24
	P_sub	tmp16,tmpxpos	; Now subtract left border size from position.
	bpl	@sp		; Is it still positive?
	;;  Nope. For PAL, sprite positions (in our coordinate system) between [-24;0) have to lie between [$e0;$f7). So subtract seven.
	lda	tmpxpos
	sub	#8
	sta	tmpxpos
	;; HI byte is non-zero so that is ok.
@sp:
	lda	tmpxpos
	sta	$d000,x
	lda	tmpxpos+1
	beq	@nosetmsb
	txa
	lsr
	tay
	lda	msbtab,y
	ora	$d010
	sta	$d010
@nosetmsb:
	inx
	inx
	cpx	#16
	bne	@l
	lda	#12
	ldx	#7
@l2:	sta	$d027,x
	dex
	bpl	@l2
	rts
