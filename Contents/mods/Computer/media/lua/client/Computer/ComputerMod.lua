require("CommunityAPI")
require("ISBaseObject")
require("Computer/Managers/SoundManager")


-------------------------------------------------------------------------------------------------------

--- All Classes
local Classes = {
    ComputerAddon = require("Computer/ComputerAddon"),
    ComputerEvent = require("Computer/ComputerEvent"),

    BaseDrive = require("Computer/Classes/BaseDrive"),
    BaseHardware = require("Computer/Classes/BaseHardware"),
    BaseMedium = require("Computer/Classes/BaseMedium"),
    BiosSetting = require("Computer/Classes/BiosSetting"),
    Computer = require("Computer/Classes/Computer"),

    File = require("Computer/Classes/File"),
    Game = require("Computer/Classes/Game"),
    Software = require("Computer/Classes/Software"),

    Disc = require("Computer/Classes/Mediums/Disc"),
    Disc_Game = require("Computer/Classes/Mediums/Disc_Game"),
    Disc_Learning = require("Computer/Classes/Mediums/Disc_Learning"),
    Disc_Retail = require("Computer/Classes/Mediums/Disc_Retail"),
    Disc_Software = require("Computer/Classes/Mediums/Disc_Software"),

    Floppy = require("Computer/Classes/Mediums/Floppy"),
    Floppy_Game = require("Computer/Classes/Mediums/Floppy_Game"),
    Floppy_Learning = require("Computer/Classes/Mediums/Floppy_Learning"),
    Floppy_Software = require("Computer/Classes/Mediums/Floppy_Software"),

    Discdrive = require("Computer/Classes/Drives/Discdrive"),
    Floppydrive = require("Computer/Classes/Drives/Floppydrive"),
    Harddrive = require("Computer/Classes/Drives/Harddrive"),

    GraphicCard = require("Computer/Classes/Hardwares/GraphicCard"),
    NetworkCard = require("Computer/Classes/Hardwares/NetworkCard"),
    PowerSupply = require("Computer/Classes/Hardwares/PowerSupply"),
    Processor = require("Computer/Classes/Hardwares/Processor"),
    SoundCard = require("Computer/Classes/Hardwares/SoundCard"),
}

local HardwareTypes = {
    Processor = Classes.Processor,
    GraphicCard = Classes.GraphicCard,
    PowerSupply = Classes.PowerSupply,
    NetworkCard = Classes.NetworkCard,
    SoundCard = Classes.SoundCard,
}

local DriveTypes = {
    Harddrive = Classes.Harddrive,
    Discdrive = Classes.Discdrive,
    Floppydrive = Classes.Floppydrive,
}

local MediumTypes = {
    Disc = Classes.Disc,
    Disc_Game = Classes.Disc_Game,
    Disc_Learning = Classes.Disc_Learning,
    Disc_Retail = Classes.Disc_Retail,
    Disc_Software = Classes.Disc_Software,
    Floppy = Classes.Floppy,
    Floppy_Game = Classes.Floppy_Game,
    Floppy_Learning = Classes.Floppy_Learning,
    Floppy_Software = Classes.Floppy_Software,
}

--- Global ModData Object
---@type KahluaTable
local GlobalModData = ModData.get("ComputerMod")

--- Computer Addons
---@type ArrayList
local ComputerAddons = ArrayList.new()

--- Bios Settings Database
---@type table<string, BiosSetting>
local ComputerBiosSettings = {}

--- Game Formats Database
---@type table<string>
local GameFormats = {
    "All",
    "Disc_Game",
    "Floppy_Game",
}

--- Software Types Database
---@type table<string>
local SoftwareTypes = {}

--- Files Database
---@type table<string, File>
local ComputerFiles = {}

--- Games Database
---@type table<string, Game>
local ComputerGames = {}

--- Softwares Database
---@type table<string, Software>
local ComputerSoftwares = {}

--- All Computer Events
---@type table<string, ComputerEvent>
local ComputerEvents = {}

-------------------------------------------------------------------------------------------------------

-- TODO: AddHardwareType

---@return table<string, BaseHardware>
local function GetAllHardwareTypes()
    return HardwareTypes
end

---@param type string
---@return BaseHardware
local function GetHardwareType(type)
    return HardwareTypes[type]
end

-- TODO: AddDriveType

local function GetAllDriveTypes()
    return DriveTypes
end

---@param type string
local function GetDriveType(type)
    return DriveTypes[type]
end

-- TODO: AddMediumType

local function GetAllMediumTypes()
    return MediumTypes
end

---@param type string
local function GetMediumType(type)
    return MediumTypes[type]
end

--- EVENTS

---@param eventName string
---@param paramTypes table<string>
local function CreateEvent(eventName, paramTypes)
    if type(eventName) == "string" then
        if ComputerEvents[eventName] == nil then
            ComputerEvents[eventName] = Classes.ComputerEvent:new(paramTypes)
            print("ComputerMod: ComputerEvent '"..eventName.."' has been created!")
        else
            print("ComputerMod: ComputerEvent '"..eventName.."' already exist!")
        end
    end
end

---@param eventName string
---@param eventFunc function
local function AddEvent(eventName, eventFunc)
    if type(eventName) == "string" and type(eventFunc) == "function" and ComputerEvents[eventName] then
        ComputerEvents[eventName]:add(eventFunc)
    end
end

---@param eventName string
---@param eventFunc function
local function RemoveEvent(eventName, eventFunc)
    if type(eventName) == "string" and type(eventFunc) == "function" and ComputerEvents[eventName] then
        ComputerEvents[eventName]:remove(eventFunc)
    end
end

