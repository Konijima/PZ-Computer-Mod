local BaseHardware = require("Computer/Classes/BaseHardware")

---@class PowerSupply
local PowerSupply = BaseHardware:derive("PowerSupply", {})
PowerSupply.SlotName = "Power Supply";
PowerSupply.SlotRequired = true;

---@return string
function PowerSupply:getTooltipDescription()
    local description = ""
    return description
end

---@vararg string|table|InventoryItem
---@return PowerSupply
function PowerSupply:new(...)
    local o = BaseHardware:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return PowerSupply
