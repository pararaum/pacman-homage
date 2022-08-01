
	.export	scroller_init
	.export	scroller_advance
	.export	scroller_copypos2vic

	.include	"pseudo16.inc"
	.include	"memoryconfig.i"
	.macpack	generic
	.macpack	cbm

	.import	framecounter
	.import	spritescroller
	.import spritemsbtab

	scroller_centerline = $fb

	.data
scroller_text:
	scrcode	"vINTAGE cOMPUTING cARINTHIA PRESENTS 'wOT a hERO!' (BASED ON AN OLD IDEA FOUND IN THE ATTIC OF tHE 7TH dIVISION). "
	scrcode "iT IS AN HOMAGE TO THE GAME pAC-mAN. tHIS GAME WAS DESIGNED IN 1980 BY tORU iWATANI! tHANK YOU FOR COUNTLESS HOURS OF FUN! "
	.BYTE	"   "
	scrcode "gREETINGS GO TO: "
        scrcode "aBYSS cONNECTION, aTLANTIS, "
        scrcode "bLAZON, cLASSIC vIDEOGAMES rADIO, "
        scrcode "cOMMODORE tREFFEN gRAZ, cOSMOS dESIGNS, "
        scrcode "cOYHOT, dELYSID, dIGITAL tALK tEAM, doc.k, dOCTORcpc, "
        scrcode "eXCESS, fAIRLIGHT, gLOEGG, "
        scrcode "hAREKIET, hOKUTO fORCE, "
        scrcode "jASMIN68K, jOE, jOK, nODEPOND, pADUA, "
        scrcode "pHIWA, pINKAMENA, rABENAUGE, rEBELS, sENSENSTAHL, sISSIM, "
        scrcode "tHE sOLUTION, tRIAD, wIZBALL6502, xxx"
	.BYTE	".               "
	.byte	$ff

	.bss
sinusidx:	.res	1
	
	.data
sprite_y_pos:	.byte	250-21*2
real_sprite_xpos:
	.word	1+48*0, 1+48*1, 1+48*2, 1+48*3, 1+48*4, 1+48*5, 1+48*6, 1+48*7
font:
	.incbin	"zdemo.pbm",10
;   (let (value)
;   (dotimes (number 64 value)
;     (setq value
;        (concat value
;                (format "$%x, " (logand #xff ( + 256 (truncate (* 14 (sin (* 2 pi (/ number 63.0))))))))
;                )
;        )))
	;; Grrr, no signed constants in ca65!?
sinus:	.byte $0, $1, $2, $4, $5, $6, $7, $8, $a, $a, $b, $c, $d, $d, $d, $d, $d, $d, $d, $d, $c, $c, $b, $a, $9, $8, $7, $6, $4, $3, $2, $0, $0, $fe, $fd, $fc, $fa, $f9, $f8, $f7, $f6, $f5, $f4, $f4, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f3, $f4, $f5, $f6, $f6, $f8, $f9, $fa, $fb, $fc, $fe, $ff, $0

	.zeropage
tmpxpos:	.res	2
scrtmp16:	.res	2
scrsrcptr:	.res	2
scrdstptr:	.res	2
scrcounter16:	.res	2

	.code
scroller_init:
	lda	#0
	sta	sinusidx
	rts

	.code
scroller_advance:
	ldx	#0
@loop:
	sec
	lda	real_sprite_xpos,x
	sbc	#1
	sta	real_sprite_xpos,x
	bcs	@nounderflow
	dec	real_sprite_xpos+1,x
	bpl	@nounderflow
	txa			; Spritenumber*2 into A
	lsr			; divide by two so that spritenumber is in A
	stx	@tmp
	jsr	scroller_new_chars
	ldx	@tmp
	lda	#<(1+48*8)	; Move to the end.
	sta	real_sprite_xpos,x
	lda	#>(1+48*8)
	sta	real_sprite_xpos+1,x
@nounderflow:
	inx
	inx
	cpx	#8*2
	bne	@loop
	rts
@tmp:	.byte	0

	.code
;;; Get the next character of the scroller text.
scroller_next_char:
@ptr:	lda	scroller_text
	P_inc	@ptr+1
	cmp	#$ff
	bne	@out
	P_loadi	@ptr+1,scroller_text
	lda	#' '
@out:
	rts

	.code
;;; Input: A=sprite number
;;; Modifies: A/Y/X
scroller_new_chars:
	pha			; Store the sprite number on the stack.
	P_loadi	scrdstptr,spritescroller ; Here is the area for the sprite scroller (sprite buffer).
	pla			; Retrieve the sprite number from the stack.
	sta	scrcounter16	; Store in a temporary variable.
	lda	#0
	sta	scrcounter16+1
	.repeat	6		; count16 *= 64
	asl	scrcounter16
	rol	scrcounter16+1
	.endrepeat
	P_add	scrcounter16,scrdstptr ; Add to destination pointer.
	;;  Now we need the next character
	jsr	scroller_next_char
	jsr	@copychar
	P_inc	scrdstptr	; One byte to the right in the destination.
	jsr	scroller_next_char
	jsr	@copychar
	P_inc	scrdstptr	; One byte to the right in the destination.
	jsr	scroller_next_char
	jsr	@copychar
	rts
@copychar:
	sta	scrcounter16
	lda	#0
	sta	scrcounter16+1
	.repeat	3		; character * 8 is offset in font (screen codes)
	asl	scrcounter16
	rol	scrcounter16+1
	.endrepeat
	P_loadi	scrsrcptr,font
	P_add	scrcounter16,scrsrcptr
	ldy	#0
	ldx	#0
	@copy:
	lda	(scrsrcptr,x)
	sta	(scrdstptr),y
	P_inc	scrsrcptr
	iny
	iny
	iny
	cpy	#8*3
	bne	@copy
	rts

scroller_copypos2vic:
	inc	sinusidx	; Get the sinus.
	lda	sinusidx
	and	#$3f
	tax
	lda	sinus,x
	add	#scroller_centerline
	sta	sprite_y_pos
	ldx	#0
	stx	$d010		; Clear all MSBs!
@l:	lda	sprite_y_pos
	sta	$d000+1,x
	lda	real_sprite_xpos,x
	sta	tmpxpos
	lda	real_sprite_xpos+1,x
	sta	tmpxpos+1
	P_loadi	scrtmp16,24
	P_sub	scrtmp16,tmpxpos	; Now subtract left border size from position.
	bpl	@sp		; Is it still positive?
	;;  Nope. For PAL, sprite positions (in our coordinate system) between [-24;0) have to lie between [$e0;$f7). So subtract seven.
	lda	tmpxpos
	sub	#8
	sta	tmpxpos
	;; HI byte is non-zero so that is ok.
@sp:
	lda	tmpxpos
	sta	$d000,x
	lda	tmpxpos+1
	beq	@nosetmsb
	txa
	lsr
	tay
	lda	spritemsbtab,y
	ora	$d010
	sta	$d010
@nosetmsb:
	inx
	inx
	cpx	#16
	bne	@l
	;; Copy colours.
	lda	#12
	ldx	#7
@l2:
	;; 	txa
	;; 	clc
	;; 	adc	#1
	sta	$d027,x
	dex
	bpl	@l2
	rts

	;; https://sourceforge.net/p/cc65/mailman/message/32234634/
	.feature force_range
	.data
	.byte	-1
