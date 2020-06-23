.POSIX:

PREFIX?=/usr/local
BINDIR?=$(PREFIX)/bin
LIBEXECDIR?=$(PREFIX)/libexec

-include config.mk

CFLAGS+=-Wall -Wpedantic -D 'PREFIX="$(PREFIX)"'

.PHONY: all
all: hotplugd hotplugd-trigger

.PHONY: install
install: hotplugd hotplugd-trigger
	mkdir -p $(DESTDIR)$(BINDIR) $(DESTDIR)$(LIBEXECDIR)
	cp hotplugd $(DESTDIR)$(BINDIR)
	cp hotplugd-trigger $(DESTDIR)$(LIBEXECDIR)

.PHONY: clean
clean:
	rm -f hotplugd hotplugd-trigger
