#!/usr/bin/env bash

set -u

yum install yum-utils -y
yum-config-manager --add-repo https://openresty.org/package/centos/openresty.repo

yum install -y openresty openresty-resty openresty-opm
resty -e 'ngx.say("hello");'

# sudo yum --disablerepo="*" --enablerepo="openresty" list available
# resty -V 2>&1 | sed 's/--/\n--/g'

#安装依赖库
opm --cwd get ledgetech/lua-resty-http
opm --cwd get openresty/lua-resty-redis
opm --cwd get openresty/lua-resty-lrucache
opm --cwd get chronolaw/lua-resty-msgpack

# luarocks init 初始化项目
# 在项目下安装包
# luarocks --tree=./lua_modules install luasocket
# luarocks write_rockspec # 生成包管理文件
# package.path = package.path .. ';lua_modules/share/lua/5.3/?.lua;lua_modules/share/lua/5.3/?/?.lua'
# package.cpath = package.cpath .. ';lua_modules/lib/lua/5.3/?/?.so'
