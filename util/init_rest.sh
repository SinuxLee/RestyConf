#!/usr/bin/env bash

git init rest
cd rest || exit
mkdir -p logs conf lua/http

touch conf/nginx.conf
cat << 'EOF' > conf/nginx.conf
worker_processes  1;

error_log       logs/error.log info;
pid             logs/nginx.pid;

events {
    worker_connections 1024;
}

http {
    log_format main '$remote_addr - $remote_user [$time_local] "$request" "$request_time" $status $body_bytes_sent "$http_referer" "$http_user_agent" $http_x_forwarded_for';
    access_log  logs/access.log  main;

    lua_package_path                "$prefix/lua/?/?.lua;;";

    init_by_lua_file                lua/http/init.lua;
    init_worker_by_lua_file         lua/http/worker.lua;
#   ssl_certificate_by_lua_file     lua/http/ssl.lua;

    server {
        listen 8080;
        location ~ ^/(\w+) {
            default_type                text/html;

            set_by_lua_file             $param lua/http/set.lua;
            rewrite_by_lua_file         lua/http/rewrite.lua;
            access_by_lua_file          lua/http/access.lua;
            content_by_lua_file         lua/http/content.lua;
#           balancer_by_lua_file        lua/http/balancer.lua;
            header_filter_by_lua_file   lua/http/header.lua;
            body_filter_by_lua_file     lua/http/body.lua;
            log_by_lua_file             lua/http/log.lua;

            echo $1;
        }
    }
}
EOF

files="init worker ssl set rewrite access content balancer header body log"
for name in $files
do
cat << EOF > lua/http/"${name}".lua
    ngx.log(ngx.INFO,'${name} phase')
EOF
done

cat << EOF > start_rest.sh
#!/usr/bin/env bash
[ ! -d "logs" ] && mkdir logs
openresty -p "$(pwd)" -c conf/nginx.conf
EOF

cat << EOF > stop_rest.sh
#!/usr/bin/env bash
if openresty -p "$(pwd)" -c conf/nginx.conf -s quit;then rm -rf ./*_temp; fi
EOF

cat << EOF > reload_rest.sh
#!/usr/bin/env bash
openresty -p "$(pwd)" -c conf/nginx.conf -s reload
EOF

chmod u+x ./*.sh
