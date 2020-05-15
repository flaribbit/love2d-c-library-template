#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

static int about(lua_State *L){
    lua_pushstring(L,"test by flaribbit");
    return 1;
}

static const struct luaL_Reg funcList[]=
{
    {"about", about},
    {0, 0}
};

int luaopen_test(lua_State *L)
{
    luaL_register(L, "test", funcList);
    return 1;
}
