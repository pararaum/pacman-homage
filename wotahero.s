
;;; ca65 -t c64 -I ../includeCC65/ wotahero.s && cl65  wotahero.o wotahero.cfg

	.include	"vicmacros.i"
	.include	"pseudo16.inc"
	.include	"memoryconfig.i"
	.include	"tools.i"
	.macpack	longbranch
	.macpack	cbm
	.macpack	generic

	.import unpucrunch
	.import	shuffle_image_memory
	.import	sprites
	.import whiteout_screen
	.import uncompress_next_image
	.import copy_image2screen
	.import	setupirq
	.import	ciatimer_init
	.import scroller_init
	.import colourin_via_lfsr
	.import whiteout_via_lfsr
	.import whiteout_whole_screen
	.import colourin_whole_screen
	.import animate_sprite_sequence
	.import	whiteout_spiral
	.import	colourin_spiral
	.import	fill_screenram
	.import wavyinterlude
	.import	sidMuzakInit
	.import whiteout_horizontal
	.import interlude

	.export _main

	.zeropage
srcptr:	.word	0
dstptr:	.word	0
srcend:	.word	0
tmpptr:	.word	0
counter16:	.word 0

	.macro	out_in_step woutfun,cinfun
	jsr	woutfun
	jsr	uncompress_next_image
	cmp	#0
	jeq	end_of_mainloop
	jsr	cinfun
	lda	#2
	jsr	wait_for_framecounter
	.endmacro

	.data
	.asciiz	"Data Segment"

	.code
_main:
	lda	#$0
	sta	$d020
	lda	#$f		; Light gray background.
	sta	$d021
	lda	#%00111011	; Bitmap Mode.
	sta	$d011
	lda	#%00001000	; Single colour mode, 40 columns.
	sta	$d016
	jsr	setupirq
	jsr	init
	jsr	scroller_init
	memoryconfig_ram
	cli
mainloop:
	sei
	.ifndef	NDEBUG
	pha
	lda	$1
	cmp	#$34
	beq	@ok84
	.byte	$52
	@ok84:
	pla
	.endif
	inc	$1		; I/O on
	;; I/O stuff.
	dec	$1
	cli
	jsr	copy_image2screen
	;; Now wait some time before the displayloop begins.
	.ifdef	DEBUG
	lda	#$1
	.else
	lda	#$4
	.endif
	jsr	wait_for_framecounter
	;; 	jsr	interlude
displayloop:
	;; Spiral
	out_in_step	whiteout_spiral,colourin_spiral
	;; LFSR
	out_in_step	whiteout_via_lfsr,colourin_via_lfsr
	;; 	jsr	wavyinterlude
	lda	animate_sprite_sequence
	eor	#1
	sta	animate_sprite_sequence
	;; vartical bars
	out_in_step	whiteout_whole_screen,colourin_whole_screen
	;; 	jsr	wavyinterlude
	jsr	whiteout_via_lfsr     ; ⎞
	jsr	wavyinterlude	      ; ⎟
	jsr	uncompress_next_image ; ⎟
	cmp	#0		      ; ⎟
	jeq	end_of_mainloop	      ; ⎬ Show the interlude.
	jsr	colourin_via_lfsr     ; ⎟
	jsr	reset_framecounter    ; ⎟
	lda	#2		      ; ⎟
	jsr	wait_for_framecounter ; ⎠
	jmp	displayloop
end_of_mainloop:	;;
	rts


;;; At the beginning the image is displayed at $E000 ($2000 in the VIC bank), the screen ram is located at $DC00 ($1c00 in the VIC bank). 
init:
	SwitchVICBank 3
	;; Turn on raster engine and display a bitmap.
	lda	#%00111011	; https://www.c64-wiki.de/wiki/VIC
	sta	$d011
	SetBitmapAddress $2000
	SetScreenMemory $1800
	lda	#0
	jsr	sidMuzakInit
	lda	#50		; Position of sprite 0
	ldx	#0
@l1:	sta	$d000,x
	sta	$d001,x
	add	#31
	inx
	inx
	cpx	#16
	bne	@l1
	lda	#0
	sta	$d010		; MSB is zero of all sprites.
	sta	$d01b		; Sprites have priority.
	sta	$d01c		; Single colour sprites.
	lda	#$ff		; Turn sprites on.
	sta	$d015
	lda	#$ff		; Make them big.
	sta	$d017
	sta	$d01d
	lda	#7		; Yello
	sta	$d027
	jsr	ciatimer_init
	rts

