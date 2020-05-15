
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

	.export _main

	.zeropage
srcptr:	.word	0
dstptr:	.word	0
srcend:	.word	0
tmpptr:	.word	0
counter16:	.word 0


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
	jsr	whiteout_spiral
	jsr	uncompress_next_image
	cmp	#0
	jeq	@end
	jsr	colourin_spiral
	lda	#$2
	jsr	wait_for_framecounter
	;; LFSR
	jsr	whiteout_via_lfsr
	jsr	wavyinterlude
	jsr	uncompress_next_image
	cmp	#0
	jeq	@end
	jsr	colourin_via_lfsr
	jsr	reset_framecounter
	lda	#$2
	jsr	wait_for_framecounter
	lda	animate_sprite_sequence
	eor	#1
	sta	animate_sprite_sequence
	;; vartical bars
	jsr	whiteout_whole_screen
	jsr	wavyinterlude
	jsr	uncompress_next_image
	cmp	#0
	jeq	@end
	jsr	colourin_whole_screen
	jsr	reset_framecounter
	lda	#$2
	jsr	wait_for_framecounter
	jmp	displayloop
@end:	;;
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

	;; https://www.c64-wiki.com/wiki/raster_time
; Raster time equals the duration it takes the VIC-II to put a byte of graphic data (=8 pixels/bits) onto the screen and is measured in horizontal lines or CPU cycles.
; 
; Raster time for one horizontal line of graphic (504 pixels including border) equals 63 CPU cycles. The whole graphic screen consists of 312 horizontal lines including the border. In total there are 63 * 312 CPU cycles for one complete screen update/frame, which equals 19656 CPU cycles. Given the C64 CPU clock with 985248 Hertz divided by the 19565 CPU cycles, the result is ~50Hz (the PAL screen standard), not considering the time for screen blanking.

interlude:
	sei
	memoryconfig_io
	lda	$d011
	pha
	lda	$d016
	pha
	lda	$d018
	pha
	lda	#%00010011
	sta	$d011
	lda	#%00011000
	sta	$d016
	memoryconfig_ram
	cli

	lda	#0
	jsr	fill_screenram
	lda	#%11000000
	sta	$f000
	sta	$f001
	sta	$f002
	sta	$f003
	sta	$f004
	sta	$f005
	sta	$f006
	sta	$f007
@bl:
	jsr	wait_single_frame
	ldx	#7
@l1:
	lda	$f000,x
	cmp	#$80
	rol	$f000,x
	lda	$f000,x
	cmp	#$80
	rol	$f000,x
	dex
	bpl	@l1
	jmp	@bl
	lda	#$22
	jsr	wait_for_framecounter

	sei
	memoryconfig_io
	pla
	sta	$d018
	pla
	sta	$d016
	pla
	sta	$d011
	memoryconfig_ram
	cli
	rts
