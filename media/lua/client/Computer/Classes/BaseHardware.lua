---@class BaseHardware
BaseHardware = {};
BaseHardware.Type = "BaseHardware";

---@return string
function BaseHardware:getItemFullType()
    return "Computer."..self.Type
end

---@return string
function BaseHardware:getTooltipDescription()
    return ""
end

---@param inventory ItemContainer
---@return InventoryItem|nil
function BaseHardware:createItem(inventory)
    return nil
end

---@param type string
---@param name string
function BaseHardware:derive(type, name)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.Type= type;
    o.name = name;
    return o
end

function BaseHardware:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self

    return o
end
