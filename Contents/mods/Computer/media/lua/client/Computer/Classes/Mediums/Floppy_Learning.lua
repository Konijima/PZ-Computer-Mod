local BaseMedium = require("Computer/Classes/BaseMedium")

---@class Floppy_Learning
local Floppy_Learning = BaseMedium:derive("Floppy_Learning", {})

---@return Floppy_Learning
function Floppy_Learning:new(...)
    local o = BaseMedium:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return Floppy_Learning
