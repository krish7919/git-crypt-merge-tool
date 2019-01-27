prefix = /usr/local
exec_prefix = $(prefix)
bindir = $(exec_prefix)/bin

all:
	@echo "Nothing to build. make install to install, or make uninstall to uninstall"
.PHONY: all

install:
	install -m 755 git-crypt-merge.sh $(DESTDIR)$(bindir)/git-crypt-merge
.PHONY: install

uninstall:
	rm -f $(DESTDIR)$(bindir)/git-crypt-merge
.PHONY: uninstall
