
	.include	"pseudo16.inc"

	.importzp	counter16

	.bss
spriteregshadow:
	.res	2*8		; Sprite positions
	.res	1		; Sprite MSBs
	

	.data
scrsprposx:
	.word	0,48*1,48*2,48*3,48*4,48*5,48*6

	.code
scroller_init:
	P_loadi	counter16,0
	rts
