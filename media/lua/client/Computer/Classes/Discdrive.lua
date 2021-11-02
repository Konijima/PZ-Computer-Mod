local BaseHardware = require("Computer/Classes/BaseHardware")

---@class Discdrive
local Discdrive = BaseHardware:derive("Discdrive", {
    { name = "discId", type = "string" },
})

---@return string
function Discdrive:getTooltipDescription()
    local description = " <RGB:1,1,1> Disc:  <RGB:0.8,0.5,0.5> Empty <LINE> "
    return description
end

---@vararg string|table|InventoryItem
---@return Discdrive
function Discdrive:new(...)
    local o = BaseHardware:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return Discdrive
