local BaseMedium = require("Computer/Classes/BaseMedium")

---@class Disc
local Disc = BaseMedium:derive("Disc", {})

---@return Disc
function Disc:new(...)
    local o = BaseMedium:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return Disc
