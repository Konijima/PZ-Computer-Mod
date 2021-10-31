require("ISBaseObject")

---@class ComputerAddon
local ComputerAddon = ISBaseObject:derive("ComputerAddon")

---@param name string
---@return ComputerAddon
function ComputerAddon:new(name)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self

    o.addonName = name

    return o
end

return ComputerAddon
