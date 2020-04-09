;;; Global zeropage data. Remember that all functions are allowed to use them!

	.exportzp	tmpptr
	.exportzp	srcptr
	.exportzp	dstptr
	.exportzp	counter16
	.exportzp	tmp16

	.zeropage
	;; Pointers for many copy operations.
srcptr:	.res	2
dstptr:	.res	2
srcend:	.res	2
tmpptr:	.res	2
	;; A general counter.
counter16:	.res	2
tmp16:	.res	2
