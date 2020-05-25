#include "stdafx.h"
#include <lua.hpp>                                /* Always include this when calling Lua */
//#include <lua.h>                                /* Always include this when calling Lua */
//#include <lauxlib.h>                            /* Always include this when calling Lua */
//#include <lualib.h>                             /* Always include this when calling Lua */

#include <stdlib.h>                             /* For function exit() */
#include <stdio.h>                              /* For input/output */

void bail(lua_State *L, char *msg) {
	fprintf(stderr, "\nFATAL ERROR:\n  %s: %s\n\n",
		msg, lua_tostring(L, -1));
	exit(1);
}

int ccallback(lua_State* L)
{
	int n = lua_gettop(L);    /* number of arguments */
	const char* word = lua_tostring(L, 1);

	printf("Callback in C called from lua with \"%s\"!\n", word);

	return 0; // no return values
}

int main(void) {
	lua_State *L;

	L = luaL_newstate();                        /* Create Lua state variable */
	luaL_openlibs(L);                           /* Load Lua libraries */

	if (luaL_loadfile(L, "helloscript.lua"))    /* Load but don't run the Lua script */
		bail(L, "luaL_loadfile() failed");      /* Error out if file can't be read */

	lua_register(L, "andBackToC", &ccallback);  /* Register a c callback*/

	printf("In C, calling Lua\n");

	if (lua_pcall(L, 0, 0, 0))                  /* Run the loaded Lua script */
		bail(L, "lua_pcall() failed");          /* Error out if Lua file has an error */

	lua_getglobal(L, "tellme");
	if (lua_pcall(L, 0, 0, 0))
		bail(L, "lua_pcall(tellme) failed");          /* Error out if Lua file has an error */

	lua_getglobal(L, "tellthat");
	lua_pushliteral(L, "first");
	if (lua_pcall(L, 1, 0, 0))
		bail(L, "lua_pcall(tellthat) failed");          /* Error out if Lua file has an error */

	lua_getglobal(L, "tellthat");
	lua_pushliteral(L, "second");
	if (lua_pcall(L, 1, 0, 0))
		bail(L, "lua_pcall(tellthat) failed");          /* Error out if Lua file has an error */

	printf("Back in C again\n");

	lua_close(L);                               /* Clean up, free the Lua state var */

	return 0;
}
