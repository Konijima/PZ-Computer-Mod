local BaseHardware = require("Computer/Classes/BaseHardware")

local File = require("Computer/Classes/File")
local Game = require("Computer/Classes/Game")
local Software = require("Computer/Classes/Software")

local ReadWriteSpeeds = {1, 2, 3, 4}
local StorageCapacities = {64, 128, 256, 512}

---@class Harddrive
local Harddrive = BaseHardware:derive("Harddrive", {
    {name = "type",         type = "string"},
    {name = "name",         type = "string"},
    {name = "specs",        type = "table"},
    {name = "files",        type = "table"},
    {name = "games",        type = "table"},
    {name = "softwares",    type = "table"},
})

---@return table
function Harddrive.GetReadWriteSpeeds()
    return copyTable(ReadWriteSpeeds)
end

---@return table
function Harddrive.GetStorageCapacities()
    return copyTable(StorageCapacities)
end

---@return string
function Harddrive:getTooltipDescription()
    local description = ""
    description = description .. "<RGB:1,1,1> Size:  0/512 <LINE> "
    description = description .. "<RGB:1,1,1> Files: " .. #self.files .. " <LINE> "
    description = description .. "<RGB:1,1,1> Games: " .. #self.games .. " <LINE> "
    description = description .. "<RGB:1,1,1> Softwares: " .. #self.softwares .. " <LINE> "
    return description
end

---@return number
function Harddrive:getReadWriteSpeed()
    return ReadWriteSpeeds[self.specs.readWriteSpeedIndex]
end

---@return number
function Harddrive:getStorageCapacity()
    return StorageCapacities[self.specs.storageCapacity]
end

---@return File
function Harddrive:getFileByIndex(index)
    if self.files[index] then
        return self.files[index]
    end
end

---@param gameId string
---@return boolean
function Harddrive:isGameInstalled(gameId)
    if self.games[gameId] then
        return true
    end
end

---@param gameId string
---@return boolean
function Harddrive:isSoftwareInstalled(softwareId)
    if self.softwares[softwareId] then
        return true
    end
end

---@return number
function Harddrive:calcTotalFileSize()
    local size = 0
    if #self.files > 0 then
        for i=1, #self.files do
            local file = self.files[i]
            if file then
                size = size + file:calcSize()
            end
        end
    end
    return size
end

---@return number
function Harddrive:calcTotalGameSize()
    local size = 0
    if #self.games > 0 then
        for i=1, #self.games do
            local gameId = self.games[i]
            local game = ComputerMod.GetGameById(gameId)
            if game then
                size = size + game.size
            end
        end
    end
    return size
end

---@return number
function Harddrive:calcTotalSoftwareSize()
    local size = 0
    if #self.softwares > 0 then
        for i=1, #self.softwares do
            local softwareId = self.softwares[i]
            local software = ComputerMod.GetSoftwareById(softwareId)
            if software then
                size = size + software.size
            end
        end
    end
    return size
end

---@return number
function Harddrive:getUsedSpace()
    return self:calcTotalFileSize() + self:calcTotalGameSize() + self:calcTotalSoftwareSize()
end

---@return number
function Harddrive:getFreeSpace()
    return self:getStorageCapacity() - self:getUsedSpace()
end

---@return void
function Harddrive:randomize()
    self:randomizeSpecs()
    self:randomizeFiles()
    self:randomizeGames()
    self:randomizeSoftwares()
end

---@return void
function Harddrive:randomizeSpecs()
    self.specs = {}
    self.specs.readWriteSpeedIndex = ZombRand(#ReadWriteSpeeds)+1
    self.specs.storageCapacityIndex = ZombRand(#StorageCapacities)+1
    return self.specs
end

---@return void
function Harddrive:randomizeFiles()
    self.files = {}
    return self.files
end

---@return void
function Harddrive:randomizeGames()
    self.games = {}
    return self.games
end

---@return void
function Harddrive:randomizeSoftwares()
    self.softwares = {}
    return self.softwares
end

---@vararg string|table|InventoryItem
---@return Harddrive
function Harddrive:new(...)
    local o = BaseHardware:new()
    setmetatable(o, self)
    self.__index = self
    o:init(...)
    return o
end

return Harddrive
