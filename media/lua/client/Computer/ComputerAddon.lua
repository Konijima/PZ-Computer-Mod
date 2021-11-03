require("ISBaseObject")

---@class ComputerAddon
local ComputerAddon = ISBaseObject:derive("ComputerAddon")

function ComputerAddon:Start()

end

function ComputerAddon:Update()

end

---@param name string
---@return ComputerAddon
function ComputerAddon:new(name)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self

    o.name = name

    o.ComputerEvents = {}
    o.BiosSettings = {}
    o.SoftwareTypes = {}
    o.FilePack = {}
    o.GamePack = {}
    o.SoftwarePack = {}

    return o
end

return ComputerAddon
