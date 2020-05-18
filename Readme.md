游戏项目中遇到的狗屎问题，分享一下解决经验，以一个最基本的程序为例：
#### `test.c`
```c
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

```
在windows系统和linux系统中，可以直接使用gcc编译，注意链接`lua51.dll`或者`libluajit.so`，记得改掉下面命令中的`path/to/`
```bash
gcc test.c path/to/lua51.dll -s -O2 -DNDEBUG -o test.dll
```

```bash
gcc test.c path/to/libluajit.so -s -O2 -DNDEBUG -o libtest.so
```
然后在lua中调用`require"test"`就可以导入使用了，打包游戏的时候记得把库放在外面，和`love.dll`放在一起，不要塞进`game.love`或者`exe`

android系统就比较恶心了，自备NDK，以下教程写于windows系统，在`test.c`所在的目录创建`Android.mk`和`Application.mk`，下面的代码中记得修改`path/to/`，为liblove.so所在的目录（可以直接解压love2d的安装包拿）

#### `Android.mk`
```
LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := test
LOCAL_SRC_FILES := test.c
LOCAL_LDFLAGS := -Lpath/to/$(TARGET_ARCH_ABI) -llove
LOCAL_C_INCLUDES := include
include $(BUILD_SHARED_LIBRARY)
```

#### `Application.mk`
```
APP_CPPFLAGS := -frtti 
APP_LDFLAGS := -latomic
APP_ABI := armeabi-v7a arm64-v8a
APP_PLATFORM := android-16
APP_OPTIM := release
```
然后调用`ndk-build`编译，日常记得修改`path/to/`
```bash
path/to/ndk-build NDK_PROJECT_PATH=. NDK_APPLICATION_MK=Application.mk APP_BUILD_SCRIPT=Android.mk
```
会报可能错误链接的warning，问题不大，编译完成后会在`libs`文件夹里得到两个`libtest.so`

最后编写lua程序，这里有个巨坑，`*.so`必须放到`/data/data/package.name`里面才能被`require`正确加载，否则会爆类似下面的神秘错误

```
Error

error loading module 'test' from file '/sdcard/libtest.so':
dlopen failed: library "/sdcard/libtest.so" needed or dlopened by "/data/app/org.love2d.android.embed-cfg2TKQ-XsSj13FxWVvTUw==/lib/arm64/liblove.so" is not accessible for the namespace "classloader-namespace"

Traceback
[C]: at 0x7a3d813a7c
[C]: in function 'require'
/sdcard/prog.lua:2: in main chunk
[C]: in function 'require'
main.lua:2: in main chunk
[C]: in function 'require'
[C]: in function 'xpcall'
[C]: in function 'xpcall'
```

那么问题来了，如何放到`/data/data/package.name`里面呢…？

把`*.so`文件打包进`game.love`，然后用下面的代码copy到save文件夹里，也算是个办法吧。
```lua
package.cpath='/data/data/org.love2d.android.embed/files/save/archive/lib?.so;'..package.cpath
love.filesystem.write("libtest.so", love.filesystem.read("libtest.so"))
require "test"
```

it just works