---@param eventName string
---@vararg any
local function TriggerEvent(eventName, ...)
    if type(eventName) == "string" and ComputerEvents[eventName] then
        --print("ComputerMod: Triggered Event '" .. eventName .. "'!")
        ComputerEvents[eventName]:trigger(eventName, ...)
    end
end

--- BIOS SETTINGS

---TO-DO: @vararg string
local function AddBiosSetting(...)
    local newSetting = Classes.BiosSetting:new(...)

    if not ComputerBiosSettings[string.lower(newSetting.key)] then
        newSetting.key = string.lower(newSetting.key) -- force lowercase key
        ComputerBiosSettings[newSetting.key] = newSetting
        print("ComputerMod: Added Bios setting '", newSetting.key, "' [", newSetting.name, "] default:(", newSetting.default, ") to database!")
    else
        print("ComputerMod: Bios setting '", newSetting.key, "' already exist in database!")
    end
end

---@return table<string, BiosSetting>
local function GetAllBiosSettings()
    return copyTable(ComputerBiosSettings)
end

---@param key string
---@return table
local function GetBiosSettingByKey(key)
    if type(key) == "string" and ComputerBiosSettings[string.lower(key)] then
        return copyTable(ComputerBiosSettings[string.lower(key)])
    end
end

--- GAME FORMATS

---@param gameFormat string
local function AddGameFormat(gameFormat)
    if type(gameFormat) == "string" then
        if CommunityAPI.Utils.Table.TableContains(GameFormats, string.lower(gameFormat)) then
            print("ComputerMod: GameFormat '" .. gameFormat .. "' already exist in database!")
            return
        end

        gameFormat = string.lower(gameFormat) -- force lowercase
        table.insert(GameFormats, gameFormat)
        print("ComputerMod: Added GameFormat '", gameFormat, "' to database!")
    end
end

---@return table
local function GetAllGameFormats()
    return copyTable(GameFormats)
end

--- SOFTWARE TYPES

---@param softwareType string
local function AddSoftwareType(softwareType)
    if type(softwareType) == "string" then
        if CommunityAPI.Utils.Table.TableContains(SoftwareTypes, string.lower(softwareType)) then
            print("ComputerMod: SoftwareType '" .. softwareType .. "' already exist in database!")
            return
        end

        softwareType = string.lower(softwareType) -- force lowercase
        table.insert(SoftwareTypes, softwareType)
        print("ComputerMod: Added SoftwareType '", softwareType, "' to database!")
    end
end

---@return table
local function GetAllSoftwareTypes()
    return copyTable(SoftwareTypes)
end

--- FILES

---@vararg string|table
---@return File|nil
local function AddFile(...)
    local file = Classes.File:new(...)
    if file then
        for i in ipairs(ComputerFiles) do
            if file.title == ComputerFiles[i].title and file.content == ComputerFiles[i].content then
                print("ComputerMod: File '" .. file.title .. "' already exist in database!")
                return
            end
        end

        table.insert(ComputerFiles, file)
        print("ComputerMod: Added File '" .. file.title .. "' to database!")
        return file
    end
end

---@param index number
---@return table
local function GetFileByIndex(index)
    if type(index) == "number" and ComputerFiles[index] then
        return copyTable(ComputerFiles[index])
    end
end

---@return table
local function GetAllFiles()
    return copyTable(ComputerFiles)
end

