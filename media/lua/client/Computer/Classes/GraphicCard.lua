local BaseHardware = require("Computer/Classes/BaseHardware")

---@class GraphicCard
local GraphicCard = BaseHardware:derive("GraphicCard", {})

---@return string
function GraphicCard:getTooltipDescription()
    local description = ""
    return description
end

---@vararg string|table|InventoryItem
---@return GraphicCard
function GraphicCard:new(...)
    local o = BaseHardware:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return GraphicCard
