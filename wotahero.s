
;;; ca65 -t c64 -I ../includeCC65/ wotahero.s && cl65  wotahero.o wotahero.cfg

	.include	"vicmacros.i"
	.include	"pseudo16.inc"

	sidMuzakInit = $1000
	sidMuzakPlay = $1003

	.import	sidmusic

	.segment "LOADADDR"
	.export __LOADADDR__
__LOADADDR__:	.word $0400

	.zeropage
srcptr:	.word	0
dstptr:	.word	0
srcend:	.word	0
tmpptr:	.word	0

	.segment "STARTUP"
	cld
	cld
	sei
	ldx	#$ff
	txs
	jsr	_main
	jsr	*
	lda	#$37
	sta	$1
	jmp	64738
	.BYTE	"THE 7TH DIVISION"
	.byte $14,$08,$05,$20,$37,$14,$08,$20,$04,$09,$16,$09,$13,$09,$0f,$0e

	.segment "IMAGE"
	.asciiz	"image"


	.data
image_iwatani:
	.incbin	"toru_iwatani.bw.c64"

	.code
_main:
	lda	#$0b
	sta	$d020
	jsr	setupirq
	jsr	init
	jsr	cpyimage
	cli
mainloop:
	sei
	lda	$1		; Store old memory configuration
	pha
	lda	#$35		; I/O on
	sta	$1
	lda	$dc06
	sta	$d020
	pla			; Resotre old configuration.
	sta	$1
	cli
	jsr	mainloop
	rts

irqroutine:
	lda	#$37		; Turn on I/O
	sta	$1
	;; 	inc	$d020
	jsr	$1003
	asl	$d019
	lda	#$30		; Turn to RAM only
	sta	$1
	rti

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

cpyimage:
	P_loadi srcend,image_iwatani+8000
	P_loadi srcptr,image_iwatani
	P_loadi dstptr,$e000
	ldy	#0
l1:	lda	(srcptr),y
	sta	(dstptr),y
;;; 	P_storeb srcptr,dstptr
	P_transfer srcptr,tmpptr
	P_inc	srcptr
	P_inc	dstptr
	P_sub	srcend,tmpptr
	P_branchNZ tmpptr,l1
	P_loadi srcend,image_iwatani+8000+1000
	P_loadi srcptr,image_iwatani+8000
	P_loadi dstptr,$dc00
l2:	lda	(srcptr),y
	sta	(dstptr),y
	;; 	P_storeb srcptr,dstptr
	P_transfer srcptr,tmpptr
	P_inc	srcptr
	P_inc	dstptr
	P_sub	srcend,tmpptr
	P_branchNZ tmpptr,l2
	rts

init:
	SwitchVICBank 3
	SetHiresBitmapMode
	SetBitmapAddress $2000
	SetScreenMemory $1c00
	jsr	sidMuzakInit
	lda	#0
	sta	$dc0f
	lda	#$ff
	sta	$dc07
	sta	$dc06
	lda	#%01010011
	sta	$dc0f
	lda	#$30
	sta	$1
	rts

	.data
	.asciiz	"Data Segment"
