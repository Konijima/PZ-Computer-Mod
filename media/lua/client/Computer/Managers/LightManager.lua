require("Computer/ComputerUtils")

local LightInstance = require("Computer/Managers/LightInstance")

local Lights = {}

---@class LightManager
LightManager = {}

---@param lightName string
---@param x number
---@param y number
---@param z number
---@return LightInstance|nil
function LightManager.GetLightAt(lightName, x, y, z)
    local position = ComputerUtils.positionToId(x, y, z)
    if Lights[position] and Lights[position][lightName] then
        return Lights[position][lightName]
    end
end

---@param lightName string
---@param x number
---@param y number
---@param z number
---@param radius number
---@param r number
---@param g number
---@param b number
---@return LightInstance|nil
function LightManager.AddLightAt(lightName, x, y, z, radius, r, g, b)
    local currentLight = LightManager.GetLightAt(x, y, z)
    if currentLight == nil then
        local instance = LightInstance:new(x, y, z, radius, r, g, b)

        -- Add it
        local position = ComputerUtils.positionToId(x, y, z)
        if not Lights[position] then Lights[position] = {}; end
        Lights[position][lightName] = instance

        return instance;
    end
end

---@param lightName string
---@param x number
---@param y number
---@param z number
---@return boolean
function LightManager.RemoveLightAt(lightName, x, y, z)
    local position = ComputerUtils.positionToId(x, y, z)
    if Lights[position] and Lights[position][lightName] then
        Lights[position][lightName]:remove()
        Lights[position][lightName] = nil
        return true
    end
end

---@param x number
---@param y number
---@param z number
function LightManager.RemoveAllLightsAt(x, y, z)
    local position = ComputerUtils.positionToId(x, y, z)
    if Lights[position] then
        for _, light in pairs(Lights[position]) do
            if light then
                light:remove()
            end
        end
        Lights[position] = {}
    end
end

local ticks = 0
local function Tick()
    ticks = ticks + 1
    if ticks > 4 then
        ticks = 0
        for _, position in pairs(Lights) do
            for _, light in pairs(position) do
                light:update()
            end
        end
    end
end
Events.OnTick.Add(Tick)