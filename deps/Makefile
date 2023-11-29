LUA_DEBUG    ?= no
LUA_COVERAGE ?= no

MSG = @printf "%b %b\n" "\e[32;1mMAKE\e[0m" "\e[37;1m$(1)\e[0m"

all: lua linenoise

.make-prerequisites:
	@touch $@

# Clean everything when CFLAGS is different
ifneq ($(shell sh -c '[ -f .make-cflags ] && cat .make-cflags || echo none'), $(CFLAGS))
.make-cflags: distclean
	-(echo "$(CFLAGS)" > .make-cflags)
.make-prerequisites: .make-cflags
endif

# Clean everything when LDFLAGS is different
ifneq ($(shell sh -c '[ -f .make-ldflags ] && cat .make-ldflags || echo none'), $(LDFLAGS))
.make-ldflags: distclean
	-(echo "$(LDFLAGS)" > .make-ldflags)
.make-prerequisites: .make-ldflags
endif

linenoise: .make-prerequisites
	$(call MSG,"linenoise")
	cd linenoise && $(MAKE)

.PHONY: linenoise

LUA_CFLAGS    += -Wall -DLUA_USE_READLINE -DLUA_ANSI -DLUA_USE_LINUX $(CFLAGS)
LUA_LDFLAGS   += $(LDFLAGS)
ifeq ($(LUA_DEBUG),yes)
  LUA_CFLAGS  += -O0 -g -DLUA_USE_APICHECK
else
  LUA_CFLAGS  += -O2 
endif
ifeq ($(LUA_COVERAGE),yes)
  LUA_CFLAGS  += -fprofile-arcs -ftest-coverage
  LUA_LDFLAGS += -fprofile-arcs -ftest-coverage
endif

# lua's Makefile defines AR="ar rcu", which is unusual, and makes it more
# challenging to cross-compile lua (and redis).  These defines make it easier
# to fit redis into cross-compilation environments, which typically set AR.
AR      = ar
ARFLAGS = rc

lua: .make-prerequisites
	$(call MSG,"lua")
	cd lua && \
	$(MAKE) all CFLAGS="$(LUA_CFLAGS)" MYLDFLAGS="$(LUA_LDFLAGS)" AR="$(AR) $(ARFLAGS)"

.PHONY: lua


distclean:
	-(cd linenoise && $(MAKE) clean) >/dev/null || true
	-(cd lua && $(MAKE) clean) >/dev/null || true
