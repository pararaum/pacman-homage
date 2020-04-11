
	.export	irqroutine

	.include	"pseudo16.inc"
	.include	"memoryconfig.i"
	.import ciatimer_retrieve
	.import ciatimer_store
	.import framecounter
	.import animate_sprite
	.import move_sprite0_horizontally
	.import	scroller_advance
	.import	spritescroller
	.import spritepointer
	.import	scroller_copypos2vic

	.zeropage
irqXsave:	.byte 0
irqYsave:	.byte 0

	.data
	;; Interrupt table. It is assumed that there are exactly four entries!
	.define	IrqsTable	run_action-1,play_muzak-1,copy_scroller_shadow-1,irq_advance_scroller-1
irqTableLO:	.lobytes	IrqsTable
irqTableHI:	.hibytes	IrqsTable
irqTable_pos:	.byte	17,105,171,248
irq_dispatch_idx:		; Index to the next interrupt routine.
	.byte	0

	.code
run_action:
	jsr	animate_sprite
	memoryconfig_io
	jsr	move_sprite0_horizontally
	lda	#7
	sta	$d027
	rts

play_muzak:
	P_inc	framecounter	; Advance frame counter.
	memoryconfig_io
	jsr	ciatimer_store
	jsr	$1003
	jsr	ciatimer_retrieve
	rts


	scrollerspritebank = (spritescroller-$c000)/64
copy_scroller_shadow:
	ldx	spritescroller
	ldx	#<scrollerspritebank ; Why '<'?
	stx	spritepointer
	inx
	stx	spritepointer+1
	inx
	stx	spritepointer+2
	inx
	stx	spritepointer+3
	inx
	stx	spritepointer+4
	inx
	stx	spritepointer+5
	inx
	stx	spritepointer+6
	inx
	stx	spritepointer+7
	memoryconfig_io
	;; 	jsr	move_sprite0_horizontally
	jsr	scroller_copypos2vic
	rts

irq_advance_scroller:
	memoryconfig_io
	lda	$d011
	and	#%11110111
	sta	$d011
	memoryconfig_ram
	jsr	scroller_advance
	memoryconfig_io
	lda	$d011
	ora	#%00001000
	sta	$d011
	memoryconfig_ram
	rts

	.code
irqroutine:
	pha
	stx	irqXsave
	sty	irqYsave
	jsr	dispatch
	jsr	irq_increment
	;; Now some I/O stuff.
	memoryconfig_io
	asl	$d019		; Acknowledge IRQ.
	ldx	irq_dispatch_idx; Which is the next interrupt routine?
	lda	irqTable_pos,x	; Get the next raster-line position.
	sta	$d012		; Set IRQ @ next position.
	lda	$d011
	and	#%01111111
	sta	$d011
	memoryconfig_ram
	ldy	irqYsave
	ldx	irqXsave
	pla
	rti

irq_increment:
	inc	irq_dispatch_idx
	lda	irq_dispatch_idx
	and	#3
	sta	irq_dispatch_idx
	rts

dispatch:
	ldx	irq_dispatch_idx
	;; Dispatch trick for jmp (...,x):
	;; http://6502.org/tutorials/6502opcodes.html#RTS
	lda	irqTableHI,x
	pha
	lda	irqTableLO,x
	pha
	rts			; JMP (…,x)

