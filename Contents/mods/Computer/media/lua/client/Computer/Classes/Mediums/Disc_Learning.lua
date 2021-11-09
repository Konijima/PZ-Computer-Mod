local BaseMedium = require("Computer/Classes/BaseMedium")

---@class Disc_Learning
local Disc_Learning = BaseMedium:derive("Disc_Learning", {})

---@return Disc_Learning
function Disc_Learning:new(...)
    local o = BaseMedium:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return Disc_Learning
