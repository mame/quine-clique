# Build the interpreters for qc.bf / qc.bef / qc.ws / qc.piet.gif / qc.unl into bin/

CC ?= cc
CFLAGS ?= -O2
BINS = bin/bf bin/bef bin/ws bin/piet bin/unl

all: $(BINS)

bin:
	mkdir -p bin

bin/%: %.c | bin
	$(CC) $(CFLAGS) -o $@ $< $(LDLIBS_$*)

LDLIBS_ws = -lgmp
LDLIBS_piet = -lgif

clean:
	rm -rf bin

.PHONY: all clean