---@return File|nil
local function GetRandomFile()
    if #ComputerFiles > 0 then
        return GetFileByIndex(ZombRand(#ComputerFiles)+1)
    end
end

--- GAMES

---@vararg string|number|table
---@return Game|nil
local function AddGame(...)
    local game = Classes.Game:new(...)
    if game then
        if ComputerGames[string.lower(game.id)] ~= nil then
            print("ComputerMod: Game '" .. game.id .. "' already exist in database!")
            return
        end

        game.id = string.lower(game.id) -- force lowercase id
        ComputerGames[game.id] = game
        print("ComputerMod: Added Game '" .. game.id .. "' to database!")
        return game
    end
end

---@param id string
---@return Game|nil
local function GetGameById(id)
    if type(id) == "string" and ComputerGames[string.lower(id)] then
        return copyTable(ComputerGames[string.lower(id)])
    end
end

---@return table
local function GetAllGames()
    return copyTable(ComputerGames)
end

---@return Game|nil
local function GetRandomGame()
    local keys = {}
	for k in pairs(ComputerGames) do table.insert(keys, k); end
    if #keys > 0 then
        return GetGameById(keys[ZombRand(#keys+1)])
    end
end

--- SOFTWARE

---@vararg string|number|table
---@return Software|nil
local function AddSoftware(...)
    local software = Classes.Software:new(...)
    if software and ComputerSoftwares[string.lower(software.id)] == nil then
        if ComputerSoftwares[string.lower(software.id)] ~= nil then
            print("ComputerMod: Software '" .. software.id .. "' already exist in database!")
            return
        end

        software.id = string.lower(software.id) -- force lowercase id
        ComputerSoftwares[software.id] = software
        print("ComputerMod: Added Software '" .. software.id .. "' to database!")
        return software
    end
end

---@param id string
---@return Software|nil
local function GetSoftwareById(id)
    if type(id) == "string" and ComputerSoftwares[string.lower(id)] then
        return copyTable(ComputerSoftwares[string.lower(id)])
    end
end

---@return table
local function GetAllSoftwares()
    return copyTable(ComputerSoftwares)
end

---@return Software|nil
local function GetRandomSoftware()
    local keys = {}
	for k in pairs(ComputerSoftwares) do table.insert(keys, k); end
    if #keys > 0 then
        return GetSoftwareById(keys[ZombRand(#keys+1)])
    end
end

--- ADDONS

---@param name string
---@return ComputerAddon
local function CreateAddon(name)
    return Classes.ComputerAddon:new(name)
end

---@param addon ComputerAddon
---@return boolean
local function ValidateAddon(addon)
    if type(addon) == "table" and getmetatable(addon) == Classes.ComputerAddon then

        -- Validate ComputerEvents
        if addon.ComputerEvents then
            if type(addon.ComputerEvents) ~= "table" then
                error("ComputerMod: Addon '"..addon.name.."' .ComputerEvents must be a table!", 1);
            else
                for i=1, #addon.ComputerEvents do
                    if type(addon.ComputerEvents[i]) == "table" then
                        if type(addon.ComputerEvents[i][1]) == "string" then
                            Classes.ComputerEvent:new(addon.ComputerEvents[i][2])
                        else
                            error("ComputerMod: Addon '"..addon.name.."' .ComputerEvents entry first param must be a string!", 1);
                        end
                    else
                        error("ComputerMod: Addon '"..addon.name.."' .ComputerEvents entry must be a table!", 1);
                    end
                end
            end
        end

        -- Validate BiosSettings
        if addon.BiosSettings then
            if type(addon.BiosSettings) ~= "table" then
                error("ComputerMod: Addon '"..addon.name.."' .BiosSettings must be a table!", 1);
            else
                for i=1, #addon.BiosSettings do
                    Classes.BiosSetting:new(addon.BiosSettings[i])
                end
            end
        end

        -- Validate SoftwareTypes
        if addon.SoftwareTypes then
            if type(addon.SoftwareTypes) ~= "table" then
                error("ComputerMod: Addon '"..addon.name.."' .SoftwareTypes must be a table!", 1);
            else
                for i=1, #addon.SoftwareTypes do
                    if type(addon.SoftwareTypes[i]) ~= "string" then
                        error("ComputerMod: Addon '"..addon.name.."' software type must be a 'string' but got "..type(addon.SoftwareTypes[i]))
                    end
                end
            end
        end

        -- Validate FilePack
        if addon.FilePack then
            if type(addon.FilePack) ~= "table" then
                error("ComputerMod: Addon '"..addon.name.."' .FilePack must be a table!", 1);
            else
                for i=1, #addon.FilePack do
                    Classes.File:new(addon.FilePack[i])
                end
            end
        end

        -- Validate GamePack
        if addon.GamePack then
            if type(addon.GamePack) ~= "table" then
                error("ComputerMod: Addon '"..addon.name.."' .GamePack must be a table!", 1);
            else
                for i=1, #addon.GamePack do
                    Classes.Game:new(addon.GamePack[i])
                end
            end
        end

        -- Validate SoftwarePack
        if addon.SoftwarePack then
            if type(addon.SoftwarePack) ~= "table" then
                error("ComputerMod: Addon '"..addon.name.."' .SoftwarePack must be a table!", 1);
            else
                for i=1, #addon.SoftwarePack do
                    Classes.Software:new(addon.SoftwarePack[i])
                end
            end
        end

        -- Validate Start
        if addon.Start and type(addon.Start) ~= "function" then
            error("ComputerMod: Addon '"..addon.name.."' .Start must be a function!", 1);
        end

        -- Validate Update
        if addon.Update and type(addon.Update) ~= "function" then
            error("ComputerMod: Addon '"..addon.name.."' .Update must be a function!", 1);
        end

        return true
    else
        error("ComputerMod: Addon is not of class ComputerAddon!", 1);
    end
end

---@param addonName string
---@return boolean
local function RemoveAddonByName(addonName)
    if type(addonName) == "string" then
        local addon
        for i=0, ComputerAddons:size()-1 do
            local checkAddon = ComputerAddons:get(i)
            if checkAddon.name == addonName then
                addon = checkAddon
                break
            end
        end
        if addon then
            ComputerAddons:remove(addon)
            TriggerEvent("OnAddonRemoved", addon.name)
            print("ComputerMod: Removed addon '"..addon.name.."'!")
            return true
        end
    end
end

---@param addon ComputerAddon
local function AddAddon(addon)
    --- Validate
    if pcall(ValidateAddon, addon) then
        print("ComputerMod: Addon '"..addon.name.."' has been validated!")

        -- Check if an addon has the same name
        RemoveAddonByName(addon.name)

        ComputerAddons:add(addon)
        TriggerEvent("OnAddonAdded", addon.name)
        print("ComputerMod: Added addon '"..addon.name.."' successfully!")

        --if not pcall(RunAddon, addon) then
        --    print("ComputerMod: There was a problem running addon '"..addon.name.."'!")
        --end
    end
end

---@param addon ComputerAddon
local function RunAddon(addon)

    -- TODO: add custom hardware
    -- TODO: add custom drives
    -- TODO: add custom mediums

    if addon.ComputerEvents and #addon.ComputerEvents > 0 then
        print("ComputerMod: Addon '"..addon.name.."' is adding "..#addon.ComputerEvents.." ComputerEvents!")
        for i=1, #addon.ComputerEvents do
            CreateEvent(addon.ComputerEvents[i][1], addon.ComputerEvents[i][2])
        end
    end

    if addon.BiosSettings and #addon.BiosSettings > 0 then
        print("ComputerMod: Addon '"..addon.name.."' is adding "..#addon.BiosSettings.." BiosSettings!")
        for i=1, #addon.BiosSettings do
            AddBiosSetting(addon.BiosSettings[i])
        end
    end

    if addon.SoftwareTypes and #addon.SoftwareTypes > 0 then
        print("ComputerMod: Addon '"..addon.name.."' is adding "..#addon.SoftwareTypes.." SoftwareTypes!")
        for i=1, #addon.SoftwareTypes do
            AddSoftwareType(addon.SoftwareTypes[i])
        end
    end

    if addon.FilePack and #addon.FilePack > 0 then
        print("ComputerMod: Addon '"..addon.name.."' is adding "..#addon.FilePack.." Files!")
        for i=1, #addon.FilePack do
            AddFile(addon.FilePack[i])
        end
    end

    if addon.GamePack and #addon.GamePack > 0 then
        print("ComputerMod: Addon '"..addon.name.."' is adding "..#addon.GamePack.." Games!")
        for i=1, #addon.GamePack do
            AddGame(addon.GamePack[i])
        end
    end

    if addon.SoftwarePack and #addon.SoftwarePack > 0 then
        print("ComputerMod: Addon '"..addon.name.."' is adding "..#addon.SoftwarePack.." Softwares!")
        for i=1, #addon.SoftwarePack do
            AddSoftware(addon.SoftwarePack[i])
        end
    end

    if type(addon.Start) == "function" then
        print("ComputerMod: Executing addon "..addon.name.." Start()...")
        addon:Start()
    end
end

local function RunAllAddons()
    for i=0, ComputerAddons:size()-1 do
        local addon = ComputerAddons:get(i)
        print("ComputerMod: Addon '"..addon.name.."' is starting...")
        if not pcall(RunAddon, addon) then
            RemoveAddonByName(addon.name)
            print("ComputerMod: Addon "..addon.name.." error in Start(), addon has been disabled!")
        else
            print("ComputerMod: Addon '"..addon.name.."' has started successfully!")
        end
    end
end

local AddonTicks = 0
local function UpdateAllAddons()
    AddonTicks = AddonTicks + 1
    if AddonTicks > 60 then
        AddonTicks = 0
        for i=0, ComputerAddons:size()-1 do
            local addon = ComputerAddons:get(i)
            if type(addon.Update) == "function" then
                ---print("ComputerMod: Running addon "..addon.name.." Update()...")

                if not pcall(addon.Update, addon) then
                    RemoveAddonByName(addon.name)
                    print("ComputerMod: Addon "..addon.name.." error in Update(), addon has been disabled!")
                end
            end
        end
    end
end

--- COMPUTER

--- Get a Computer instance on this square
---@param square IsoGridSquare
---@return Computer|nil
local function GetComputerOnSquare(square)
    if square and instanceof(square, "IsoGridSquare") then
        local objects = square:getObjects()
        for i = 0, objects:size() - 1 do
            local object = objects:get(i)
            local computer = Classes.Computer:new(object)
            if computer then
                return computer
            end
        end
    end
end

--- Get a Computer instance at this position
---@param x number
---@param y number
---@param z number
---@return Computer|nil
local function GetComputerAtPosition(x, y, z)
    local square = getCell():getGridSquare(x, y, z)
    if square then
        return GetComputerOnSquare(square)
    end
end

--- Get a copy of all known computer locations database
---@return table
local function GetAllKnownComputerLocations()
    return copyTable(GlobalModData.computerLocations)
end

--- Get the power state of the computer at this position
---@param x number
---@param y number
---@param z number
---@return boolean
local function GetComputerStateAtPosition(x, y, z)
    local id = CommunityAPI.Utils.String.PositionToId(x, y, z)
    if id and GlobalModData.computerStateLocations then
        return GlobalModData.computerStateLocations[id]
    end
end

--- Set the power state of the computer at this position
---@param x number
---@param y number
---@param z number
---@param state boolean
local function SetComputerStateAtPosition(x, y, z, state)
    local id = CommunityAPI.Utils.String.PositionToId(x, y, z)
    if id and GlobalModData.computerStateLocations then
        GlobalModData.computerStateLocations[id] = state
    end
end

--- Get the power state of the computer on this square
---@param square IsoGridSquare
---@return boolean
local function GetComputerStateOnSquare(square)
    local id = CommunityAPI.Utils.String.SquareToId(square)
    if id and GlobalModData.computerStateLocations then
        return GlobalModData.computerStateLocations[id]
    end
end

--- Set the power state of the computer on this square
---@param square IsoGridSquare
---@param state boolean
local function SetComputerStateOnSquare(square, state)
    local id = CommunityAPI.Utils.String.SquareToId(square)
    if id and GlobalModData.computerStateLocations then
        GlobalModData.computerStateLocations[id] = state
    end
end

--- Add the computer to the known computer location database
---@param computer Computer
local function AddComputerLocation(computer)
    if type(computer) == "table" and getmetatable(computer) == Classes.Computer then
        local id = CommunityAPI.Utils.String.SquareToId(computer.square)
        if id and not GlobalModData.computerLocations[id] then
            local position = { x = computer.square:getX(), y = computer.square:getY(), z = computer.square:getZ() }
            GlobalModData.computerLocations[id] = position
            print("ComputerMod: Added Computer to ComputerLocations -> x:", position.x, " y:", position.y, " z:", position.z)
        end
    end
end

--- Remove the computer at this location from the known computer database
---@param x number
---@param y number
---@param z number
local function RemoveComputerLocation(x, y, z)
    local id = CommunityAPI.Utils.String.PositionToId(x, y, z)
    if id and GlobalModData.computerLocations[id] then
        GlobalModData.computerLocations[id] = nil
        print("ComputerMod: Removed Computer from ComputerLocations -> x:", x, " y:", y, " z:", z)
    end
end

--- CONTEXT MENU

---@param player number
---@param computerContext ISContextMenu
---@param computer Computer
local function ComputerPowerManagementMenu(player, computerContext, computer)
    local character = getSpecificPlayer(player)
    local square = computer:getSquareInFront()

    -- Computer State Management
    if computer:hasElectricity() then
        local option = computerContext:addOption("Power Management")
        local context = ISContextMenu:getNew(computerContext)

        local function optionToggleComputer(inBios)
            ISTimedActionQueue.add(ISWalkToTimedAction:new(character, square))
            ISTimedActionQueue.add(Computer_Action_ToggleComputer:new(player, computer, inBios, 20))
        end

        if computer:canBoot() then
            computerContext:addSubMenu(option, context)

            TriggerEvent("OnBeforeComputerPowerManagementContextMenu", player, context, computer)
            if computer:isOn() then
                context:addOption("Turn off", nil, optionToggleComputer)
            else
                context:addOption("Turn on", false, optionToggleComputer)
                context:addOption("Turn on into BIOS", true, optionToggleComputer)
            end
            TriggerEvent("OnAfterComputerPowerManagementContextMenu", player, context, computer)
        else
            if computer:isOn() then
                computer:toggleState(false, false)
            end
            option.notAvailable = true
            option.toolTip = ISToolTip:new()
            option.toolTip.name = "Missing Hardware"
            option.toolTip.description = "<RGB:1,0,0> All key hardware must be installed to start the computer!"
        end
    else
        local option = computerContext:addOption("Power Management")
        option.notAvailable = true
        option.toolTip = ISToolTip:new()
        option.toolTip.name = "Power Management"
        option.toolTip.description = "<RGB:1,0,0> Require a power source!"
    end
end

---@param player number
---@param computerContext ISContextMenu
---@param computer Computer
local function ComputerBiosManagementMenu(player, computerContext, computer)
    local option = computerContext:addOption("Bios Management")
    local context = ISContextMenu:getNew(computerContext)
    computerContext:addSubMenu(option, context)

    TriggerEvent("OnBeforeComputerBiosManagementContextMenu", player, context, computer)

    local function optionToggleBiosSetting(settingKey, settingValue)
        local character = getSpecificPlayer(player)
        local square = computer:getSquareInFront()
        ISTimedActionQueue.add(ISWalkToTimedAction:new(character, square))
        ISTimedActionQueue.add(Computer_Action_ToggleBiosSetting:new(player, computer, settingKey, settingValue, 40))
    end

    for _, biosSetting in pairs(ComputerBiosSettings) do
        if computer:getBiosValue(biosSetting.key) then
            local settingOption = context:addOption("Disable " .. biosSetting.name, biosSetting.key, optionToggleBiosSetting, false)
            if biosSetting.descriptionOn and biosSetting.descriptionOn ~= "" then
                settingOption.toolTip = ISToolTip:new()
                settingOption.toolTip.name = "Disable " .. biosSetting.name
                settingOption.toolTip.description = "<RGB:0.7,0.7,0.7> " .. biosSetting.descriptionOn
            end
        else
            local settingOption = context:addOption("Enable " .. biosSetting.name, biosSetting.key, optionToggleBiosSetting, true)
            if biosSetting.descriptionOff and biosSetting.descriptionOff ~= "" then
                settingOption.toolTip = ISToolTip:new()
                settingOption.toolTip.name = "Enable " .. biosSetting.name
                settingOption.toolTip.description = "<RGB:0.7,0.7,0.7> " .. biosSetting.descriptionOff
            end
        end
    end

    TriggerEvent("OnAfterComputerBiosManagementContextMenu", player, context, computer)
end

---@param player number
---@param computerContext ISContextMenu
---@param computer Computer
local function ComputerHardDriveManagementMenu(player, computerContext, computer)
    local harddrives = computer:getAllDriveOfType(Classes.Harddrive.Type)

    local option = computerContext:addOption("Hard Drives")

    if #harddrives > 0 then
        local context = ISContextMenu:getNew(computerContext)
        computerContext:addSubMenu(option, context)
        TriggerEvent("OnBeforeComputerHarddriveManagementContextMenu", player, context, computer)



        TriggerEvent("OnAfterComputerHarddriveManagementContextMenu", player, context, computer)
    else
        option.notAvailable = true
        option.toolTip = ISToolTip:new()
        option.toolTip.name = "Hard Drive"
        option.toolTip.description = "<RGB:1,0,0> No Hard Drive installed!"
    end
end

---@param player number
---@param computerContext ISContextMenu
---@param computer Computer
local function ComputerDiscDriveManagementMenu(player, computerContext, computer)
    local discdrives = computer:getAllDriveOfType(Classes.Discdrive.Type)

    local option = computerContext:addOption("Disc Drives")

    if #discdrives > 0 then
        local context = ISContextMenu:getNew(computerContext)
        computerContext:addSubMenu(option, context)
        TriggerEvent("OnBeforeComputerDiscdriveManagementContextMenu", player, context, computer)



        TriggerEvent("OnAfterComputerDiscdriveManagementContextMenu", player, context, computer)
    else
        option.notAvailable = true
        option.toolTip = ISToolTip:new()
        option.toolTip.name = "Disc Drive"
        option.toolTip.description = "<RGB:1,0,0> No Disc Drive installed!"
    end
end

---@param player number
---@param computerContext ISContextMenu
---@param computer Computer
local function ComputerFloppyDriveManagementMenu(player, computerContext, computer)
    local floppydrives = computer:getAllDriveOfType(Classes.Floppydrive.Type)

    local option = computerContext:addOption("Floppy Drives")

    if #floppydrives > 0 then
        local context = ISContextMenu:getNew(computerContext)
        computerContext:addSubMenu(option, context)
        TriggerEvent("OnBeforeComputerFloppydriveManagementContextMenu", player, context, computer)



        TriggerEvent("OnAfterComputerFloppydriveManagementContextMenu", player, context, computer)
    else
        option.notAvailable = true
        option.toolTip = ISToolTip:new()
        option.toolTip.name = "Floppy Drive"
        option.toolTip.description = "<RGB:1,0,0> No Floppy Drive installed!"
    end
end

---@param player number
---@param computerContext ISContextMenu
---@param computer Computer
local function ComputerHardwareManagementMenu(player, computerContext, computer)
    local character = getSpecificPlayer(player)
    local square = computer:getSquareInFront()

    local function optionOpenUi()
        ISTimedActionQueue.add(ISWalkToTimedAction:new(character, square))
        ISTimedActionQueue.add(Computer_Action_HardwareManagement:new(player, computer, 20))
    end

    local function optionResetComputer()
        computer:reset()
    end

    if computer:isOn() then
        local option = computerContext:addOption("Hardware Management")
        option.notAvailable = true
        option.toolTip = ISToolTip:new()
        option.toolTip.name = "Hardware Management"
        option.toolTip.description = "<RGB:1,0,0> Shutdown the computer to manage the hardware!"
    else
        computerContext:addOption("Hardware Management", nil, optionOpenUi)
    end
end

---@param player number
---@param context ISContextMenu
---@param computer Computer
local function FillComputerContextMenu(player, context, computer)
    local computerOption = context:addOption("Desktop Computer")
    local computerContext = ISContextMenu:getNew(context)
    context:addSubMenu(computerOption, computerContext)

    TriggerEvent("OnBeforeComputerContextMenu", player, computerContext, computer)

    ComputerPowerManagementMenu(player, computerContext, computer)

    if computer:isOn() then
        if computer:isBiosActive() then
            ComputerBiosManagementMenu(player, computerContext, computer)
        else
            ComputerHardDriveManagementMenu(player, computerContext, computer)
            ComputerDiscDriveManagementMenu(player, computerContext, computer)
            ComputerFloppyDriveManagementMenu(player, computerContext, computer)
        end
    end

    ComputerHardwareManagementMenu(player, computerContext, computer)

    TriggerEvent("OnAfterComputerContextMenu", player, computerContext, computer)
end

--- GAME EVENTS

local function AddTagsToBaseItems()
    local list = {
        { item = "Base.Disc", tags = { "ComputerMedium", "ComputerDisc" } },
        { item = "Base.Disc_Retail", tags = { "ComputerMedium", "ComputerDisc" } },
        --{ item = "Base.CarBattery1", tags = { "ComputerHardware", "ComputerBattery" } },
        --{ item = "Base.CarBattery2", tags = { "ComputerHardware", "ComputerBattery" } },
        --{ item = "Base.CarBattery3", tags = { "ComputerHardware", "ComputerBattery" } },
    }

    for _, entry in ipairs(list) do
        local item = getScriptManager():getItem(entry.item)
        if item then
            local tags = item:getTags()
            for i=1, #entry.tags do
                local tag = entry.tags[i]
                if not tags:contains(tag) then
                    tags:add(tag)
                end
            end
            print("ComputerMod: Set base item tags ["..entry.item.."] = ", item:getTags())
        end
    end
end

local function LoadGlobalModData()
    print("LoadGlobalModData")
    if not ModData.exists("ComputerMod") then
        ModData.create("ComputerMod")
        print("ComputerMod: Global mod data was created!")
    end

    GlobalModData = ModData.get("ComputerMod")
    if GlobalModData.computerLocations == nil then GlobalModData.computerLocations = {} end
    if GlobalModData.computerStateLocations == nil then GlobalModData.computerStateLocations = {} end

    print("ComputerMod: Global mod data has loaded!")
end

local function InitializeComputers()
    if not GlobalModData or not GlobalModData.computerLocations then return; end
    print("InitializeComputers")

    for key, _ in pairs(GlobalModData.computerLocations) do
        local position = GlobalModData.computerLocations[key]

        print("COMPUTER STATE at ", position.x, ":", position.y, ":", position.z, " = ", GetComputerStateAtPosition(position.x, position.y, position.z))

        -- Handle computer audio
        if GetComputerStateAtPosition(position.x, position.y, position.z) then
            CommunityAPI.Client.Light.AddLightAt("computer_screen", position.x, position.y, position.z, 2, { r=0.20, g=0.30, b=0.20 })
            CommunityAPI.Client.WorldSound.AddSoundAt("computer_ambiant", position.x, position.y, position.z, "ComputerHum")
        end
    end
end

---@type number
local ticks = 0;
local function UpdateComputers()
    ticks = ticks + 1
    if ticks > 10 then
        ticks = 0

        --- Start of Update

        ---@type table
        for key, _ in pairs(GlobalModData.computerLocations) do
            local position = GlobalModData.computerLocations[key]

            ---@type Computer|nil
            local computer = GetComputerAtPosition(position.x, position.y, position.z)

            -- Handle computer power
            if computer and computer:isOn() and not computer:hasElectricity() then
                computer:toggleState(false, true) -- set will auto restart
                print("ComputerMod: Computer at x:", position.x, " y:", position.y, " z:", position.z, " shut down no power!")

                -- Handle computer auto restart
            elseif computer and computer:isOff() and computer:isAutoRestarting() and computer:canBoot() then
                computer:toggleState()
                print("ComputerMod: Computer at x:", position.x, " y:", position.y, " z:", position.z, " auto restarted!")
            end
        end

        --- End of Update here
    end
end

---@param player number
---@param context ISContextMenu
local function OnPreFillWorldObjectContextMenu(player, context, _, test)
    if test == true then return end

    if clickedSquare == nil then return end

    ---@type IsoPlayer
    local character = getSpecificPlayer(player)

    if character:isDead() or character:isAsleep() or character:isDriving() then return end

    ---@type Computer|nil
    local computer = GetComputerOnSquare(clickedSquare)
    if computer then
        AddComputerLocation(computer)
        SetComputerStateOnSquare(computer.square, computer:isOn())
        FillComputerContextMenu(player, context, computer)
    end
end

--- Computer Debug Context
---@param player number
---@param context ISContextMenu
local function OnFillWorldObjectContextMenu(player, context, _, test)
    if test == true then return end

    if clickedSquare == nil then return end

    if isDebugEnabled() then

        ---@type IsoPlayer
        local character = getSpecificPlayer(player)

        ---@type ItemContainer
        local inventory = character:getInventory()

        local debugOption = context:addOption("[DEBUG] ComputerMod")
        local debugContext = ISContextMenu:getNew(context)
        context:addSubMenu(debugOption, debugContext)

        local computer = GetComputerOnSquare(clickedSquare)
        if computer then

            local rotateComputerOption = debugContext:addOption("Rotate computer")
            local rotateComputerContext = ISContextMenu:getNew(debugContext)
            debugContext:addSubMenu(rotateComputerOption, rotateComputerContext)
            function rotateComputer(direction)
                computer:rotate(direction)
            end
            rotateComputerContext:addOption("North", "N", rotateComputer)
            rotateComputerContext:addOption("East", "E", rotateComputer)
            rotateComputerContext:addOption("South", "S", rotateComputer)
            rotateComputerContext:addOption("West", "W", rotateComputer)

            -- Remove All Hardwares & Drives
            debugContext:addOption("Remove hardwares & drives", nil, function()
                if computer:isOn() then
                    computer:toggleState()
                end

                for slotKey, hardware in pairs(computer:getAllHardwares()) do
                    if hardware then
                        computer:uninstallHardwareItemFromSlot(inventory, slotKey)
                    end
                end

                local drives = computer:getAllDrives()
                for i=1, drives.count do
                    computer:uninstallDriveFromBayIndex(inventory, i)
                end
            end)

            debugContext:addOption("Reset computer", nil, function()
                computer:reset()
            end)

            debugContext:addOption("Delete computer", nil, function()
                triggerEvent("OnObjectAboutToBeRemoved", computer.isoObject)
                clickedSquare:transmitRemoveItemFromSquare(computer.isoObject)
                SetComputerStateOnSquare(clickedSquare, nil)
                RemoveComputerLocation(clickedSquare:getX(), clickedSquare:getY(), clickedSquare:getZ())
            end)

        else
            local createComputerOption = debugContext:addOption("Create computer on square")
            local createComputerContext = ISContextMenu:getNew(debugContext)
            debugContext:addSubMenu(createComputerOption, createComputerContext)
            function createComputer(direction)
                Classes.Computer.CreateComputer(clickedSquare, direction)
            end
            createComputerContext:addOption("North", "N", createComputer)
            createComputerContext:addOption("East", "E", createComputer)
            createComputerContext:addOption("South", "S", createComputer)
            createComputerContext:addOption("West", "W", createComputer)
        end

    end
end

--- Find all ComputerMedium in container when loot is spawning
---@param containerName string
---@param containerType string
---@param container ItemContainer
local function OnFillContainer(containerName, containerType, container)
    if instanceof(container, "ItemContainer") then
        local ComputerMediums = CommunityAPI.Utils.Inventory.FindAllItemInInventoryByTag(container, "ComputerMedium")
        if ComputerMediums and ComputerMediums:size() > 0 then
            for i=0, ComputerMediums:size()-1 do
                local item = ComputerMediums:get(i)
                print(oname, " ", otype, " ", item:getType())
            end
        end
    end
end

Events.OnGameStart.Add(AddTagsToBaseItems)
Events.OnGameStart.Add(LoadGlobalModData)
Events.OnGameStart.Add(InitializeComputers)
Events.OnGameStart.Add(RunAllAddons)
Events.OnTick.Add(UpdateComputers)
Events.OnTick.Add(UpdateAllAddons)
Events.OnPreFillWorldObjectContextMenu.Add(OnPreFillWorldObjectContextMenu)
Events.OnFillWorldObjectContextMenu.Add(OnFillWorldObjectContextMenu)
Events.OnFillContainer.Add(OnFillContainer)

--- COMPUTER EVENTS

CreateEvent("OnAddonAdded", { "string" })
CreateEvent("OnAddonRemoved", { "string" })

CreateEvent("OnComputerPickedUp", { "InventoryItem", "IsoGridSquare" })
CreateEvent("OnComputerPlacedDown", { "Computer" })

CreateEvent("OnComputerBeforeBoot", { "Computer", "boolean" })
CreateEvent("OnComputerBoot", { "Computer" })
CreateEvent("OnComputerBootInBios", { "Computer" })
CreateEvent("OnComputerAfterBoot", { "Computer" })

CreateEvent("OnComputerBeforeShutDown", { "Computer" })
CreateEvent("OnComputerShutDown", { "Computer" })

CreateEvent("OnComputerHardwareInstalled", { "Computer", "BaseHardware", "string" })
CreateEvent("OnComputerHardwareUninstalled", { "Computer", "BaseHardware", "string" })

CreateEvent("OnComputerDriveInstalled", { "Computer", "BaseDrive", "number" })
CreateEvent("OnComputerDriveUninstalled", { "Computer", "BaseDrive", "number" })

CreateEvent("OnComputerDiscInserted", { "Computer", "Discdrive", "Disc" })
CreateEvent("OnComputerDiscEjected", { "Computer", "Discdrive", "Disc" })

CreateEvent("OnComputerFloppyInserted", { "Computer", "Floppydrive", "Floppy" })
CreateEvent("OnComputerFloppyEjected", { "Computer", "Floppydrive", "Floppy" })

CreateEvent("OnBeforeComputerContextMenu", { "number", "ISContextMenu", "Computer" })
CreateEvent("OnAfterComputerContextMenu", { "number", "ISContextMenu", "Computer" })

CreateEvent("OnBeforeComputerPowerManagementContextMenu", { "number", "ISContextMenu", "Computer" })
CreateEvent("OnAfterComputerPowerManagementContextMenu", { "number", "ISContextMenu", "Computer" })

CreateEvent("OnBeforeComputerBiosManagementContextMenu", { "number", "ISContextMenu", "Computer" })
CreateEvent("OnAfterComputerBiosManagementContextMenu", { "number", "ISContextMenu", "Computer" })

CreateEvent("OnBeforeComputerHarddriveManagementContextMenu", { "number", "ISContextMenu", "Computer" })
CreateEvent("OnAfterComputerHarddriveManagementContextMenu", { "number", "ISContextMenu", "Computer" })

CreateEvent("OnBeforeComputerDiscdriveManagementContextMenu", { "number", "ISContextMenu", "Computer" })
CreateEvent("OnAfterComputerDiscdriveManagementContextMenu", { "number", "ISContextMenu", "Computer" })

CreateEvent("OnBeforeComputerFloppydriveManagementContextMenu", { "number", "ISContextMenu", "Computer" })
CreateEvent("OnAfterComputerFloppydriveManagementContextMenu", { "number", "ISContextMenu", "Computer" })

CreateEvent("OnBeforeComputerHardwareManagementContextMenu", { "number", "ISContextMenu", "Computer" })
CreateEvent("OnAfterComputerHardwareManagementContextMenu", { "number", "ISContextMenu", "Computer" })

CreateEvent("OnComputerFlagsChanged", { "Computer", "string", "any" })
CreateEvent("OnComputerBiosSettingChanged", { "Computer", "string", "any" })

---@param computer Computer
function OnComputerAfterBoot(computer)
    SetComputerStateOnSquare(computer.square, true)
end

---@param computer Computer
function OnComputerShutDown(computer)
    SetComputerStateOnSquare(computer.square, nil)
end

---@param square IsoGridSquare
function OnComputerPickedUp(_, square)
    SetComputerStateOnSquare(square, nil)
    RemoveComputerLocation(square:getX(), square:getY(), square:getZ())
end

---@param computer Computer
function OnComputerPlacedDown(computer)
    AddComputerLocation(computer)
    SetComputerStateOnSquare(computer.square, computer:isOn())
end

AddEvent("OnComputerAfterBoot", OnComputerAfterBoot)
AddEvent("OnComputerShutDown", OnComputerShutDown)
AddEvent("OnComputerPickedUp", OnComputerPickedUp)
AddEvent("OnComputerPlacedDown", OnComputerPlacedDown)

--- BIOS SETTINGS

AddBiosSetting("power_recovery", "Power Recovery", "Will not automatically restart when power becomes available.", "Will automatically restart when power becomes available.", false)
AddBiosSetting("enable_audio", "Audio", "Disable all computer audio.", "Enable all computer audio.", true)

--- SOFTWARE TYPES

AddSoftwareType("mail")
AddSoftwareType("text")
AddSoftwareType("audio")
AddSoftwareType("image")
AddSoftwareType("burner")
AddSoftwareType("browser")
AddSoftwareType("printer")

--- GLOBAL

---@class ComputerMod
ComputerMod = {}

ComputerMod.GetAllHardwareTypes = GetAllHardwareTypes
ComputerMod.GetHardwareType = GetHardwareType

ComputerMod.GetAllDriveTypes = GetAllDriveTypes
ComputerMod.GetDriveType = GetDriveType

ComputerMod.GetAllMediumTypes = GetAllMediumTypes
ComputerMod.GetMediumType = GetMediumType

ComputerMod.CreateAddon = CreateAddon
ComputerMod.AddAddon = AddAddon

ComputerMod.AddEvent = AddEvent
ComputerMod.RemoveEvent = RemoveEvent
ComputerMod.TriggerEvent = TriggerEvent

ComputerMod.GetAllBiosSettings = GetAllBiosSettings
ComputerMod.GetBiosSettingByKey = GetBiosSettingByKey

ComputerMod.GetAllGameFormats = GetAllGameFormats
ComputerMod.GetAllSoftwareTypes = GetAllSoftwareTypes

ComputerMod.GetFileByIndex = GetFileByIndex
ComputerMod.GetAllFiles = GetAllFiles
ComputerMod.GetRandomFile = GetRandomFile

ComputerMod.GetGameById = GetGameById
ComputerMod.GetAllGames = GetAllGames
ComputerMod.GetRandomGame = GetRandomGame

ComputerMod.GetSoftwareById = GetSoftwareById
ComputerMod.GetAllSoftwares = GetAllSoftwares
ComputerMod.GetRandomSoftware = GetRandomSoftware

ComputerMod.GetComputerOnSquare = GetComputerOnSquare
ComputerMod.GetComputerAtPosition = GetComputerAtPosition

ComputerMod.GetAllKnownComputerLocations = GetAllKnownComputerLocations

ComputerMod.GetComputerStateAtPosition = GetComputerStateAtPosition
ComputerMod.GetComputerStateOnSquare = GetComputerStateOnSquare