
	.export	sidmusic

	.rodata
	;; Must be at the Beginning!
sidmusic:
	.incbin	"Lovely_Face.sid", $7c+2
	.byte	"Read Only Data (SID)"
