local BaseMedium = require("Computer/Classes/BaseMedium")

---@class Disc_Game
local Disc_Game = BaseMedium:derive("Disc_Game", {})

---@return Disc_Game
function Disc_Game:new(...)
    local o = BaseMedium:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return Disc_Game
