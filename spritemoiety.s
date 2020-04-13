	.export animate_sprite
	.export	animate_sprite_sequence
	.export move_sprite0_horizontally
	.export	copy_a_sprite

	.include	"pseudo16.inc"

	.import	framecounter
	.import spritepointer
	.import	sprites

	.macpack generic

	.code
	;;; Copy a sprite into a sprite buffer.
;;; Input: A/X=pointer to sprite data, Y=Number of sprite buffer relative to "sprites".
;;; Changes: A/X
copy_a_sprite:
	sta	@l1+1
	stx	@l1+2
	lda	#<sprites	; Set default destination address.
	sta	@spritesptr+1
	lda	#>sprites
	sta	@spritesptr+2
	tya			; Move sprite buffer position into A
	asl			; * 64
	asl
	asl
	asl
	asl
	asl
	clc
	adc	@spritesptr+1	; Add to low byte
	sta	@spritesptr+1
	bcc	@run
	inc	@spritesptr+2
@run:	ldx	#63
@l1:	lda	$ffff,x
@spritesptr:
	sta	sprites,x
	dex
	bpl	@l1
	rts

;;; Animate the sprite pointer.
;;; Modifies: A/X/Y
	.code
animate_sprite:
	lda	framecounter
	lsr
	lsr
	ldx	animate_sprite_sequence
	beq	@szero
	lsr
	and	#3
	add	#4		; Jump to the ghost sprites.
	jmp	@animate
@szero:
	and	#$03
@animate:	
	add	#($d000-$c000)/64
	ldx	#0
@l:
	sta	spritepointer,x
	inx
	cpx	#4
	bne	@l
	rts
	.data
animate_sprite_sequence:
	.byte	0		; This is animation sequence to be used.
	
	.data
;;; TODO: clean up this crap!
sprite0pos:
	.word	24
	.byte	50

	.code
setsprite0:
	lda	sprite0pos	; lo x-pos
	sta	$d000
	lda	sprite0pos+2	; y-pos
	sta	$d001
	lda	$d010		; MSB
	and	#%11111110
	ldx	sprite0pos+1	; hi x-pos
	beq	@out
	ora	#%00000001
@out:
	sta	$d010
	rts

	.code
move_sprite0_horizontally:
	jsr	setsprite0
	P_inc	sprite0pos
	P_inc	sprite0pos
	P_inc	sprite0pos
	lda	sprite0pos+1	; HI of x-pos
	beq	@out
	lda	sprite0pos
	cmp	#345-256	; Out of right border?
	bcc	@out		; No.
	P_loadi	sprite0pos,0
@out:
	rts
