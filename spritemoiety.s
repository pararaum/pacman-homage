	.export animate_sprite
	.export move_sprite0_horizontally
	.export	copy_a_sprite

	.import	framecounter
	.import spritepointer
	.import	sprites

	.macpack generic

	.data
;;; TODO: clean up this crap!
sprite0pos:	.byte	50
	.word	24

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

	.code
setsprite:
	lda	sprite0pos
	sta	$d000
	lda	sprite0pos+1
	sta	$d001
	lda	sprite0pos+2
	beq	@out
	lda	#1
	ora	$d010
	sta	$d010
	@out:
	rts

;;; Animate the sprite pointer.
;;; Modifies: A/X/Y
	.code
animate_sprite:
	lda	framecounter
	lsr
	lsr
	and	#$03
	add	#($d000-$c000)/64
	ldx	#0
	@l:
	sta	spritepointer,x
	inx
	cpx	#4
	bne	@l
	rts

	.code
move_sprite0_horizontally:
	lda	$d010		; MSB
	and 	#%00000001	; MSB of sprite 0.
	bne	@greater256
	lda	$d000
	add	#3
	sta	$d000
	bcs	@overflow
	rts
	@overflow:
	lda	#%00000001
	ora	$d010		; Set MSB of X position.
	sta	$d010
	rts
	@greater256:
	lda	$d000
	add	#3
	sta	$d000
	cmp	#345-256	; Out of right border?
	bcc	@out		; No.
	lda	#0		; Reset to zero
	sta	$d000
	lda	#%11111110
	and	$d010		; Clear MSB of X position.
	sta	$d010
	@out:
	rts
