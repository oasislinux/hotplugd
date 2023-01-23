.POSIX:

PREFIX?=/usr/local
BINDIR?=$(PREFIX)/bin
LIBEXECDIR?=$(PREFIX)/libexec

-include config.mk

CFLAGS+=-Wall -Wpedantic -D 'PREFIX="$(PREFIX)"'

.PHONY: all
all: hotplugd ata_id trigger

.PHONY: install
install: hotplugd ata_id trigger
	mkdir -p $(DESTDIR)$(BINDIR) $(DESTDIR)$(LIBEXECDIR)/hotplugd
	cp hotplugd $(DESTDIR)$(BINDIR)
	cp ata_id trigger $(DESTDIR)$(LIBEXECDIR)/hotplugd

.PHONY: clean
clean:
	rm -f hotplugd trigger
