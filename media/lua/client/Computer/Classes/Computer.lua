require("ISBaseObject")
require("Computer/Managers/SoundManager")
require("Computer/Managers/LightManager")

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

---@alias moddata table<string, string|boolean|number|table>

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

---@param square IsoGridSquare
---@param direction string
---@return IsoObject|nil
function Computer.CreateComputer(square, direction)
    -- Check if there is a table
    local currentHeight = 0
    local obj = ISMoveableSpriteProps:getTopTable(square)
    if not obj then
        currentHeight = 0
    else
        local props = obj:getSprite():getProperties()
        currentHeight = obj:getRenderYOffset() + tonumber(props:Val("Surface"))
    end

    -- create the object
    local spriteName = ComputerSprites.Off[direction]
    local sprite = getSprite(spriteName)
    local props = sprite:getProperties()
    local isoObject = IsoObject.new(getCell(), square, sprite)
    if isoObject then
        isoObject:setRenderYOffset(currentHeight - tonumber(props:Val("Surface")))
        square:AddSpecialObject(isoObject, square:getObjects():size());
        if isClient() then isoObject:transmitCompleteItemToServer(); end
        triggerEvent("OnObjectAdded", isoObject)
        getTileOverlays():fixTableTopOverlays(square);
        square:RecalcProperties();
        square:RecalcAllWithNeighbours(true);
        print("Computer created!")
        return isoObject
    end
end

---@param direction string
function Computer:rotate(direction)
    if self:isOn() then
        self.isoObject:setSpriteFromName(ComputerSprites.On[direction])
    else
        self.isoObject:setSpriteFromName(ComputerSprites.Off[direction])
    end
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

---@return boolean
function Computer:canBoot()
    local hardwareTypes = ComputerMod.GetAllHardwareTypes()
    for _, hardwareType in pairs(hardwareTypes) do
        if hardwareType.SlotRequired then
            if not self:getHardwareInSlotKey(hardwareType.Type) then
                print("Missing a ", hardwareType.Type);
                return false
            end
        end
    end
    return self:hasElectricity()
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

        self:stopAudioEmitter()
        self:playAudio("ComputerBootEnd", "ComputerBootEnd", true)
        self:setLightState(false)

        ComputerMod.TriggerEvent("OnComputerShutDown", self)

    -- power on
    elseif self:canBoot() then
        ComputerMod.TriggerEvent("OnComputerBeforeBoot", self, inBios)
        self:setFlag("bios_active", inBios)
        self:setFlag("auto_restart", false)

        self:stopAudioEmitter()
        self:playAudio({"ComputerBootStart", "ComputerHum"}, true)

        self.isoObject:setSpriteFromName(ComputerSprites.On[facing])
        self:setLightState(true)

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
    return self.square ~= nil and self.square:haveElectricity() == true
end

---@return boolean
function Computer:isOnGround()
    return self.isoObject ~= nil and self.isoObject:getRenderYOffset() < 0
end

---@return boolean
function Computer:exist()
    return ComputerMod.GetComputerAtPosition(self.position.x, self.position.y, self.position.z) ~= nil
end

function Computer:setLightState(state)
    if state then
        LightManager.AddLightAt("computer", self.position.x, self.position.y, self.position.z, 2)
    else
        LightManager.RemoveLightAt("computer", self.position.x, self.position.y, self.position.z)
    end
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
    if self:isOn() then
        self:toggleState(false, false)
    end
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
        for _, biosSetting in pairs(ComputerMod.GetAllBiosSettings()) do
            modData.data.bios[biosSetting.key] = biosSetting.default
            print("Setting bios setting '", biosSetting.key, "' to default '", biosSetting.default, "'!")
        end
    end
    -- data.hardwares
    if modData.data.hardwares == nil then
        print("- Settings default hardwares slots...")
        modData.data.hardwares = { }
    end
    -- data.drives
    if not modData.data.drives or not modData.data.drives.count then
        print("- Settings default drives bays...")
        modData.data.drives = { count = 6 }
    end
    return modData.data
end

--- FLAGS

---@return moddata
function Computer:getFlags()
    return copyTable(self:getData().flags)
end

---@param key string
---@return string|boolean|number|table
function Computer:getFlag(key)
    if type(key) == "string" then
        local flags = self:getFlags()
        return flags[string.lower(key)]
    end
end

---@param key string
---@param value string|boolean|number|table
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
---@return string|boolean|number
function Computer:getBiosValue(key)
    if type(key) == "string" then
        key = string.lower(key) -- force lowercase
        local bios = self:getBios()
        local value = bios[key]
        if value == nil then
            local setting = ComputerMod.GetBiosSettingByKey(key)
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

--- HARDWARES

---@return moddata
function Computer:getAllHardwares()
    return self:getData().hardwares
end

---@param slotKey number
---@return BaseHardware|nil
function Computer:getHardwareInSlotKey(slotKey)
    local hardwareData = self:getData().hardwares[slotKey]
    if hardwareData then
        local hardwareType = ComputerMod.GetHardwareType(hardwareData.hardwareType)
        if hardwareType then
            return hardwareType:new(hardwareData)
        end
    end
