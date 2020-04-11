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
	.import	unpucrunch
	.import imagecounter

	.export uncompress_next_image

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
image_cr_story10:
	.incbin	"story.1a8298.pucr",2
image_cr_story11:
	.incbin	"story.1a83e0.pucr",2
image_cr_story12:
	.incbin	"story.278008.pucr",2
image_cr_story13:
	.incbin	"story.278150.pucr",2
image_cr_story14:
	.incbin	"story.278298.pucr",2
image_cr_story15:
	.incbin	"story.2783e0.pucr",2
image_cr_story16:
	.incbin	"story.348008.pucr",2
image_cr_story17:
	.incbin	"story.348150.pucr",2
image_cr_story18:
	.incbin	"story.348298.pucr",2
image_cr_story19:
	.incbin	"toru_iwatani.bw.pucr",2
	
	.define	ImageTable	image_cr_story00, image_cr_story01, image_cr_story02, image_cr_story03, image_cr_story04, image_cr_story05, image_cr_story06, image_cr_story07, image_cr_story08, image_cr_story09, image_cr_story10, image_cr_story11, image_cr_story12, image_cr_story13, image_cr_story14, image_cr_story15, image_cr_story16, image_cr_story17, image_cr_story18, image_cr_story19
imageTableLO:	.lobytes	ImageTable
imageTableHI:	.hibytes	ImageTable
no_of_story_images:
	.byte	no_of_story_images-imageTableHI

	.code
;;; Uncompress the next image to $DC00-$FF3F. Cycles the images after the last image was found.
;;; Modifies: A/X/Y
;;; Output: A=0 if images were recycled.
uncompress_next_image:
	ldx	imagecounter
	ldy	imageTableLO,x
	lda	imageTableHI,x
	tax
	jsr	unpucrunch
	lda	imagecounter
	clc
	adc	#1
	cmp	no_of_story_images
	bne	@norestart
	lda	#0
@norestart:
	sta	imagecounter
	rts
