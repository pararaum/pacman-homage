
;;; ca65 -t c64 -I ../includeCC65/ wotahero.s && cl65  wotahero.o wotahero.cfg

	.include	"vicmacros.i"
	.include	"pseudo16.inc"
	.include	"memoryconfig.i"
	.macpack	longbranch
	.macpack	cbm
	.macpack	generic

	.import unpucrunch
	.import	shuffle_image_memory
	.import	sprites
	.import whiteout_screen
	.import wait_for_framecounter
	.import	wait_single_frame
	.import	framecounter
	.import uncompress_next_image
	.import copy_image2screen
	.import	irqroutine
	.import	ciatimer_init
	.import scroller_init
	.import whiteout_via_lfsr
	.import whiteout_whole_screen
	.import colourin_whole_screen
	.import animate_sprite_sequence

	sidMuzakInit = $1000
	sidMuzakPlay = $1003

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
	.endif
	inc	$1		; I/O on
	;; I/O stuff.
	dec	$1
	cli
	jsr	copy_image2screen
	;; Now wait some time before the displayloop begins.
	lda	#$2
	jsr	wait_for_framecounter
	;; 	jsr	whiteout_whole_screen
	jsr	whiteout_via_lfsr
displayloop:
	lda	animate_sprite_sequence
	eor	#1
	sta	animate_sprite_sequence
	jsr	uncompress_next_image
;;; 	jsr	copy_image2screen ; TODO: Or something else...
	jsr	colourin_whole_screen
	lda	#$2
	jsr	wait_for_framecounter
	jsr	whiteout_whole_screen
	cmp	#0
	bne	displayloop
	;;
	lda	#$34		; End after n*256 frames.
	cmp	framecounter+1
	jne	mainloop
	rts


setupirq:
	lda	#<irqroutine
	sta	$FFFE
	lda	#>irqroutine
	sta	$FFFF
	lda	#$7f
	sta	$dc0d	;disable timer interrupts which can be generated by the two CIA chips
	sta	$dd0d	;the kernal uses such an interrupt to flash the cursor and scan the keyboard,
			;so we better stop it.
	lda	$dc0d	;by reading this two registers we negate any pending CIA irqs.
	lda	$dd0d	;if we don't do this, a pending CIA irq might occur after we finish setting up our irq.
			;we don't want that to happen.
	;; https://www.c64-wiki.com/wiki/Raster_interrupt
	lda	#$7f
	and	$d011		; Set MSB of raster to zero
	sta	$d011
	lda	#50-1		; Top of screen minus one rasterline
	sta	$d012
	;; http://unusedino.de/ec64/technical/project64/mapping_c64.html
	; 53274         $D01A          IRQMASK
	; IRQ Mask Register
	; 
	; Bit 0:  Enable Raster Compare IRQ (1=interrupt enabled)
	; Bit 1:  Enable IRQ to occure when sprite collides with display of
	;   normal
	;         graphics data (1=interrupt enabled)
	; Bit 2:  Enable IRQ to occur when two sprites collide (1=interrupt
	;   enabled)
	; Bit 3:  Enable light pen to trigger an IRQ (1=interrupt enabled)
	; Bits 4-7:  Not used
	lda	#%00000001
	sta	$d01a
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
