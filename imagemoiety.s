;;; Image data and code of all the images which should be shown.
;;; The images are currently in the standard C64 Hires format
;	consisting of Bitmap + Screen Ram (Interpaint?), see
;	[https://codebase64.org/doku.php?id=base:c64_grafix_files_specs_list_v0.03]. As
;	we store the graphics at $E000 and the colour screen at $DC00
;	there is some copying involved to display the picture.


	.include	"pseudo16.inc"
	.importzp	srcptr
	.importzp	dstptr
	.importzp	counter16

	.export	imageTableLO, imageTableHI
	.export shuffle_image_memory
	.export no_of_story_images

	.data
image_cr_story00:
	.incbin	"story.008008.pucr",2
image_cr_story01:
	.incbin	"story.008150.pucr",2
image_cr_story02:
	.incbin	"story.008298.pucr",2
image_cr_story03:
	.incbin	"story.0083e0.pucr",2
image_cr_story04:
	.incbin	"story.0d8008.pucr",2
image_cr_story05:
	.incbin	"story.0d8150.pucr",2
image_cr_story06:
	.incbin	"story.0d8298.pucr",2
image_cr_story07:
	.incbin	"story.0d83e0.pucr",2
image_cr_story08:
	.incbin	"story.1a8008.pucr",2
image_cr_story09:
	.incbin	"story.1a8150.pucr",2

	.define	ImageTable	image_cr_story00, image_cr_story01, image_cr_story02, image_cr_story03, image_cr_story04, image_cr_story05, image_cr_story06, image_cr_story07, image_cr_story08, image_cr_story09
imageTableLO:	.lobytes	ImageTable
imageTableHI:	.hibytes	ImageTable
no_of_story_images:
	.byte	no_of_story_images-imageTableHI

	.code
;;; Copy image data in memory. Uses the area at $d000 as a
;	temporary. So we copy the screen ram to $d000, the bitmap to
;	$e000, and the save screen from $d000 to $dc00. This can be
;	done better.
;;; Input:
;;; Changes: A/Y, srcptr, dstptr,counter16
;;; Output:
shuffle_image_memory:
	ldy	#0
	P_loadi	srcptr,$d400+8000+1000
	P_loadi	dstptr,$d000+1000
	P_loadi counter16,1000+1
imageloop2:
	lda	(srcptr),y
	sta	(dstptr),y
	P_dec	srcptr
	P_dec	dstptr
	P_dec	counter16
	P_branchNZ counter16,imageloop2
	;; 
	P_loadi	srcptr,$d400+8000
	P_loadi	dstptr,$e000+8000
	P_loadi counter16,8000+1
imageloop1:
	lda	(srcptr),y
	sta	(dstptr),y
	P_dec	srcptr
	P_dec	dstptr
	P_dec	counter16
	P_branchNZ counter16,imageloop1
	;;
	P_loadi	srcptr,$d000+1000
	P_loadi	dstptr,$dc00+1000
	P_loadi counter16,1000+1
imageloop3:
	lda	(srcptr),y
	sta	(dstptr),y
	P_dec	srcptr
	P_dec	dstptr
	P_dec	counter16
	P_branchNZ counter16,imageloop3
	rts
