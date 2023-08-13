SHELL=bash
ifndef CSC
CSC=$(shell type -p csc || type -p chicken-csc || echo 'echo "csc does not exist; "')
endif

BROPTS=

INSTALL_PROGRAMS=tftspellscsv
OTHER_PROGRAMS=
PROGRAMS=$(INSTALL_PROGRAMS:%=build/%$(EXE)) $(OTHER_PROGRAMS:%=build/%$(EXE))

all: build $(PROGRAMS)

clean:
	-rm -v $(PROGRAMS)

BINDIR=$(HOME)/local/bin
install: $(foreach e,$(PROGRAMS:%=%$(EXE)),$(BINDIR)/$(notdir $(e)))


build:
	mkdir build

build/% : %.scm
	$(CSC) $(CSCFLAGS) -o $@ $^

$(BINDIR)/% : build/%
	[ -d $(BINDIR) ] || (mkdir -p $(BINDIR) && echo built $(BINDIR))
	cp $< $@

