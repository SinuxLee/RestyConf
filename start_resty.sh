#!/usr/bin/env bash
[ ! -d "logs" ] && mkdir logs
openresty -p `pwd` -c conf/nginx.conf
