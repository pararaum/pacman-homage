#! /usr/bin/make
##echo $(shell pgrep -f "x64.*-remotemonitor" || x64 -remotemonitor )&

AFLAGS=-I includeCC65
OBJS = wotahero.o muzak.o unpucrunch.o

all:	wotahero putest images

%.o:	%.s
	ca65 $(AFLAGS) $+

wotahero:	$(OBJS)
	cl65 $(CFLAGS) -v -m wotahero.map -Ln wotahero.vicelabel -C wotahero.cfg $+

putest:	unpucrunch.o putest.o
	cl65 -v -t c64 -o $@ $+

%.pucr:	%.c64
	./pucrunch/pucrunch -c0 -d -l 56344 $+ $@

images:	story.00.pucr

clean:
	rm -f wotahero wotahero.map wotahero.vicelabel putest *.o *.pucr

run:	wotahero
	@echo  '\nbank ram \nl "wotahero" 0 \ng 0400\n' | nc -N localhost 6510

debug:
	@(nc localhost 6510; exit 0)

.PHONY:	wotahero clean debug run
