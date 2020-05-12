	.export	wavyinterlude
	.export wavymation_screenptr
	.export wavymation_chargenptr

	.include	"memoryconfig.i"
	.import screen4col
	.import imagebitmap
	wavymation_screenptr = screen4col
	wavymation_chargenptr = imagebitmap
	.import whiteout_whole_screen
	.import wavymation_generate_image
	.import wavymation_copy_font
	.import wavymation_animate_font
	.import fill_colourram
	.import wait_single_frame

	.data
pacman:
        .incbin "image.40x25.pac-man.pbm",9
ghost:
        .incbin "image.40x25.ghost.pbm",9

	.bss
wavecounter:
	.res	1		; One byte to count the waves...

	.code
;;; Setup the screen for wavy image display
;;; Modifies: A
setup_vic:
	sei
	memoryconfig_io
	lda	#%00011011     ; Display on, no bitmap
	sta	$d011
	lda	#%00001000	; Single colour mode.
	sta	$d016
	lda	#<(((screen4col-$c000)/64)|((imagebitmap-$c000)/1024))
	sta	$d018
	lda	#$0f
	jsr	fill_colourram
	memoryconfig_ram
	cli
	rts

wavyinterlude:
	sei
	memoryconfig_io
	lda	$d011		; Save control register
	pha
	lda	$d016
	pha
	lda	$d018
	pha
	memoryconfig_ram
	cli		       ; Allow for an interrupt.
	;; Clear the screen with a nice effect.
	jsr	whiteout_whole_screen
	jsr	wavymation_copy_font
	jsr	setup_vic
	;; Setup the screen pointer and the wavy effect.
	lda	#<pacman
	ldx	#>pacman
	jsr     wavymation_generate_image
	lda	#5*60/3
	sta	wavecounter
@loop:
	jsr	wait_single_frame
	jsr	wait_single_frame
	jsr	wait_single_frame
	jsr	wavymation_animate_font
	dec	wavecounter
	bpl	@loop
	sei
	memoryconfig_io
	pla
	sta	$d018
	pla
	sta	$d016
	pla
	sta	$d011
	memoryconfig_ram
	cli		       ; Allow for an interrupt.
	rts
