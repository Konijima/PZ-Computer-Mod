local BaseHardware = require("Computer/Classes/BaseHardware")

---@class BaseDrive
local BaseDrive = BaseHardware:derive("BaseDrive", {})

---@param classType string
---@param classParams table
---@return BaseDrive
function BaseDrive:derive(classType, classParams)
    local o = BaseHardware:derive(classType, classParams)
    setmetatable(o, self)
    self.__index = self
    return o
end

---@return BaseDrive
function BaseDrive:new()
    local o = BaseHardware:new()
    setmetatable(o, self)
    self.__index = self
    return o
end

return BaseDrive
