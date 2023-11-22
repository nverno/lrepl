.make-prerequisites:
	@touch $@

linenoise: .make-prerequisites
	@printf '%b %b\n' "\e[32;1mMAKE\e[0m" "\e[37;1m$@\e[0m"
	cd linenoise && $(MAKE)

.PHONY: linenoise

distclean:
	-(cd linenoise && $(MAKE) clean) >/dev/null || true
