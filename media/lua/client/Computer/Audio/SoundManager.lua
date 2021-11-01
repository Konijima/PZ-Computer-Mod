require("Computer/ComputerUtils")

local EmitterInstance = require("Computer/Audio/EmitterInstance")

local Sounds = {}

---@class SoundManager
SoundManager = {}

---@param emitterName string
---@param x number
---@param y number
---@param z number
---@return EmitterInstance|nil
function SoundManager.GetEmitterAt(emitterName, x, y, z)
    local position = ComputerUtils.positionToId(x, y, z)
    if Sounds[position] and Sounds[position][emitterName] then
        return Sounds[position][emitterName]
    end
end

---@param emitterName string
---@param soundList string|table<string>
---@param x number
---@param y number
---@param z number
---@return EmitterInstance|nil
function SoundManager.PlaySoundAt(emitterName, soundList, x, y, z)
    local currentEmitter = SoundManager.GetEmitterAt(x, y, z)
    if currentEmitter == nil or not currentEmitter:isPlaying() then
        local instance = EmitterInstance:new(emitterName, soundList, x, y, z)

        -- Add it
        local position = ComputerUtils.positionToId(x, y, z)
        if not Sounds[position] then Sounds[position] = {}; end
        Sounds[position][emitterName] = instance

        return instance;
    end
end

---@param emitterName string
---@param x number
---@param y number
---@param z number
---@return boolean
function SoundManager.StopEmitterAt(emitterName, x, y, z)
    local position = ComputerUtils.positionToId(x, y, z)
    if Sounds[position] and Sounds[position][emitterName] then
        if Sounds[position][emitterName]:isPlaying() then
            Sounds[position][emitterName]:stop()
        end
        Sounds[position][emitterName] = nil
        return true
    end
end

---@param x number
---@param y number
---@param z number
function SoundManager.StopAllSoundsAt(x, y, z)
    local position = ComputerUtils.positionToId(x, y, z)
    if Sounds[position] then
        for _, emitter in pairs(Sounds[position]) do
            if emitter and emitter:isPlaying() then
                emitter:stop()
            end
        end
        Sounds[position] = {}
    end
end

local function Tick()
    for positionKey, position in pairs(Sounds) do
        for emitterKey, emitter in pairs(position) do
            if not emitter then return; end

            if not emitter.completed then
                emitter:tick()
            else
                Sounds[positionKey][emitterKey] = nil
            end
        end
    end
end
Events.OnTick.Add(Tick)