
LUA_VERSION = 5.4.6
LUA_DIR     = $(CURDIR)/lua-$(LUA_VERSION)
LUA_SRC_URL = https://www.lua.org/ftp/lua-$(LUA_VERSION).tar.gz

BUILDDIR    = $(CURDIR)/build

.PHONY: run all build install deps

all:
	@

install: lua deps

deps:
	$(MAKE) -C $(CURDIR)/deps

run: build
	$(BUILDDIR)/bin/tutorial

build: $(BUILDDIR)
	@make -C $(BUILDDIR)

$(BUILDDIR): lua
	@cmake -B $(BUILDDIR)


lua: $(LUA_DIR)/CMakeLists.txt                    ## Build lua lib

$(LUA_DIR): lua-$(LUA_VERSION).tar.gz
	@tar xvf $^

.INTERMEDIATE: lua-$(LUA_VERSION).tar.gz
lua-$(LUA_VERSION).tar.gz:
	@wget $(LUA_SRC_URL)

$(LUA_DIR)/CMakeLists.txt: $(LUA_DIR)
	@cp $(CURDIR)/cmake/lua.CMakeLists.txt $@

.PHONY: clean distclean
clean:
	$(RM) -r *~ *.core *.o *.out *.exe 

distclean: clean
	$(RM) -rf $$(git ls-files --others --ignored --exclude-standard)
