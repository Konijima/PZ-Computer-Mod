local BaseMedium = require("Computer/Classes/BaseMedium")

---@class Floppy
local Floppy = BaseMedium:derive("Floppy", {})

---@return Floppy
function Floppy:new(...)
    local o = BaseMedium:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return Floppy
