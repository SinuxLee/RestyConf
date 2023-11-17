#!/usr/bin/resty -Iresty_modules/lualib
local httpc = require("resty.http").new()
local cjson = require "cjson"

-- Single-shot requests use the `request_uri` interface.
local res, err = httpc:request_uri("http://10.0.84.104/anything/haha", {
    method = "POST",
    body = "a=1&b=2",
    headers = {
        ["Content-Type"] = "application/x-www-form-urlencoded",
        ["X-QP-AppId"] = "1001",
    },
})
if not res then
    ngx.say(ngx.ERR, "request failed: ", err)
    return
end

-- At this point, the entire request / response is complete and the connection
-- will be closed or back on the connection pool.

-- The `res` table contains the expeected `status`, `headers` and `body` fields.
local status = res.status
local length = res.headers["Content-Length"]
local body   = res.body

print(status)
print(length)
print(cjson.decode(body).origin)
