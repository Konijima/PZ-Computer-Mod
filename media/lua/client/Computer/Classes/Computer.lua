require("ISBaseObject")
require("Computer/Audio/SoundManager")

local Harddrive = require("Computer/Classes/Harddrive")
local Discdrive = require("Computer/Classes/Discdrive")
local Floppydrive = require("Computer/Classes/Floppydrive")

local ComputerSprites = {
    On = {
        S = "appliances_com_01_76",
        E = "appliances_com_01_77",
        N = "appliances_com_01_78",
        W = "appliances_com_01_79",
    },
    Off = {
        S = "appliances_com_01_72",
        E = "appliances_com_01_73",
        N = "appliances_com_01_74",
        W = "appliances_com_01_75",
    }
}

---@alias moddata table<string, string | boolean | number | table>

---@class Computer
local Computer = ISBaseObject:derive("Computer")

---@return table
function Computer.GetSprites()
    return copyTable(ComputerSprites)
end

---@param spriteName string
---@return boolean
function Computer.IsSpriteOn(spriteName)
    if spriteName == ComputerSprites.On.S or spriteName == ComputerSprites.On.E or spriteName == ComputerSprites.On.N or spriteName == ComputerSprites.On.W then
        return true
    end
end

---@param spriteName string
---@return boolean
function Computer.IsSpriteOff(spriteName)
    if spriteName == ComputerSprites.Off.S or spriteName == ComputerSprites.Off.E or spriteName == ComputerSprites.Off.N or spriteName == ComputerSprites.Off.W then
        return true
    end
end

---@param spriteName string
---@return boolean
function Computer.IsSpriteComputer(spriteName)
    return Computer.IsSpriteOn(spriteName) or Computer.IsSpriteOff(spriteName)
end

---@return table<string, number>
function Computer:getPosition()
    return { x = self.square:getX(), y = self.square:getY(), z = self.square:getZ() }
end

---@return boolean
function Computer:isOn()
    if self.isoObject then
        local spriteName = self.isoObject:getSprite():getName()
        return Computer.IsSpriteOn(spriteName)
    end
end

---@return boolean
function Computer:isOff()
    if self.isoObject then
        local spriteName = self.isoObject:getSprite():getName()
        return Computer.IsSpriteOff(spriteName)
    end
end

---@return boolean
function Computer:isComputerSprite()
    if self:isOn() or self:isOff() then
        return true
    end
end

---@return string
function Computer:getFacing()
    local spriteName = self.isoObject:getSprite():getName()
    if spriteName == ComputerSprites.On.S or spriteName == ComputerSprites.Off.S then
        return "S"
    end
    if spriteName == ComputerSprites.On.E or spriteName == ComputerSprites.Off.E then
        return "E"
    end
    if spriteName == ComputerSprites.On.N or spriteName == ComputerSprites.Off.N then
        return "N"
    end
    if spriteName == ComputerSprites.On.W or spriteName == ComputerSprites.Off.W then
        return "W"
    end
end

---@param inBios boolean
---@param autoRestart boolean
function Computer:toggleState(inBios, autoRestart)
    if type(inBios) ~= "boolean" then inBios = false end
    if type(autoRestart) ~= "boolean" then autoRestart = false end

    local facing = self:getFacing()
    -- power off
    if self:isOn() then
        ComputerMod.TriggerEvent("OnComputerBeforeShutDown", self)
        self:setFlag("bios_active", false)
        self:setFlag("auto_restart", autoRestart)

        self.isoObject:setSpriteFromName(ComputerSprites.Off[facing])

        self:stopAllAudio()
        self:playAudio("ComputerBootEnd", false, true)

        ComputerMod.TriggerEvent("OnComputerShutDown", self)

    -- power on
    elseif (self:hasElectricity()) then
        ComputerMod.TriggerEvent("OnComputerBeforeBoot", self, inBios)
        self:setFlag("bios_active", inBios)
        self:setFlag("auto_restart", false)

        self:stopAllAudio()
        local position = self.position
        self:playAudio("ComputerBootStart", false, true, function()
            SoundManager.PlaySoundAt("ComputerHum", position.x, position.y, position.z, true)
        end)

        self.isoObject:setSpriteFromName(ComputerSprites.On[facing])

        if self:getFlag("bios_active") then
            ComputerMod.TriggerEvent("OnComputerBootInBios", self)
        else
            --self:playAudio("ComputerStartupMusic", false, false)
            ComputerMod.TriggerEvent("OnComputerBoot", self)
        end

        ComputerMod.TriggerEvent("OnComputerAfterBoot", self)
    end
