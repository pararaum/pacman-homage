#! /usr/bin/make
##echo $(shell pgrep -f "x64.*-remotemonitor" || x64 -remotemonitor )&

AFLAGS = -DNDEBUG
AINC = -I includeCC65
OBJS = wotahero.o muzak.o unpucrunch.o startup.o imagemoiety.o spritemoiety.o imageRAMmoiety.o tools.o bss.o ciatimer.o irqmoiety.o scrollermoiety.o image_clear_even_odd.o globalzeropage.o whiteout_spiral.o trigonometric.o animationfont.o wavymoiety.o interludemoiety.o
#TMPFILE := $(shell mktemp)

all:	images wotahero

%.o:	%.s
	ca65 $(AINC) $(AFLAGS) $+

wotahero:	$(OBJS)
	cl65 $(CFLAGS) -v -m wotahero.map -Ln wotahero.label -C wotahero.cfg $+

test1.pucrunch:
	echo -n "AAAAABRACADABRABRAAAAA" | ./pucrunch/pucrunch -d -l 0x400 > $@

putest:	test1.pucrunch unpucrunch.o putest.o
	cl65 -v -t c64 -o $@ $+

# (format "%04X" 54272)"D400"
%.pucr:	%.c64
	./swap-image $+ | ./pucrunch/pucrunch -c0 -d -l 0xdc00 > $@

images:	story.008008.pucr story.008150.pucr story.008298.pucr story.0083e0.pucr story.0d8008.pucr story.0d8150.pucr story.0d8298.pucr story.0d83e0.pucr story.1a8008.pucr story.1a8150.pucr story.1a8298.pucr story.1a83e0.pucr story.278008.pucr story.278150.pucr story.278298.pucr story.2783e0.pucr story.348008.pucr story.348150.pucr story.348298.pucr toru_iwatani.bw.pucr


clean:
	rm -f wotahero wotahero.prg wotahero.map wotahero.label putest *.o *.pucr

run:	wotahero
	@echo  '\nbank ram \nl "wotahero" 0 \ng 03FC\n' | nc -N localhost 6510

debug:
	@(nc localhost 6510; exit 0)

crunch:	wotahero
	./pucrunch/pucrunch -x '$$3fc' wotahero wotahero.prg

.PHONY:	clean crunch debug run
