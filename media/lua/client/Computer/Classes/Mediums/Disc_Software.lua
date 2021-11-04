local BaseMedium = require("Computer/Classes/BaseMedium")

---@class Disc_Software
local Disc_Software = BaseMedium:derive("Disc_Software", {})

---@return Disc_Software
function Disc_Software:new(...)
    local o = BaseMedium:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return Disc_Software
