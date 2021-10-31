require("ISBaseObject")

local Sound = ISBaseObject:derive("Sound")

function Sound:getSquare()
    local cell = getCell()
    if cell then
        return cell:getGridSquare(self.position.x, self.position.y, self.position.z)
    end
end

function Sound:isLooping()
    return self.loop
end

function Sound:isPlaying()
    return self.audio and self.audio:isPlaying()
end

function Sound:play()
    self.square = self:getSquare()
    if self.square then
        print("Sound "..self.audioName.." play!")
        self.audio = getSoundManager():PlayWorldSoundWav(self.audioName, false, self.square, 0, 10, 1, false)
        return self.audio
    end
end

function Sound:stop()
    if self:isPlaying() then
        print("Sound "..self.audioName.." stop!")
        self.audio:stop()
    end
end

function Sound:new(audioName, x, y, z, loop, onCompleted)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self
    --- Properties

    if type(audioName) == "string" and type(x) == "number" and type(y) == "number" and type(z) == "number" then
        o.audio = nil
        o.audioName = audioName
        o.position = { x = x, y = y, z = z}
        o.square = nil
        o.loop = loop

        if type(onCompleted) == "function" then
            o.onCompleted = onCompleted
        end

        print("Sound "..o.audioName.." instance created!")
        return o
    end
end

return Sound
