---@class Player 玩家
---@field uuid integer
---@field logicId integer
local _M = {
    _version = "0.0.1"
}

---创建新玩家
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
        name = "none",
    }
    return setmetatable(obj, { __index = _M })
end

function _M:get_uuid()
    return self.uuid
end

function _M:get_logicId()
    return self.logicId
end

return _M