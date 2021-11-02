local BaseHardware = require("Computer/Classes/BaseHardware")

---@class Processor
local Processor = BaseHardware:derive("Processor", {})

---@return string
function Processor:getTooltipDescription()
    local description = ""
    return description
end

---@vararg string|table|InventoryItem
---@return Processor
function Processor:new(...)
    local o = BaseHardware:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return Processor
