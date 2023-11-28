#pragma once
#include "lauxlib.h"
#include "lua.h"
#include <string.h>

LUALIB_API void(luaL_traceback2)(lua_State *L, lua_State *L1, const char *msg,
                                 int level);
