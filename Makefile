include defaults.mk

LUA_DIR = $(CURDIR)/deps/lua

MYLUA_FLAGS = -DLUA_USE_LINUX -DLUA_USE_READLINE -DLUA_ANSI
MYINC       = -I$(LUA_DIR) -L$(LUA_DIR)
# MYLDFLAGS   = $(LOCAL) -Wl,-E
MYLIBS      = -ldl -lreadline

CC       = gcc
CXXFLAGS = -ggdb3 -O0 -Wall -fno-stack-protector -fno-common -march=native \
		$(LOCAL) $(MYLUA_FLAGS) $(MYINC)
CFLAGS   = $(CWARNSC) -std=c99 $(CXXFLAGS)
LIBS     = -llua -lm

.PHONY: all install deps
all:
	@

src/lua: src/lua.c
	$(CC) $(CFLAGS) $^ -o $@ $(MYLIBS) $(LIBS)

install: deps
export LUA_DEBUG=yes
deps:
	@git submodule init
	$(MAKE) -C $(CURDIR)/deps

tst: test/tst
	@cd test && ./tst
test/tst: $(LUA_LIB) test/tst.cpp
	$(CXX) $(CXXFLAGS) test/tst.cpp -o $@ -llua

# LUA_VERSION = 5.4.6
# LUA_DIR     = $(CURDIR)/lua-$(LUA_VERSION)
# LUA_SRC_URL = https://www.lua.org/ftp/lua-$(LUA_VERSION).tar.gz
# LUA_LIB     = $(LUA_DIR)/src/liblua.a

$(LUA_LIB):
	@$(MAKE) -C $(LUA_DIR) linux-readline
# $(LUA_DIR): lua-$(LUA_VERSION).tar.gz
# 	@tar xvf $^

# .INTERMEDIATE: lua-$(LUA_VERSION).tar.gz
# lua-$(LUA_VERSION).tar.gz:
# 	@wget $(LUA_SRC_URL)

# $(LUA_DIR)/CMakeLists.txt: $(LUA_DIR)
# 	@cp $(CURDIR)/cmake/lua.CMakeLists.txt $@



.PHONY: clean distclean
clean:
	$(RM) -r *~ *.core *.o *.out *.exe test/tst src/lua

distclean: clean
	$(RM) -rf $$(git ls-files --others --ignored --exclude-standard)
