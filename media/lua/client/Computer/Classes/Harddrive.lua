require("ISBaseObject")

local File = require("Computer/Classes/File")
local Game = require("Computer/Classes/Game")
local Software = require("Computer/Classes/Software")

---@type table
local ReadWriteSpeeds = {1, 2, 3, 4}

---@type table
local StorageCapacities = {64, 128, 256, 512}

---@class Harddrive
local Harddrive = ISBaseObject:derive("Harddrive")

---@return table
function Harddrive.GetReadWriteSpeeds()
    return copyTable(ReadWriteSpeeds)
end

---@return table
function Harddrive.GetStorageCapacities()
    return copyTable(StorageCapacities)
end

---@return string
function Harddrive:getName()
    return self.name
end

---@return string
function Harddrive:getType()
    return Harddrive.Type
end

---@return Harddrive
function Harddrive:getClass()
    return Harddrive
end

---@return string
function Harddrive:getItemFullType()
    return "Computer.Harddrive"
end

---@param inventory ItemContainer
---@return InventoryItem | nil
function Harddrive:createItem(inventory)
    if inventory then
        local item = inventory:AddItem(self:getItemFullType())
        local modData = item:getModData()
        modData.type = self:getType()
        modData.name = self:getName()
        modData.specs = self.specs
        modData.files = self.files
        modData.games = self.games
        modData.softwares = self.softwares
        item:setName(modData.name)
        return item
    end
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

---@vararg string | table | InventoryItem
---@return Harddrive
function Harddrive:new(...)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self

    local args = {...}

    -- Check if passing a Harddrive as data
    if #args > 1 then
        local paramCheck = {
            {name = "type",         type = "string", value = type(args[1])},
            {name = "name",         type = "string", value = type(args[2])},
            {name = "specs",        type = "table",  value = type(args[3])},
            {name = "files",        type = "table",  value = type(args[4])},
            {name = "games",        type = "table",  value = type(args[5])},
            {name = "softwares",    type = "table",  value = type(args[6])},
        }
        
        for i = 1, #args do
            if type(args[i]) ~= paramCheck[i].type then
                error("Error calling Harddrive:new - argument "..i.." ("..paramCheck[i].name..") expected to be of type "..paramCheck[i].type.." but was "..paramCheck[i].value..".", 2);
            else
                o[paramCheck[i].name] = args[i]
            end
        end

    -- Check if passing a Harddrive as an Item
    elseif instanceof(args[1], "InventoryItem") and args[1]:getFullType() == o:getItemFullType() then
        local item = args[1]

        local modData = item:getModData()
        o.type = o:getType()
        o.name = item:getName()
        o.specs = modData.specs or {}
        o.files = modData.files or {}
        o.games = modData.games or {}
        o.softwares = modData.softwares or {}

    elseif type(args[1]) == "table" then
        o.type = o:getType()
        o.name = args[1].name
        o.specs = args[1].specs or {}
        o.files = args[1].files or {}
        o.games = args[1].games or {}
        o.softwares = args[1].softwares or {}
    end

    return o
end

return Harddrive
