local BaseMedium = require("Computer/Classes/BaseMedium")

---@class Disc_Retail
local Disc_Retail = BaseMedium:derive("Disc_Retail", {})

---@return Disc_Retail
function Disc_Retail:new(...)
    local o = BaseMedium:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return Disc_Retail
