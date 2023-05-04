#include "stdafx.h"
#include <lua.hpp>                                /* Always include this when calling Lua */
//#include <lua.h>                                /* Always include this when calling Lua */
#include <lauxlib.h>                            /* Always include this when calling Lua */
#include <lualib.h>                             /* Always include this when calling Lua */

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

struct MyObject {
	int m_value;
};

static int newMyObject(lua_State* L)
{
	MyObject* mo = (MyObject*)lua_newuserdata(L, sizeof(MyObject)); // put on stack
	luaL_getmetatable(L, "SGR.MyObject");
	lua_setmetatable(L, -2);
	mo->m_value = 42;
	return 1; // mo is on stack
}

static MyObject* checkMyObject(lua_State* L) {
	void* ud = luaL_checkudata(L, 1, "SGR.MyObject");
	luaL_argcheck(L, ud != NULL, 1, "`SGR.MyObject' expected");
	return (MyObject*)ud;
}

static int deleteMyObject(lua_State* L)
{
	MyObject* mo = checkMyObject(L);
	printf("delete MyObject[%d]\n", mo->m_value);
	return 0;
}

static int setMyObjectValue(lua_State* L)
{
	MyObject* mo = checkMyObject(L);
	int value = static_cast<int>(luaL_checkinteger(L, 2));
	mo->m_value = value;
	return 0;
}

static int getMyObjectValue(lua_State* L)
{
	MyObject* mo = checkMyObject(L);
	lua_pushinteger(L, mo->m_value);
	return 1;
}

static int toStringMyObject(lua_State* L)
{
	MyObject* mo = checkMyObject(L);
	lua_pushfstring(L, "MyObject[%d]", mo->m_value);
	return 1;
}

static void registerMyObject(lua_State* L)
{
	static const struct luaL_Reg myObjectLib_staticFunc[] = {
		{"new", newMyObject},
		{NULL, NULL}
	};
	static const struct luaL_Reg myObjectLib_memberFunc[] = {
		{"__tostring", toStringMyObject},
		{"__gc", deleteMyObject},
		{"set", setMyObjectValue},
		{"get", getMyObjectValue},
		{NULL, NULL}
	};

	int vr = luaL_newmetatable(L, "SGR.MyObject");

	lua_pushstring(L, "__index");
	lua_pushvalue(L, -2); /* pushes the metatable */
	lua_settable(L, -3); /* metatable.__index = metatable */

	luaL_setfuncs(L, myObjectLib_memberFunc, 0);

	lua_newtable(L); // push table on stack
	luaL_setfuncs(L, myObjectLib_staticFunc, 0);
	lua_setglobal(L, "MyObject");
}

int main(void) {
	lua_State *L;

	L = luaL_newstate();                        /* Create Lua state variable */
	luaL_openlibs(L);                           /* Load Lua libraries */

	registerMyObject(L);

	if (luaL_loadfile(L, "helloscript.lua"))    /* Load but don't run the Lua script */
		bail(L, "luaL_loadfile() failed");      /* Error out if file can't be read */

	lua_newtable(L); // push table on stack
	lua_pushcfunction(L, &ccallback); // push function on stack
	lua_setfield(L, -2, "call"); // sets table["call"] = ccallback, and pops functions from stack
	lua_setglobal(L, "chost"); // sets global chost = table, and pops table from stack

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
