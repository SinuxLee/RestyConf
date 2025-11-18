# RestyConf

## lua 在 nginx 中的执行过程

- init_by_lua  
    1.加载模块  
    2.初始化全局变量  
    3.影响所有 nginx 进程(master-worker)  
- init_worker_by_lua  
    1.启动定时任务，比如心跳检查，定时拉取服务器配置等
    2.在定时器中初始化子进程，注册到 redis，连接游戏服
- ssl_certificate_by_lua  
    ssl 阶段，在“握手”时设置安全证书
- preread_by_lua  
    只在 stream 模式下有效，http 中是系统自动调用的。
- set_by_lua  
    1.定义变量，此处是阻塞的，Lua 代码要做到非常快。
- rewrite_by_lua  
    可以实现复杂的转发/重定向逻辑
- access_by_lua  
    访问控制或限速,比如限制内网 ip 才能访问
- content_by_lua/balancer_by_lua  
    处理内容或者将内容转发给后端
- header_filter_by_lua  
    加工处理响应头
- body_filter_by_lua  
    对响应数据进行过滤，包装等
- log_by_lua  
    记录访问量/统计平均响应时间

## 进程编号

master启动时，从redis获取自增id值  
子进程的id = master id * 10 + worker id。parent pid 作为前缀可以避免 reload 时出现相同的进程 id

## 网络维护

子进程在启动时，将自己的服务信息注册到 redis，并从 redis 中获取后端服务的地址列表
连接后端服务将子进程信息上报给对方。

## 数据共享和传递

- 不同 worker 之间共享数据使用 shared_dict (原子的), 能够存储类型 boolean 、number 、string
- 同一 worker 的不同请求之间使用 lua-resty-lrucache 缓存数据,能够存储lua的所有类型
- 同一请求的不同阶段使用 ngx.ctx
- 进程间的锁 lua-resty-lock
- 分层缓存 lua-resty-mlcache

## 协程

- coroutine.create
- ngx.thread.spawn

## docker

docker run -p 5050:5050 -v $PWD/src:/www -v $PWD/conf:/etc/nginx -t -i openresty/openresty

## some libraries

- 编解码、加解密
    lua-resty-nettle  
    lua-resty-hmac  
    lua-resty-xxhash
- 缓冲管理
    lua-resty-sync 自动从 redis 同步缓冲中过期的数据
- 限流
    lua-resty-limit-rate
- http client
    lua-resty-requests  

- 不重启热更新
    lua-resty-load 动态加载 lua 代码  
    Slardar 动态变更上游列表和 lua 代码
- 配置中心
    lua-resty-consul 从 consul 加载动态配置  
- 上下文扩展
    lua-resty-ctxdump 扩展 ngx.ctx  
- 负载均衡
    lua-resty-multiplexer 基于协议的端口复用  
- 解析器
    lua-resty-ini  
    lua-resty-msgpack  
    lua-msgpack 很久不维护了
    luamqtt 接卸 MQTT 协议  
    lsjonschema json schema 校验
- 解析 user-agent
    lua-resty-woothee
- web应用框架
    lua-resty-yii  
- aliyun oss
    lua-resty-oss  
- 跨域访问
    lua-resty-cors  
- json 化 table
    lua-resty-prettycjson  
- id 生成器
    lua-resty-snowflake 雪花算法  
- 二进制解析
    lua-resty-struct 类似 python 的 struct 库，开发中  
    lua-struct 仿 php
- 日志库
    lua-resty-filecache 可以做成日志库  
    lua-resty-logger  
- id 定位
    lua-resty-ip2region  
- worker 进程间通信
    lua-resty-worker-events  
- 认证鉴权
    lua-resty-jwt  
- 纯 lua 库
    penlight  
- 自定义 luarocks 库
    https://segmentfault.com/a/1190000017176952?utm_source=tag-newest  

## 坑点

- 读取远端数据
    sock:receive() 读取一行  
    sock:receive("*l") 也是读取一行  
    sock:receive("*a") 一直读知道网络断开  
    sock:receive(1024) 读取指定长度  
    api 文档：http://w3.impa.br/~diego/software/luasocket/tcp.html#receive  

## lua运行时

- openresty  
- cocos2dx 系列：  
    Cocos2d-x 官方版本  
    quick-cocos2d-x 廖宇雷 不再维护 https://github.com/chukong/quick-cocos2d-x  
    Quick-Cocos2dx-Community http://www.cocos2d-lua.org/  
- redis
- skynet
- unity3d  
    xlu  
    ulua  
    slua
- unreal  
    unlua  
    sluaunreal
- wireshark 扩展
- wrk
- luvit
