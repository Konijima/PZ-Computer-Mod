require("ISBaseObject")

---@class Disc
local Disc = ISBaseObject:derive("Disc")

---@return Disc
function Disc:new(...)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self

    local args = {...}

    -- Check if passing a Disc as an Item
    if args[1] and instanceof(args[1], "InventoryItem") then
        
    -- Check if passing a Disc as data
    else
        
    end

    --- Properties
    return o
end

return Disc
