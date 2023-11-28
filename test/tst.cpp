// -*- compile-command: "make -C .. test/tst && ./tst" -*-
#include <iostream>
#include <string>

extern "C" {
#include "lauxlib.h"
#include "lua.h"
#include "lualib.h"
}

using std::cout, std::endl, std::string;

bool check_lua(lua_State *L, int r) {
  if (r != LUA_OK) {
    string err = lua_tostring(L, -1);
    cout << err << endl;
    return false;
  }
  return true;
}

// Function callable from lua
int lua_hostfunc(lua_State *L) {
  auto a = lua_tonumber(L, 1);
  auto b = lua_tonumber(L, 2);
  cout << "[C++]: hostfunc(" << a << ", " << b << ") called" << endl;
  lua_pushnumber(L, a + b);
  return 1;
}

int main(int argc, char *argv[]) {

  lua_State *L = luaL_newstate();
  luaL_openlibs(L);

  // register c function to call from lua
  lua_register(L, "hostfunc", lua_hostfunc);
  
  if (check_lua(L, luaL_dofile(L, "tst.lua"))) {
    lua_getglobal(L, "tst");
    if (lua_istable(L, -1)) {
      for (auto k : {"a", "b", "c", "d"}) {
	lua_pushstring(L, k);
	lua_gettable(L, -2);
	cout << lua_tostring(L, -1) << endl;
	lua_pop(L, 1);
      }
    } else if (lua_isfunction(L, -1)) {
      lua_pushnumber(L, 1);
      lua_pushnumber(L, 666);
      if (check_lua(L, lua_pcall(L, 2, 1, 0))) {
	cout << "[C++]: => " << lua_tonumber(L, -1) << endl;
	lua_pop(L, 1);
      }
    }

    lua_getglobal(L, "get_key");
    lua_pushstring(L, "b");
    if (check_lua(L, lua_pcall(L, 1, 1, 0))) {
      cout << "[C++]: => " << lua_tostring(L, -1) << endl;
      lua_pop(L, 1);
    }

    // lua call c function
    lua_getglobal(L, "call_host");
    lua_pushnumber(L, 3);
    lua_pushnumber(L, 7);
    lua_pcall(L, 2, 1, 0);
    cout << "[C++]: => " << lua_tonumber(L, -1) << endl;
    lua_pop(L, 1);
  }
  
  lua_close(L);
  return EXIT_SUCCESS;
}
