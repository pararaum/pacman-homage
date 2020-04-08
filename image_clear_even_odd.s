;;; Simple function to clear a hires screen linewise. First the even then the odd lines are cleared.
	.export	image_clear_set
	.export	image_clear_line

	.importzp	dstptr

	.bss
linepointer:	.res	2	; Pointer to the current line
linecounter:	.res	1	; Counts the number of lines to clear

	.data
image_clear_value:
	.byte	0

	.code
	
image_clear_set:
	sta	linepointer
	stx	linepointer+1
	lda	#200
	sta	linecounter
	rts

;;; Modifies: A/X
;;; Output: A=linecounter
image_clear_line:
	lda	linecounter	; Get number of lines to draw.
	beq	@out		; Zero? We are finished.
	lda	linepointer	; Copy pointer to line to work area.
	sta	@ptr+1
	lda	linepointer+1
	sta	@ptr+2
	ldx	#320/8-1	; One line has 40 Bytes.
@l1:	lda	image_clear_value
@ptr:
	sta	$ffff		; Self-modifying code!
	lda	#8		; For bitmap organisation, see https://www.atarimagazines.com/compute/issue43/208_1_Bitmap_Graphics_On_The_64.php.
	clc
	adc	@ptr+1		; Increment to next byte on same line.
	sta	@ptr+1
	bcc	@skip
	inc	@ptr+2
@skip:
	dex
	bpl	@l1
	dec	linecounter	; Decrement line counter.
	lda	linecounter	; Get current line number, again.
	and	#7		; On lines where linecounter has the lowest three bits set we need to add more.
	bne	@short
	lda	#<(39*8+1)
	clc
	adc	linepointer
	sta	linepointer
	lda	linepointer+1
	adc	#>(39*8+1)
	sta	linepointer+1
	jmp	@skip2
@short:
	lda	#1		; Add to line pointer.
	clc
	adc	linepointer
	sta	linepointer
	bcc	@skip2
	inc	linepointer+1
@skip2:
	lda	linecounter
@out:	rts
