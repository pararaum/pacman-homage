
	.export	wait_for_framecounter
	.export	framecounter

	.bss
framecounter:	.res	2	; Reserve a word

	.code
;;; Wait until the framecounter reaches a value, clear to zero afterwards. Only high byte!
;;; Input:
;;;	A: High value to wait for
;;; Modifies: A
;;; Returns: A=0
wait_for_framecounter:
@l1:	cmp	framecounter+1
	bne	@l1
	lda	#0
	sta	framecounter+1
	rts

