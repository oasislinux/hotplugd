.POSIX:

PREFIX?=/usr/local
BINDIR?=$(PREFIX)/bin
LIBEXECDIR?=$(PREFIX)/libexec

-include config.mk

CFLAGS+=-Wall -Wpedantic -D 'PREFIX="$(PREFIX)"'

.PHONY: all
all: devd devd-trigger

.PHONY: install
install: devd devd-trigger
	mkdir -p $(DESTDIR)$(BINDIR) $(DESTDIR)$(LIBEXECDIR)
	cp devd $(DESTDIR)$(BINDIR)
	cp devd-trigger $(DESTDIR)$(LIBEXECDIR)

.PHONY: clean
clean:
	rm -f devd devd-trigger
