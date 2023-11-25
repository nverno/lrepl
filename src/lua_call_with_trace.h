#pragma once
#include "lauxlib.h"
#include "lua_traceback2.h"
#include "util.h"

void expanderr(lua_State *L);
int lua_call_with_trace(lua_State *L, int nargs, int nres, lua_State *C);
