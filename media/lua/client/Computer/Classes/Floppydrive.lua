local BaseHardware = require("Computer/Classes/BaseHardware")

---@class Floppydrive
local Floppydrive = BaseHardware:derive("Floppydrive", "Floppy Drive")

---@return string
function Floppydrive:getTooltipDescription()
    local description = " <RGB:1,1,1> Floppy:  <RGB:0.8,0.5,0.5> Empty <LINE> "
    return description
end

---@vararg string|table|InventoryItem
---@return Floppydrive
function Floppydrive:new(...)
    local o = BaseHardware:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return Floppydrive
