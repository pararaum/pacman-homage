	.export reset_framecounter
	.export	wait_for_framecounter
	.export	framecounter
	.export	wait_single_frame

	.bss
framecounter:	.res	2	; Reserve a word

	.code
;;; Reset the framecounter to zero.
;;; Input: -
;;; Modifies: A
;;; Output: A=0
reset_framecounter:
	lda	#0
	sta	framecounter
	sta	framecounter+1
	rts

;;; Wait until the framecounter reaches a value, clear to zero afterwards. Only high byte!
;;; Input:
;;;	A: High value to wait for
;;; Modifies: A
;;; Returns: A=0
wait_for_framecounter:
@l1:
	.ifdef	DEBUG
	pha
	sei
	lda	$1
	pha
	lda	#$35
	sta	$1
	inc	$d020
	pla
	sta	$1
	cli
	pla
	.endif
	cmp	framecounter+1
	bne	@l1
	lda	#0
	sta	framecounter+1
	rts

;;; Wait to the end of the current frame (waiting until the lo byte of the frame counter changes).
;;; Input:
;;; Output: LO-byte of current frame count
;;; Changes: A
wait_single_frame:
	lda	framecounter
	@l:
	cmp	framecounter
	beq	@l
	rts
