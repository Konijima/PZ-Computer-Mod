require("ISBaseObject")

---@class Floppy
local Floppy = ISBaseObject:derive("Floppy")

---@return Floppy
function Floppy:new(...)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self

    local args = {...}

    -- Check if passing a Floppy as an Item
    if args[1] and instanceof(args[1], "InventoryItem") then
        
    -- Check if passing a Floppy as data
    else
        
    end

    --- Properties
    return o
end

return Floppy
