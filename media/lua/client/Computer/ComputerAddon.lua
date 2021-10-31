require("ISBaseObject")

---@class ComputerAddon
local ComputerAddon = ISBaseObject:derive("ComputerAddon")

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

    o.OnStart = nil
    o.OnUpdate = nil

    return o
end

return ComputerAddon
