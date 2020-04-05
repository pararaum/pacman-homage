
	.segment "IMAGE"
	.export	sprites
	.export	imagecolours
	.export	spritepointer

sprites:
	.res	64*16		; 1024
screen0:
	.res	1024
screen1:
	.res	1024
imagecolours:
	;; Screen Ram, positioned in the file after the 8000 bytes of the bitmap.
	.incbin	"toru_iwatani.bw.c64",8000,1000
	.res	16		; Empty space
spritepointer:
	.res	8
	;; Here comes the bitmap, the first 8000 bytes of the file.
	.incbin	"toru_iwatani.bw.c64",0,8000

