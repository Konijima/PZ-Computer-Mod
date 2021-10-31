require("Computer/ComputerUtils")

local Sound = require("Computer/Audio/Sound")

---@type table<string, ArrayList>
local Sounds = {}

---@param x number
---@param y number
---@param z number
---@return ArrayList<Sound>
local function GetAllSoundsAt(x, y, z)
    local id = ComputerUtils.positionToId(x, y, z)
    if id and Sounds[id] then
        return Sounds[id]
    end
end

---@param audioName string
---@param x number
---@param y number
---@param z number
---@return Sound | nil
local function GetSoundAt(audioName, x, y, z)
    local id = ComputerUtils.positionToId(x, y, z)
    if id and Sounds[id] then
        for i=0, Sounds[id]:size()-1 do
            local sound = Sounds[id]:get(i)
            if sound.audioName == audioName then
                return sound
            end
        end
    end
end

---@param audioName string
---@param x number
---@param y number
---@param z number
---@return boolean
local function IsSoundLoopingAt(audioName, x, y, z)
    local id = ComputerUtils.positionToId(x, y, z)
    if id then
        local sound = GetSoundAt(audioName, x, y, z)
        if sound then
            return sound:isLooping()
        end
    end
end

---@param audioName string
---@param x number
---@param y number
---@param z number
---@return boolean
local function IsSoundPlayingAt(audioName, x, y, z)
    local id = ComputerUtils.positionToId(x, y, z)
    if id then
        local sound = GetSoundAt(audioName, x, y, z)
        if sound then
            return sound:isPlaying()
        end
    end
end

---@param audioName string
---@param x number
---@param y number
---@param z number
---@return void
local function StopSoundAt(audioName, x, y, z)
    local id = ComputerUtils.positionToId(x, y, z)
    if id then
        local sound = GetSoundAt(audioName, x, y, z)
        if sound then
            sound:stop()
            Sounds[id]:remove(sound)
            print("Sound "..sound.audioName.." removed!")
        end
    end
end

---@param audioName string
---@param x number
---@param y number
---@param z number
---@param loop boolean
---@param onCompleted function | nil
local function PlaySoundAt(audioName, x, y, z, loop, onCompleted)
    local id = ComputerUtils.positionToId(x, y, z)
    if id then
        if not Sounds[id] then
            Sounds[id] = ArrayList.new();
        end

        if not GetSoundAt(audioName, x, y, z) then
            local sound = Sound:new(audioName, x, y, z, loop, onCompleted)
            if sound then
                sound:play()
                Sounds[id]:add(sound)
                print("Sound "..sound.audioName.." added!")
                return sound
            end
        end
    end
end

---@param x number
---@param y number
---@param z number
---@return void
local function StopAllSoundsAt(x, y, z)
    local id = ComputerUtils.positionToId(x, y, z)
    if id and Sounds[id] then
        for i=0, Sounds[id]:size()-1 do
            local sound = Sounds[id]:get(i)
            if sound then
                sound:stop()
                Sounds[id]:remove(sound)
                print("Sound "..sound.audioName.." removed!")
            end
        end
    end
end

---@return void
local function Update()
    for k, _ in pairs(Sounds) do
        local squareSounds = Sounds[k]
        for i=0, squareSounds:size()-1 do
            local sound = squareSounds:get(i)
            if sound and not sound:isPlaying() then
                if sound:isLooping() then
                    sound:play()
                else
                    print("Sound "..sound.audioName.." completed!")
                    if sound.onCompleted then
                        print("Sound "..sound.audioName.." executing onCompleted!")
                        sound.onCompleted()
                    end
                    Sounds[k]:remove(sound)
                    print("Sound "..sound.audioName.." removed!")
                end
            end
        end
    end
end

--- GAME EVENTS

Events.OnTick.Add(Update)

--- GLOBAL

---@class SoundManager
SoundManager = {}

function SoundManager.GetAllSoundsAt(...) return GetAllSoundsAt(...); end
function SoundManager.GetSoundAt(...) return GetSoundAt(...); end
function SoundManager.PlaySoundAt(...) return PlaySoundAt(...); end
function SoundManager.StopSoundAt(...) return StopSoundAt(...); end
function SoundManager.StopAllSoundsAt(...) return StopAllSoundsAt(...); end
function SoundManager.IsSoundLoopingAt(...) return IsSoundLoopingAt(...); end
function SoundManager.IsSoundPlayingAt(...) return IsSoundPlayingAt(...); end
