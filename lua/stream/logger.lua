local cjson = require 'cjson'

local log = ngx.log
local emerg = ngx.EMERG
local alert = ngx.ALERT
local crit = ngx.CRIT
local err = ngx.ERR
local warn = ngx.WARN
local notice = ngx.NOTICE
local info = ngx.INFO
local debug = ngx.DEBUG

--- @class logger
local Logger = {}

---@vararg string
function Logger.emerg(...)
    return log(emerg, ...)
end

function Logger.alert(...)
    return log(alert, ...)
end

function Logger.crit(...)
    return log(crit, ...)
end

function Logger.err(...)
    return log(err, ...)
end

function Logger.warn(...)
    return log(warn, ...)
end

function Logger.notice(...)
    return log(notice, ...)
end

--- @vararg string
function Logger.info(...)
    local arg = { ... }
    for index, value in ipairs(arg) do
        if type(value) == 'table' then
            arg[index] = cjson.encode(value)
        end
    end
    return log(info, table.concat(arg, " "))
end

function Logger.debug(...)
    local arg = { ... }
    return log(debug, table.concat(arg, " "))
end

Logger.print = Logger.info
return Logger
