local BaseDrive = require("Computer/Classes/BaseDrive")

---@class Discdrive
local Discdrive = BaseDrive:derive("Discdrive", {
    { name = "disc", type = "string" }
})

---@return string
function Discdrive:getTooltipDescription()
    local description = " <RGB:1,1,1> Disc:  <RGB:0.8,0.5,0.5> Empty <LINE> "
    return description
end

---@vararg string|table|InventoryItem
---@return Discdrive
function Discdrive:new(...)
    local o = BaseDrive:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return Discdrive
