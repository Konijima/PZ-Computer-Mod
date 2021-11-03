local BaseHardware = require("Computer/Classes/BaseHardware")

---@class SoundCard
local SoundCard = BaseHardware:derive("SoundCard", {})
SoundCard.SlotName = "Sound Card";
SoundCard.SlotRequired = false;

---@return string
function SoundCard:getTooltipDescription()
    local description = ""
    return description
end

---@vararg string|table|InventoryItem
---@return SoundCard
function SoundCard:new(...)
    local o = BaseHardware:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return SoundCard
