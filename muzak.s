
	.export	sidmusic

	.segment "MUZAK"
	;; Must be at the Beginning! And make sure that the config is right!
sidmusic:
	.incbin	"Lovely_Face.sid", $7c+2
	.byte	"Read Only Data (SID)"
