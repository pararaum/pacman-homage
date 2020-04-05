
	.segment "IMAGE"
	.export	sprites
	.export	imagecolours
	.export	spritepointer
	.export	whiteout_screen
	.export copy_image2screen

	.macpack	generic

sprites:
	.res	64*16		; 1024
screen0:
	.res	1024
screen4col:			; Screen with colours for the hires bitmap in the later stages.
	.res	1000		; 40*25
	.res	16		; Empty space
spritepointer:
	.res	8
imagecolours:
	;; Screen Ram, positioned in the file after the 8000 bytes of the bitmap.
	.incbin	"toru_iwatani.bw.c64",8000,1000
	.res	24		; Empty space
	;; Here comes the bitmap, the first 8000 bytes of the file.
	.incbin	"toru_iwatani.bw.c64",0,8000

	.code
;;; Whiteout the screen (only a single step). The screen colours (hires bitmap) are shaded away, starting left and right. After being called 20 times the screen is filled with white. 
whiteout_screen:
	lda	#$ff
	jmp	colourout_screen
;;; Colourout the screen (only a single step). The screen colours (hires bitmap) are shaded away, starting left and right. After being called 20 times the screen is filled with white.
;;; Input: A=colour to fill the screen with
;;; Output:
;;; Modifies: A/X/Y
colourout_screen:
	pha
	lda	_whiteout_pos
	tax
	;; 40-A-1 = -(A+1-40)
	sub	#39
	eor	#$ff		; Negate
	add	#1
	tay
	pla
	sta	screen4col+40*00,x
	sta	screen4col+40*00,y
	sta	screen4col+40*01,x
	sta	screen4col+40*01,y
	sta	screen4col+40*02,x
	sta	screen4col+40*02,y
	sta	screen4col+40*03,x
	sta	screen4col+40*03,y
	sta	screen4col+40*04,x
	sta	screen4col+40*04,y
	sta	screen4col+40*05,x
	sta	screen4col+40*05,y
	sta	screen4col+40*06,x
	sta	screen4col+40*06,y
	sta	screen4col+40*07,x
	sta	screen4col+40*07,y
	sta	screen4col+40*08,x
	sta	screen4col+40*08,y
	sta	screen4col+40*09,x
	sta	screen4col+40*09,y
	sta	screen4col+40*10,x
	sta	screen4col+40*10,y
	sta	screen4col+40*11,x
	sta	screen4col+40*11,y
	sta	screen4col+40*12,x
	sta	screen4col+40*12,y
	sta	screen4col+40*13,x
	sta	screen4col+40*13,y
	sta	screen4col+40*14,x
	sta	screen4col+40*14,y
	sta	screen4col+40*15,x
	sta	screen4col+40*15,y
	sta	screen4col+40*16,x
	sta	screen4col+40*16,y
	sta	screen4col+40*17,x
	sta	screen4col+40*17,y
	sta	screen4col+40*18,x
	sta	screen4col+40*18,y
	sta	screen4col+40*19,x
	sta	screen4col+40*19,y
	sta	screen4col+40*20,x
	sta	screen4col+40*20,y
	sta	screen4col+40*21,x
	sta	screen4col+40*21,y
	sta	screen4col+40*22,x
	sta	screen4col+40*22,y
	sta	screen4col+40*23,x
	sta	screen4col+40*23,y
	sta	screen4col+40*24,x
	sta	screen4col+40*24,y
	;; Loop missing
	dec	_whiteout_pos
	dec	_whiteout_pos
	bpl	@out
	lda	#39
	sta	_whiteout_pos
	@out:
	rts

	.data
_whiteout_pos:	.byte	39



	.code
;;; Copy the image data to the screen ram.
copy_image2screen:
	ldx	#0
	@l1:
	lda	imagecolours,x
	sta	screen4col,x
	lda	imagecolours+$100,x
	sta	screen4col+$100,x
	lda	imagecolours+$200,x
	sta	screen4col+$200,x
	inx
	bne	@l1
	ldx	#$f7
	@l2:
	lda	imagecolours+$300,x
	sta	screen4col+$300,x
	dex
	bne	@l2
	lda	imagecolours+$300
	sta	screen4col+$300
	rts