end

---@return boolean
function Computer:hasElectricity()
    return self.square:haveElectricity()
end

---@return IsoGridSquare
function Computer:getSquareInFront()
    local frontSquare
    local x = self.square:getX()
    local y = self.square:getY()
    local z = self.square:getZ()
    local facing = self:getFacing()
    if facing == "S" then
        frontSquare = getCell():getGridSquare(x,y+1,z);
    elseif facing == "E" then
        frontSquare = getCell():getGridSquare(x+1,y,z);
    elseif facing == "N" then
        frontSquare = getCell():getGridSquare(x,y-1,z);
    elseif facing == "W" then
        frontSquare = getCell():getGridSquare(x-1,y,z);
    end
    return frontSquare
end

--- MODDATA

function Computer:reset()
    if not self.isoObject then return end
    local modData = self.isoObject:getModData()
    modData.data = nil
    print("Computer has been resetted!")
end

---@return moddata
function Computer:getData()
    if not self.isoObject then return end
    local modData = self.isoObject:getModData()
    -- data
    if not modData.data then
        modData.data = { }
        print("New computer found:")
    end
    -- data.flags
    if not modData.data.flags then
        print("- Settings default flags...")
        modData.data.flags = {
            bios_active = false,
            auto_restart = false,
        }
    end
    -- data.bios
    if not modData.data.bios then
        modData.data.bios = { }
        print("- Settings default bios settings...")
        for _, biosSetting in pairs(ComputerMod.GetAllBiosToggleSettings()) do
            modData.data.bios[biosSetting.key] = biosSetting.default
            print("Setting bios setting '", biosSetting.key, "' to default '", biosSetting.default, "'!")
        end
    end
    -- data.drives
    if not modData.data.drives or not modData.data.drives.count then
        print("- Settings default drives slots...")
        modData.data.drives = {
            count = 6,
        }
    end
    return modData.data
end

--- FLAGS

---@return table
function Computer:getFlags()
    return copyTable(self:getData().flags)
end

---@param key string
---@return string | boolean | number
function Computer:getFlag(key)
    if type(key) == "string" then
        local flags = self:getFlags()
        return flags[string.lower(key)]
    end
end

---@param key string
---@param value string | boolean | number | table
function Computer:setFlag(key, value)
    if type(key) == "string" then
        self:getData().flags[string.lower(key)] = value
    end
end

--- BIOS

---@return moddata
function Computer:getBios()
    return copyTable(self:getData().bios)
end

---@param key string
---@return string | boolean | number
function Computer:getBiosValue(key)
    if type(key) == "string" then
        key = string.lower(key) -- force lowercase
        local bios = self:getBios()
        local value = bios[key]
        if value == nil then
            local setting = ComputerMod.GetBiosToggleSettingByKey(key)
            if setting then
                value = setting.default
            end
        end
        return value
    end
end

---@param key string
---@param value boolean
function Computer:setBiosValue(key, value)
    if type(key) == "string" and type(value) == "boolean" then
        key = string.lower(key) -- force lowercase
        local previousValue = self:getBiosValue(key)
        self:getData().bios[key] = value
        if previousValue ~= value then
            print("ComputerMod: Bios setting ", key, " changed to ", value, "!")
            ComputerMod.TriggerEvent("OnComputerBiosSettingChanged", self, key, value)
        end
    end
end

---@return boolean
function Computer:isBiosActive()
    return self:isOn() and self:getFlag("bios_active")
end

--- DRIVES

---@return moddata
function Computer:getAllDrives()
    return self:getData().drives
end

---@param bayIndex number
---@return Harddrive | Discdrive | Floppydrive
function Computer:getDriveInBayIndex(bayIndex)
    local drives = self:getAllDrives()
    local drive = drives[bayIndex]
    if type(drive) == "table" and getmetatable(drive) == nil then
        if drive.type == "Harddrive" then drive = Harddrive:new(drive) end
        if drive.type == "Discdrive" then drive = Discdrive:new(drive) end
        if drive.type == "Floppydrive" then drive = Floppydrive:new(drive) end
    end
    return drive
end

---@return table<Harddrive>
function Computer:getAllHarddrives()
    local drives = self:getAllDrives()
    local harddrives = {}
    for i=1, drives.count do
        local drive = self:getDriveInBayIndex(i)
        if drive and drive.type == "Harddrive" then
            table.insert(harddrives, drive)
        end
    end
    return harddrives
end

