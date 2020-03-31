
;;; ca65 -t c64 -I ../includeCC65/ wotahero.s && cl65  wotahero.o wotahero.cfg

	.include	"vicmacros.i"
	.include	"pseudo16.inc"


	.segment "LOADADDR"
	.export __LOADADDR__
__LOADADDR__:	.word $0400


	.segment "STARTUP"
	cld
	cld
	sei
	ldx	#$ff
	txs
	jsr	_main
	lda	#$37
	sta	$1
	jsr	*
	jmp	64738
	

	.rodata
	.byte	"Read Only Data"


	.segment "IMAGE"
	.asciiz	"image"


	.code
_main:
	lda	#$00
	sta	$d020
	jsr	init
	P_loadi $2,$e000
	rts

init:
	SwitchVICBank 3
	SetHiresBitmapMode
	SetBitmapAddress $2000
	SetScreenMemory $1c00
	lda	#$30
	sta	$1
	rts

	.data
	.asciiz	"Data Segment"
