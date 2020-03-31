
;;; ca65 -t c64 -I ../includeCC65/ wotahero.s && cl65  wotahero.o wotahero.cfg

	.include	"vicmacros.i"
	.include	"pseudo16.inc"

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
	lda	#$37
	sta	$1
	jsr	*
	jmp	64738
	

	.rodata
	.byte	"Read Only Data (SID)"


	.segment "IMAGE"
	.asciiz	"image"


	.data
image_iwatani:
	.incbin	"toru_iwatani.bw.c64"

	.code
_main:
	lda	#$0b
	sta	$d020
	jsr	init
	jsr	cpyimage
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
	lda	#$30
	sta	$1
	rts

	.data
	.asciiz	"Data Segment"
