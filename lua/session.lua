local _M = {}
_M._version = "0.0.1"

function _M.new()
    local obj = {
        uuid = 0,
        gid = 0,
        appId = 0,
        userId = 0,
        login = 0,
        state = 0,
        logicId = 0,
        loginMod = 0,

    }
    return setmetatable(obj, { __index = _M })
end

return _M
