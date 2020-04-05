	.export sprite_0, sprite_1, sprite_2,sprite_3
	.export animate_sprite

	.import	framecounter
	.import spritepointer

	.macpack generic

	.data
;;; The zero byte fills the sprite up to 64 bytes so that they are correctly aligned.
;;; Generated by SpriteMate by Awsm.
;; sprite 0 / singlecolor / color: $07
sprite_0:
	.byte %00000000,%01111100,%00000000
	.byte %00000001,%11111111,%00000000
	.byte %00000111,%11111111,%11000000
	.byte %00001111,%11111111,%11100000
	.byte %00011111,%11111111,%11110000
	.byte %00011111,%11111111,%11110000
	.byte %00111111,%11111111,%11111000
	.byte %00111111,%11111111,%11111000
	.byte %01111111,%11111111,%11111100
	.byte %01111111,%11111111,%11111100
	.byte %01111111,%11100000,%00000000
	.byte %01111111,%11111111,%11111100
	.byte %01111111,%11111111,%11111100
	.byte %00111111,%11111111,%11111000
	.byte %00111111,%11111111,%11111000
	.byte %00011111,%11111111,%11110000
	.byte %00011111,%11111111,%11110000
	.byte %00001111,%11111111,%11100000
	.byte %00000111,%11111111,%11000000
	.byte %00000001,%11111111,%00000000
	.byte %00000000,%01111100,%00000000
	.byte	0
;; sprite 1 / singlecolor / color: $07
sprite_1:
	.byte %00000000,%01111100,%00000000
	.byte %00000001,%11111111,%00000000
	.byte %00000111,%11111111,%11000000
	.byte %00001111,%11111111,%11100000
	.byte %00011111,%11111111,%11110000
	.byte %00011111,%11111111,%11110000
	.byte %00111111,%11111111,%11100000
	.byte %00111111,%11111111,%10000000
	.byte %01111111,%11111110,%00000000
	.byte %01111111,%11111000,%00000000
	.byte %01111111,%11100000,%00000000
	.byte %01111111,%11111000,%00000000
	.byte %01111111,%11111110,%00000000
	.byte %00111111,%11111111,%10000000
	.byte %00111111,%11111111,%11100000
	.byte %00011111,%11111111,%11110000
	.byte %00011111,%11111111,%11110000
	.byte %00001111,%11111111,%11100000
	.byte %00000111,%11111111,%11000000
	.byte %00000001,%11111111,%00000000
	.byte %00000000,%01111100,%00000000
	.byte	0
;; sprite 2 / singlecolor / color: $07
sprite_2:
	.byte %00000000,%01111100,%00000000
	.byte %00000001,%11111111,%00000000
	.byte %00000111,%11111111,%11000000
	.byte %00001111,%11111111,%11000000
	.byte %00011111,%11111111,%10000000
	.byte %00011111,%11111111,%00000000
	.byte %00111111,%11111110,%00000000
	.byte %00111111,%11111100,%00000000
	.byte %01111111,%11111000,%00000000
	.byte %01111111,%11110000,%00000000
	.byte %01111111,%11100000,%00000000
	.byte %01111111,%11110000,%00000000
	.byte %01111111,%11111000,%00000000
	.byte %00111111,%11111100,%00000000
	.byte %00111111,%11111110,%00000000
	.byte %00011111,%11111111,%00000000
	.byte %00011111,%11111111,%10000000
	.byte %00001111,%11111111,%11000000
	.byte %00000111,%11111111,%11000000
	.byte %00000001,%11111111,%00000000
	.byte %00000000,%01111100,%00000000
	.byte	0
;; sprite 3 / singlecolor / color: $07
sprite_3:
	.byte %00000000,%01111100,%00000000
	.byte %00000001,%11111111,%00000000
	.byte %00000111,%11111111,%11000000
	.byte %00001111,%11111111,%11100000
	.byte %00011111,%11111111,%11110000
	.byte %00011111,%11111111,%11110000
	.byte %00111111,%11111111,%11100000
	.byte %00111111,%11111111,%10000000
	.byte %01111111,%11111110,%00000000
	.byte %01111111,%11111000,%00000000
	.byte %01111111,%11100000,%00000000
	.byte %01111111,%11111000,%00000000
	.byte %01111111,%11111110,%00000000
	.byte %00111111,%11111111,%10000000
	.byte %00111111,%11111111,%11100000
	.byte %00011111,%11111111,%11110000
	.byte %00011111,%11111111,%11110000
	.byte %00001111,%11111111,%11100000
	.byte %00000111,%11111111,%11000000
	.byte %00000001,%11111111,%00000000
	.byte %00000000,%01111100,%00000000
	.byte	0
;; sprite 4 / singlecolor / color: $07
sprite_4:
	.byte %00000000,%01111100,%00000000
	.byte %00000001,%11111111,%00000000
	.byte %00000111,%11111111,%11000000
	.byte %00001111,%11111111,%11100000
	.byte %00011111,%11111111,%11110000
	.byte %00011111,%11111111,%11110000
	.byte %00111111,%11111111,%11111000
	.byte %00111111,%11111111,%11111000
	.byte %01111111,%11111111,%11111100
	.byte %01111111,%11111111,%11111100
	.byte %01111111,%11101111,%11111100
	.byte %01111111,%11111111,%11111100
	.byte %01111111,%11111111,%11111100
	.byte %00111111,%11111111,%11111000
	.byte %00111111,%11111111,%11111000
	.byte %00011111,%11111111,%11110000
	.byte %00011111,%11111111,%11110000
	.byte %00001111,%11111111,%11100000
	.byte %00000111,%11111111,%11000000
	.byte %00000001,%11111111,%00000000
	.byte %00000000,%01111100,%00000000

;;; TODO: clean up this crap!
sprite0pos:	.byte	50
	.word	24

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

