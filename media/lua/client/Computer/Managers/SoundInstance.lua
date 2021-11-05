require("ISBaseObject")

---@class SoundInstance
local SoundInstance = ISBaseObject:derive("SoundInstance")

function SoundInstance:isPlaying()
    return self.audio ~= nil and self.emitter:isPlaying(self.audio)
end

function SoundInstance:stop()
    if self.emitter then
        self.emitter:stopAll()
    end
end

function SoundInstance:tick()
    if self.completed then return; end

    self.emitter:tick()

    if self.audio == nil or not self:isPlaying() then
        self.index = self.index + 1
        if self.soundList[self.index] then
            -- play next
            self.audio = self.emitter:playSound(self.soundList[self.index])
        else
            self.completed = true
        end
    end
end

---@param name string
---@param soundList string
---@param x number
---@param y number
---@param z number
---@return SoundInstance
function SoundInstance:new(name, soundList, x, y, z)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self

    if type(soundList) == "table" then
        o.soundList = soundList
    else
        o.soundList = {soundList}
    end

    o.name = name
    o.emitter = fmod.fmod.FMODSoundEmitter.new()
    o.emitter:setPos(x, y, z)
    o.index = 0
    o.audio = nil
    o.completed = false

    return o
end

return SoundInstance