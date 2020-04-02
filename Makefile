#! /usr/bin/make
##echo $(shell pgrep -f "x64.*-remotemonitor" || x64 -remotemonitor )&

AFLAGS=-I includeCC65
OBJS = wotahero.o muzak.o unpucrunch.o

all:	wotahero putest

%.o:	%.s
	ca65 $(AFLAGS) $+

wotahero:	$(OBJS)
	cl65 $(CFLAGS) -v -C wotahero.cfg $+

putest:	unpucrunch.o putest.o
	cl65 -v -t c64 -o $@ $+

clean:
	rm -f wotahero putest *.o

run:	wotahero
	@echo  '\nbank ram \nl "wotahero" 0 \ng 0400\n' | nc -N localhost 6510

debug:
	@(nc localhost 6510; exit 0)

.PHONY:	wotahero clean debug run