---@return table<Discdrive>
function Computer:getAllDiscdrives()
    local drives = self:getAllDrives()
    local discdrives = {}
    for i=1, drives.count do
        local drive = self:getDriveInBayIndex(i)
        if drive and drive.type == "Discdrive" then
            table.insert(discdrives, drive)
        end
    end
    return discdrives
end

---@return table<Floppydrive>
function Computer:getAllFloppydrives()
    local drives = self:getAllDrives()
    local floppydrives = {}
    for i=1, drives.count do
        local drive = self:getDriveInBayIndex(i)
        if drive and drive.type == "Floppydrive" then
            table.insert(floppydrives, drive)
        end
    end
    return floppydrives
end

---@param inventory ItemContainer
---@param item InventoryItem
---@param bayIndex number
function Computer:installDriveItemInBayIndex(inventory, item, bayIndex)
    local drive

    if item then

        local itemType = item:getType()
        if itemType == "Harddrive" then
            drive = Harddrive:new(item)
        elseif itemType == "Discdrive" then
            drive = Discdrive:new(item)
        elseif itemType == "Floppydrive" then
            drive = Floppydrive:new(item)
        end

        if drive then
            local drives = self:getAllDrives()
            drives[bayIndex] = drive
            inventory:Remove(item)
            print("Installed "..drive.type.." into bay " .. bayIndex)

            if drive.type == "Harddrive" then
                ComputerMod.TriggerEvent("OnComputerHarddriveInstalled", self, drive, bayIndex)
            elseif drive.type == "Discdrive" then
                ComputerMod.TriggerEvent("OnComputerDiscdriveInstalled", self, drive, bayIndex)
            elseif drive.type == "Floppydrive" then
                ComputerMod.TriggerEvent("OnComputerFloppydriveInstalled", self, drive, bayIndex)
            end
        end

    end
end

---@param inventory ItemContainer
---@param bayIndex number
function Computer:uninstallDriveFromBayIndex(inventory, bayIndex)
    local drives = self:getAllDrives()
    local drive = self:getDriveInBayIndex(bayIndex)
    if drive then
        local item = drive:createItem(inventory)
        if item then
            drives[bayIndex] = nil
            print("Uninstalled "..drive.type.." from bay " .. bayIndex)
            if drive.type == "Harddrive" then
                ComputerMod.TriggerEvent("OnComputerHarddriveUninstalled",self, drive, bayIndex)
            elseif drive.type == "Discdrive" then
                ComputerMod.TriggerEvent("OnComputerDiscdriveUninstalled", self, drive, bayIndex)
            elseif drive.type == "Floppydrive" then
                ComputerMod.TriggerEvent("OnComputerFloppydriveUninstalled", self, drive, bayIndex)
            end
        end
    end
end

--- MISCS

---@return boolean
function Computer:isAutoRestarting()
    return self:getFlag("auto_restart") and self:getBiosValue("power_recovery")
end

--- AUDIOS

---@return boolean
function Computer:isAudioDisabled()
    return not self:getBiosValue("enable_audio")
end

---@param audioName string
---@return Sound
function Computer:getAudio(audioName)
    return SoundManager.GetSoundAt(audioName, self.position.x, self.position.y, self.position.z)
end

---@param audioName string
---@return boolean
function Computer:isAudioPlaying(audioName)
    return SoundManager.IsSoundPlayingAt(audioName, self.position.x, self.position.y, self.position.z)
end

---@param audioName string
---@param loop boolean
---@param isAmbiant boolean
---@param onCompleted function | nil
---@return Sound | nil
function Computer:playAudio(audioName, loop, isAmbiant, onCompleted)
    if not isAmbiant and self:isAudioDisabled() then return end
    return SoundManager.PlaySoundAt(audioName, self.position.x, self.position.y, self.position.z, loop, onCompleted)
end

---@param audioName string
function Computer:stopAudio(audioName)
    SoundManager.StopSoundAt(audioName, self.position.x, self.position.y, self.position.z)
end

function Computer:stopAllAudio()
    SoundManager.StopAllSoundsAt(self.position.x, self.position.y, self.position.z)
end

--- CONSTRUCTOR

---@param isoObject IsoObject
---@return Computer
function Computer:new(isoObject)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self

    --- Properties
    if instanceof(isoObject, "IsoObject") then
        o.isoObject = isoObject
        o.square = isoObject:getSquare()
        if o:isComputerSprite() then
            o.position = o:getPosition()
            o:getData()
            return o
        end
    end
    return nil
end

return Computer
