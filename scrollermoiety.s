
	.export	scroller_init

	.include	"pseudo16.inc"

	.importzp	counter16

	.bss
spriteregshadow:
	.res	8		; Sprite positions
spriteregshadowmsb:
	.res	1		; Sprite MSBs
	
	.data

	.code
scroller_init:
	P_loadi	counter16,0
	P_loadi	$fe,48
	ldx	#0
@l1:	lda	counter16
	sta	spriteregshadow,x
	lda	counter16+1
	beq	@skip
	lda	spriteregshadowmsb
	ora	@msbtab,x
	sta	spriteregshadowmsb
@skip:
	P_add	$fe,counter16
	inx
	cpx	#8
	bne	@l1
	rts
@msbtab:
	.byte	1,2,4,8,16,32,64,128
