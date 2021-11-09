local BaseMedium = require("Computer/Classes/BaseMedium")

---@class Floppy_Game
local Floppy_Game = BaseMedium:derive("Floppy_Game", {})

---@return Floppy_Game
function Floppy_Game:new(...)
    local o = BaseMedium:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return Floppy_Game
