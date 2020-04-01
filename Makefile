#! /usr/bin/make
##echo $(shell pgrep -f "x64.*-remotemonitor" || x64 -remotemonitor )&

AFLAGS=-I includeCC65
OBJS = wotahero.o muzak.o

all:	wotahero

%.o:	%.s
	ca65 $(AFLAGS) $+

wotahero:	$(OBJS)
	cl65 $(CFLAGS) -v -C wotahero.cfg $+

clean:
	rm -f wotahero *.o

run:	wotahero
	@echo  '\nbank ram \nl "wotahero" 0 \ng 0400\n' | nc -N localhost 6510

debug:
	@(nc localhost 6510; exit 0)

.PHONY:	wotahero clean debug run
