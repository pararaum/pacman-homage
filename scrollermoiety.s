
	.export	scroller_init
	.export	scroller_advance
	.export	spriteregshadow

	.include	"pseudo16.inc"
	.include	"memoryconfig.i"

	.importzp	counter16
	.importzp	dstptr
	.import	framecounter
	.import	spritescroller

	.bss
spriteregshadow:
	.res	8*2		; Sprite positions
spriteregshadowmsb:
	.res	1		; Sprite MSBs
	
	.data
sprite_y_pos:	.byte	250-21*2

	.code
scroller_init:
	P_loadi	counter16,1
	P_loadi	$fe,48
	ldx	#0
@l1:	lda	sprite_y_pos
	sta	spriteregshadow+1,x
	lda	counter16
	sta	spriteregshadow,x
	lda	counter16+1
	beq	@skip
	txa
	lsr
	tay
	lda	spriteregshadowmsb
	ora	msbtab,y
	sta	spriteregshadowmsb
@skip:
	P_add	$fe,counter16
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
	ldx	#7*2		; 7th sprite
@loop:
	txa
	lsr
	tay
	lda	msbtab,y
	and	spriteregshadowmsb
	beq	@leftarea	; X<256?
	dec	spriteregshadow,x
	bpl	@out
	lda	msbtab,y
	eor	#$ff
	and	spriteregshadowmsb
	sta	spriteregshadowmsb
	jmp	@out
@leftarea:
	dec	spriteregshadow,x
	bne	@out
	lda	msbtab,y
	ora	spriteregshadowmsb
	sta	spriteregshadowmsb
	lda	#7*48-256
	sta	spriteregshadow,x
	;; Next char
	P_loadi	dstptr,spritescroller
	txa
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
@out:
	dex
	dex			; Skip Y position of previous sprite.
	bpl	@loop
	rts
