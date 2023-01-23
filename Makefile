.POSIX:

PREFIX?=/usr/local
BINDIR?=$(PREFIX)/bin
LIBEXECDIR?=$(PREFIX)/libexec

-include config.mk

CFLAGS+=-Wall -Wpedantic -D 'PREFIX="$(PREFIX)"'

.PHONY: all
all: hotplugd trigger

.PHONY: install
install: hotplugd trigger
	mkdir -p $(DESTDIR)$(BINDIR) $(DESTDIR)$(LIBEXECDIR)/hotplugd
	cp hotplugd $(DESTDIR)$(BINDIR)
	cp trigger $(DESTDIR)$(LIBEXECDIR)/hotplugd

.PHONY: clean
clean:
	rm -f hotplugd trigger
