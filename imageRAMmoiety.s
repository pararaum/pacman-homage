
	.segment "IMAGE"
	.export	sprites
	.export	imagecolours
	.export	spritepointer
	.export	whiteout_screen
	.macpack	generic

sprites:
	.res	64*16		; 1024
screen0:
	.res	1024
screen1:
	.res	1024
imagecolours:
	;; Screen Ram, positioned in the file after the 8000 bytes of the bitmap.
	.incbin	"toru_iwatani.bw.c64",8000,1000
	.res	16		; Empty space
spritepointer:
	.res	8
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
	sta	imagecolours+40*00,x
	sta	imagecolours+40*00,y
	sta	imagecolours+40*01,x
	sta	imagecolours+40*01,y
	sta	imagecolours+40*02,x
	sta	imagecolours+40*02,y
	sta	imagecolours+40*03,x
	sta	imagecolours+40*03,y
	sta	imagecolours+40*04,x
	sta	imagecolours+40*04,y
	sta	imagecolours+40*05,x
	sta	imagecolours+40*05,y
	sta	imagecolours+40*06,x
	sta	imagecolours+40*06,y
	sta	imagecolours+40*07,x
	sta	imagecolours+40*07,y
	sta	imagecolours+40*08,x
	sta	imagecolours+40*08,y
	sta	imagecolours+40*09,x
	sta	imagecolours+40*09,y
	sta	imagecolours+40*10,x
	sta	imagecolours+40*10,y
	sta	imagecolours+40*11,x
	sta	imagecolours+40*11,y
	sta	imagecolours+40*12,x
	sta	imagecolours+40*12,y
	sta	imagecolours+40*13,x
	sta	imagecolours+40*13,y
	sta	imagecolours+40*14,x
	sta	imagecolours+40*14,y
	sta	imagecolours+40*15,x
	sta	imagecolours+40*15,y
	sta	imagecolours+40*16,x
	sta	imagecolours+40*16,y
	sta	imagecolours+40*17,x
	sta	imagecolours+40*17,y
	sta	imagecolours+40*18,x
	sta	imagecolours+40*18,y
	sta	imagecolours+40*19,x
	sta	imagecolours+40*19,y
	sta	imagecolours+40*20,x
	sta	imagecolours+40*20,y
	sta	imagecolours+40*21,x
	sta	imagecolours+40*21,y
	sta	imagecolours+40*22,x
	sta	imagecolours+40*22,y
	sta	imagecolours+40*23,x
	sta	imagecolours+40*23,y
	sta	imagecolours+40*24,x
	sta	imagecolours+40*24,y
	sta	imagecolours+40*25,x
	sta	imagecolours+40*25,y
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
