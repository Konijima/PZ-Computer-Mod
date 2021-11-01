require("ISBaseObject")

---@class EmitterInstance
local EmitterInstance = ISBaseObject:derive("EmitterInstance")

function EmitterInstance:isPlaying()
    return self.audio ~= nil and self.emitter:isPlaying(self.audio)
end

function EmitterInstance:stop()
    if self.emitter then
        self.emitter:stopAll()
        --print("Emitter "..self.name.." has stopped at x:"..self.position.x.." y:"..self.position.y.." z:"..self.position.z.."!")
    end
end

function EmitterInstance:tick()
    if self.completed then return; end

    self.emitter:tick()

    if self.audio == nil or not self:isPlaying() then
        self.index = self.index + 1
        if self.soundList[self.index] then
            -- play next
            self.audio = self.emitter:playSound(self.soundList[self.index])
        else
            self.completed = true
            --print("Emitter "..self.name.." has completed at x:"..self.position.x.." y:"..self.position.y.." z:"..self.position.z.."!")
        end
    end
end

---@param name string
---@param soundList string
---@param x number
---@param y number
---@param z number
function EmitterInstance:new(name, soundList, x, y, z)
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
    --o.position = { x=x, y=y, z=z }

    --print("Emitter "..name.." was created at x:"..x.." y:"..y.." z:"..z.."!")

    return o
end

return EmitterInstance