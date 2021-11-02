local BaseHardware = require("Computer/Classes/BaseHardware")

---@class NetworkCard
local NetworkCard = BaseHardware:derive("NetworkCard", {})

---@return string
function NetworkCard:getTooltipDescription()
    local description = ""
    return description
end

---@vararg string|table|InventoryItem
---@return NetworkCard
function NetworkCard:new(...)
    local o = BaseHardware:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return NetworkCard
