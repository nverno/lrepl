
LUA_DIR = $(CURDIR)/deps/lua

CXXFLAGS ?= -I./deps -I$(LUA_DIR)/src -L$(LUA_DIR)/src

.PHONY: all install deps
all:
	@

install: deps
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

# $(LUA_LIB):
# 	@$(MAKE) -C $(LUA_DIR) linux-readline
# $(LUA_DIR): lua-$(LUA_VERSION).tar.gz
# 	@tar xvf $^

# .INTERMEDIATE: lua-$(LUA_VERSION).tar.gz
# lua-$(LUA_VERSION).tar.gz:
# 	@wget $(LUA_SRC_URL)

# $(LUA_DIR)/CMakeLists.txt: $(LUA_DIR)
# 	@cp $(CURDIR)/cmake/lua.CMakeLists.txt $@



.PHONY: clean distclean
clean:
	$(RM) -r *~ *.core *.o *.out *.exe 

distclean: clean
	$(RM) -rf $$(git ls-files --others --ignored --exclude-standard)
