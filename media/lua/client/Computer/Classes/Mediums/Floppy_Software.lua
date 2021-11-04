local BaseMedium = require("Computer/Classes/BaseMedium")

---@class Floppy_Software
local Floppy_Software = BaseMedium:derive("Floppy_Software", {})

---@return Floppy_Software
function Floppy_Software:new(...)
    local o = BaseMedium:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return Floppy_Software
