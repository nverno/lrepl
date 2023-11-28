
LUA_VERSION = 5.4.6
LUA_DIR     = $(CURDIR)/lua-$(LUA_VERSION)
LUA_SRC_URL = https://www.lua.org/ftp/lua-$(LUA_VERSION).tar.gz
LUA_LIB     = $(LUA_DIR)/src/liblua.a

BUILDDIR    = $(CURDIR)/build

CXXFLAGS ?= -I./deps -I$(LUA_DIR)/src -L$(LUA_DIR)/src

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

$(LUA_LIB):
	@$(MAKE) -C $(LUA_DIR) linux-readline

lua: $(LUA_DIR)/CMakeLists.txt                    ## Build lua lib

$(LUA_DIR): lua-$(LUA_VERSION).tar.gz
	@tar xvf $^

.INTERMEDIATE: lua-$(LUA_VERSION).tar.gz
lua-$(LUA_VERSION).tar.gz:
	@wget $(LUA_SRC_URL)

$(LUA_DIR)/CMakeLists.txt: $(LUA_DIR)
	@cp $(CURDIR)/cmake/lua.CMakeLists.txt $@


tst: test/tst
	@cd test && ./tst
test/tst: $(LUA_LIB) test/tst.cpp
	$(CXX) $(CXXFLAGS) test/tst.cpp -o $@ -llua


.PHONY: clean distclean
clean:
	$(RM) -r *~ *.core *.o *.out *.exe 

distclean: clean
	$(RM) -rf $$(git ls-files --others --ignored --exclude-standard)
