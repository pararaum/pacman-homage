#! /usr/bin/make
##echo $(shell pgrep -f "x64.*-remotemonitor" || x64 -remotemonitor )&

AFLAGS = -DNDEBUG
AINC = -I includeCC65
OBJS = wotahero.o muzak.o unpucrunch.o startup.o imagemoiety.o
TMPFILE := $(shell mktemp)

all:	images wotahero test1.pucrunch putest

%.o:	%.s
	ca65 $(AINC) $(AFLAGS) $+

wotahero:	$(OBJS)
	cl65 $(CFLAGS) -v -m wotahero.map -Ln wotahero.vicelabel -C wotahero.cfg $+

test1.pucrunch:
	echo -n "AAAAABRACADABRABRAAAAA" | ./pucrunch/pucrunch -d -l 0x400 > $@

putest:	unpucrunch.o putest.o
	cl65 -v -t c64 -o $@ $+

# (format "%04X" 54272)"D400"
%.pucr:	%.c64
	./swap-image $+ $(TMPFILE)
	./pucrunch/pucrunch -c0 -d -l 0xdc00 $(TMPFILE) $@

images:	story.00.pucr toru_iwatani.bw.pucr story.008008.pucr story.008150.pucr story.008298.pucr story.0083e0.pucr story.0d8008.pucr story.0d8150.pucr story.0d8298.pucr story.0d83e0.pucr story.1a8008.pucr story.1a8150.pucr


clean:
	rm -f wotahero wotahero.map wotahero.vicelabel putest *.o *.pucr

run:	wotahero
	@echo  '\nbank ram \nl "wotahero" 0 \ng 0400\n' | nc -N localhost 6510

debug:
	@(nc localhost 6510; exit 0)

crunch:
	./pucrunch/pucrunch -x '$$400' wotahero prg

.PHONY:	wotahero clean crunch debug run
