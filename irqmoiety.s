
	.export	irqroutine

	.include	"pseudo16.inc"
	.import ciatimer_retrieve
	.import ciatimer_store
	.import framecounter
	.import animate_sprite
	.import move_sprite0_horizontally

	.zeropage
irqXsave:	.byte 0
irqYsave:	.byte 0

	.code
irqroutine:
	pha
	stx	irqXsave
	sty	irqYsave
	lda	#$37		; Turn on I/O
	sta	$1
	jsr	move_sprite0_horizontally
	jsr	ciatimer_store
	jsr	$1003
	jsr	ciatimer_retrieve
	P_inc	framecounter	; Advance frame counter.
	;; Acknowledge IRQ.
	asl	$d019
	lda	#$34		; Turn to RAM only
	sta	$1
	;; Do all IRQ stuff here that needs the memory below I/O.
	jsr	animate_sprite
	ldy	irqYsave
	ldx	irqXsave
	pla
	rti

