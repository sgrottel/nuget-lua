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

int main(void) {
    lua_State *L;

    L = luaL_newstate();                        /* Create Lua state variable */
    luaL_openlibs(L);                           /* Load Lua libraries */

    if (luaL_loadfile(L, "helloscript.lua"))    /* Load but don't run the Lua script */
        bail(L, "luaL_loadfile() failed");      /* Error out if file can't be read */

    printf("In C, calling Lua\n");

    if (lua_pcall(L, 0, 0, 0))                  /* Run the loaded Lua script */
        bail(L, "lua_pcall() failed");          /* Error out if Lua file has an error */

    printf("Back in C again\n");

    lua_close(L);                               /* Clean up, free the Lua state var */

    return 0;
}
