# 项目依赖管理文件

```shell
# 生成rockspec文件
luarocks write_rockspec demo 1.0 ./ --lua-versions=5.1 --output=demo.rockspec
```

实例文件

```lua
package ="vanilla"
version ="0.1.0-1"

source ={
    url ="git://github.com/idevz/vanilla.git" -- 必须为可访问的在线库地址
}

description ={
    summary       ="A Lightweight Openresty Web Framework",
    homepage      ="http://idevz.github.io/vanilla",
    maintainer    ="zhoujing<zhoujing00k@gmail.com>",
    license       ="MIT"                    -- 必须指明所基于的开源协议
}

dependencies ={
    "lua=5.1",
    ... ...
    "lua-resty-http=0.06-0"
}

build ={
    type ="builtin",
    modules ={
        ["vanilla.v.view"]                      ="vanilla/v/view.lua",
        ... ...
        ["vanilla.v.views.rtpl"]                ="vanilla/v/views/rtpl.lua",
    },
    install ={
        bin ={ "bin/vanilla" }
    },
}
```

## 管理项目依赖的包

```shell
# 设置Lua环境的目录
luarocks config lua_dir /usr/local/lua
# 搜索包
luarocks search lua-cjson

# 安装依赖包
luarocks install luasocket --tree=./ --check-lua-versions
luarocks install lua-cjson 2.1.0-1 --tree=./

# 查看指定包信息
luarocks show --tree=./ lua-cjson

# 查看包列表
luarocks list -tree=./

# 卸载指定库
luarocks remove --tree=./ lua-cjson

# 删除指定目录下的所有依赖包
luarocks purge --tree=./

以上命令中 --tree可以替换为 --local，则默认路径变为账号根路径下的".luarocks/"
```

## 开发自己的库

```shell
# 初始化
luarocks init demo

# 构建
luarocks --tree=./ make

# 测试
luarocks test

# 上传到远程
luarocks upload
```

### Lua 库路径搜索方式

``` shell
在Lua文件中加入
package.cpath = "lib64/lua/5.1/?.so;;"
package.path = "share/lua/5.1/?.lua;share/lua/5.1/?/init.lua;;"

或者修改环境变量
LUA_PATH="/add_path/?.lua;;"

以 require 'foo' 为例
0. 预加载库
 package.preload
1. 当前路径
 ./foo.lua
 ./foo.so
 ./foo/init.lua
 
2.当前子目录
 ./share/lua/5.4/foo.lua
 ./share/lua/5.4/foo/init.lua
 
 ./lib/lua/5.4/foo.lua
 ./lib/lua/5.4/foo/init.lua
 ./lib/lua/5.4/foo.so
 
3.Lua安装目录
 
```