end

---@param hardwareType string
---@return table
function Computer:getAllHardwareOfType(hardwareType)
    local foundHardwares = {}
    for k, _ in pairs(self:getAllHardwares()) do
        local hardware = self:getHardwareInSlotKey(k)
        if hardware and hardware.Type == hardwareType then
            table.insert(foundHardwares, hardware)
        end
    end
    return foundHardwares
end

---@param inventory ItemContainer
---@param item InventoryItem
---@return boolean
function Computer:installHardwareItemInSlot(inventory, item)
    if instanceof(inventory, "ItemContainer") and instanceof(item, "InventoryItem") then
        local hardwareType = ComputerMod.GetHardwareType(item:getType())
        if hardwareType then
            local hardware = hardwareType:new(item)
            if hardware then
                local hardwares = self:getAllHardwares()
                hardwares[hardware.Type] = hardware
                inventory:Remove(item)
                print("Installed "..hardware.name.." into slot " .. hardware.Type)
                ComputerMod.TriggerEvent("OnComputerHardwareInstalled", self, hardware, hardware.Type)
                return true
            end
        end
    end
end

---@param inventory ItemContainer
---@param slotKey string
---@return boolean
function Computer:uninstallHardwareItemFromSlot(inventory, slotKey)
    local hardware = self:getHardwareInSlotKey(slotKey)
    if instanceof(inventory, "ItemContainer") and hardware then
        local item = hardware:createItem(inventory)
        if item then
            local hardwares = self:getAllHardwares()
            hardwares[slotKey] = nil
            print("Uninstalled "..hardware.name.." from bay " .. hardware.Type)
            ComputerMod.TriggerEvent("OnComputerHardwareUninstalled", self, hardware, hardware.Type)
            return true
        end
    end
end

--- DRIVES

---@return moddata
function Computer:getAllDrives()
    return self:getData().drives
end

---@param bayIndex number
---@return BaseDrive|nil
function Computer:getDriveInBayIndex(bayIndex)
    local driveData = self:getData().drives[bayIndex]
    if driveData then
        local driveType = ComputerMod.GetDriveType(driveData.hardwareType)
        if driveType then
            return driveType:new(driveData)
        end
    end
end

---@param driveType string
---@return table
function Computer:getAllDriveOfType(driveType)
    local foundDrives = {}
    local drives = self:getAllDrives()
    for i=1, drives.count do
        local drive = self:getDriveInBayIndex(i)
        if drive and drive.Type == driveType then
            table.insert(foundDrives, drive)
        end
    end
    return foundDrives
end

---@param inventory ItemContainer
---@param item InventoryItem
---@param bayIndex number
---@return boolean
function Computer:installDriveItemInBayIndex(inventory, item, bayIndex)
    if instanceof(inventory, "ItemContainer") and instanceof(item, "InventoryItem") then
        local driveType = ComputerMod.GetDriveType(item:getType())
        if driveType then
            local drive = driveType:new(item)
            if drive then
                local drives = self:getAllDrives()
                drives[bayIndex] = drive
                inventory:Remove(item)
                print("Installed "..drive.name.." into bay " .. bayIndex)
                ComputerMod.TriggerEvent("OnComputerDriveInstalled", self, drive, bayIndex)
                return true
            end
        end
    end
end

---@param inventory ItemContainer
---@param bayIndex number
---@return boolean
function Computer:uninstallDriveFromBayIndex(inventory, bayIndex)
    local drive = self:getDriveInBayIndex(bayIndex)
    if instanceof(inventory, "ItemContainer") and drive then
        local item = drive:createItem(inventory)
        if item then
            local drives = self:getAllDrives()
            drives[bayIndex] = nil
            print("Uninstalled "..drive.name.." from bay " .. bayIndex)
            ComputerMod.TriggerEvent("OnComputerDriveUninstalled", self, drive, bayIndex)
            return true
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
    return not self:getBiosValue("enable_audio") and not self:getHardwareInSlotKey("SoundCard")
end

---@return SoundInstance
function Computer:getAudioEmitter()
    return SoundManager.GetSoundAt("computer", self.position.x, self.position.y, self.position.z)
end

---@param audioName string
---@return boolean
function Computer:isAudioPlaying(audioName)
    local sound = SoundManager.GetSoundAt(audioName, self.position.x, self.position.y, self.position.z)
    if sound then
        return sound:isPlaying()
    end
end

---@param soundList string|table<string>
---@param isAmbiant boolean
---@return SoundInstance|nil
function Computer:playAudio(soundList, isAmbiant)
    if not isAmbiant and self:isAudioDisabled() then return end
    return SoundManager.PlaySoundAt("computer", soundList, self.position.x, self.position.y, self.position.z)
end

function Computer:stopAudioEmitter()
    SoundManager.StopSoundAt("computer", self.position.x, self.position.y, self.position.z)
end

--- CONSTRUCTOR

---@param isoObject IsoObject
---@return Computer|nil
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
