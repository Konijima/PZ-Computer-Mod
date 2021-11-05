require("Computer/ComputerUtils")

local SoundInstance = require("Computer/Audio/SoundInstance")

local Sounds = {}

---@class SoundManager
SoundManager = {}

---@param soundName string
---@param x number
---@param y number
---@param z number
---@return SoundInstance|nil
function SoundManager.GetSoundAt(soundName, x, y, z)
    local position = ComputerUtils.positionToId(x, y, z)
    if Sounds[position] and Sounds[position][soundName] then
        return Sounds[position][soundName]
    end
end

---@param soundName string
---@param soundList string|table<string>
---@param x number
---@param y number
---@param z number
---@return SoundInstance|nil
function SoundManager.PlaySoundAt(soundName, soundList, x, y, z)
    local currentSound = SoundManager.GetSoundAt(x, y, z)
    if currentSound == nil or not currentSound:isPlaying() then
        local instance = SoundInstance:new(soundName, soundList, x, y, z)

        -- Add it
        local position = ComputerUtils.positionToId(x, y, z)
        if not Sounds[position] then Sounds[position] = {}; end
        Sounds[position][soundName] = instance

        return instance;
    end
end

---@param soundName string
---@param x number
---@param y number
---@param z number
---@return boolean
function SoundManager.StopSoundAt(soundName, x, y, z)
    local position = ComputerUtils.positionToId(x, y, z)
    if Sounds[position] and Sounds[position][soundName] then
        if Sounds[position][soundName]:isPlaying() then
            Sounds[position][soundName]:stop()
        end
        Sounds[position][soundName] = nil
        return true
    end
end

---@param x number
---@param y number
---@param z number
function SoundManager.StopAllSoundsAt(x, y, z)
    local position = ComputerUtils.positionToId(x, y, z)
    if Sounds[position] then
        for _, sound in pairs(Sounds[position]) do
            if sound and sound:isPlaying() then
                sound:stop()
            end
        end
        Sounds[position] = {}
    end
end

local function Tick()
    for positionKey, position in pairs(Sounds) do
        for soundName, sound in pairs(position) do
            if not sound then return; end

            if not sound.completed then
                sound:tick()
            else
                Sounds[positionKey][soundName] = nil
            end
        end
    end
end
Events.OnTick.Add(Tick)