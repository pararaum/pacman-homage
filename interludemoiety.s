;;; Second type of interlude, this will make an animation of running pacmans animated via charset manipulation.

	.include	"memoryconfig.i"
	.include	"tools.i"
	.import		fill_screenram

	.export		interlude

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
