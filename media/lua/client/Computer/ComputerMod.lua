require("ISBaseObject")
require("Computer/ComputerUtils")

-------------------------------------------------------------------------------------------------------

--- All Classes
---@type table<string, any>
local Classes = {
    ComputerAddon = require("Computer/ComputerAddon"),
    ComputerEvent = require("Computer/ComputerEvent"),

    --- Computer Objects
    BiosSetting = require("Computer/Classes/BiosSetting"),
    Computer = require("Computer/Classes/Computer"),
    Disc = require("Computer/Classes/Disc"),
    Discdrive = require("Computer/Classes/Discdrive"),
    File = require("Computer/Classes/File"),
    Floppy = require("Computer/Classes/Floppy"),
    Floppydrive = require("Computer/Classes/Floppydrive"),
    Game = require("Computer/Classes/Game"),
    Harddrive = require("Computer/Classes/Harddrive"),
    Software = require("Computer/Classes/Software"),
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
local GameFormats = {}

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

--- EVENTS

---@param eventName string
---@vararg string
---@return void
local function CreateEvent(eventName, ...)
    if type(eventName) == "string" and not ComputerEvents[eventName] then
        ComputerEvents[eventName] = Classes.ComputerEvent:new(...)
    end
end

---@param eventName string
---@param eventFunc function
---@return void
local function AddEvent(eventName, eventFunc)
    if type(eventName) == "string" and type(eventFunc) == "function" and ComputerEvents[eventName] then
        ComputerEvents[eventName]:add(eventFunc)
    end
end

---@param eventName string
---@param eventFunc function
---@return void
local function RemoveEvent(eventName, eventFunc)
    if type(eventName) == "string" and type(eventFunc) == "function" and ComputerEvents[eventName] then
        ComputerEvents[eventName]:remove(eventFunc)
    end
end

---@param eventName string
---@vararg any
---@return void
local function TriggerEvent(eventName, ...)
    if type(eventName) == "string" and ComputerEvents[eventName] then
        --print("ComputerMod: Triggered Event '" .. eventName .. "'!")
        ComputerEvents[eventName]:trigger(eventName, ...)
    end
end

--- BIOS SETTINGS

---TO-DO: @vararg string
---@return void
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
---@return void
local function AddGameFormat(gameFormat)
    if type(gameFormat) == "string" then
        if ComputerUtils.tableContains(GameFormats, string.lower(gameFormat)) then
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
---@return void
local function AddSoftwareType(softwareType)
    if type(softwareType) == "string" then
        if ComputerUtils.tableContains(SoftwareTypes, string.lower(softwareType)) then
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

---@vararg string | table
---@return File | nil
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

---@return File | nil
local function GetRandomFile()
    if #ComputerFiles > 0 then
        return GetFileByIndex(ZombRand(#ComputerFiles)+1)
    end
end

--- GAMES

---@vararg string | number | table
---@return Game | nil
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
---@return Game | nil
local function GetGameById(id)
    if type(id) == "string" and ComputerGames[string.lower(id)] then
        return copyTable(ComputerGames[string.lower(id)])
    end
end

---@return table
local function GetAllGames()
    return copyTable(ComputerGames)
end

---@return Game | nil
local function GetRandomGame()
    local keys = {}
	for k in pairs(ComputerGames) do table.insert(keys, k); end
    if #keys > 0 then
        return GetGameById(keys[ZombRand(#keys+1)])
    end
end

--- SOFTWARE

---@vararg string | number | table
---@return Software | nil
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
---@return Software | nil
local function GetSoftwareById(id)
    if type(id) == "string" and ComputerSoftwares[string.lower(id)] then
        return copyTable(ComputerSoftwares[string.lower(id)])
    end
end

---@return table
local function GetAllSoftwares()
    return copyTable(ComputerSoftwares)
end

---@return Software | nil
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

        if ComputerAddons:contains(addon) then
            error("ComputerMod: Addon '"..addon.addonName.."' was already added!", 1);
        end

        if addon.BiosSettings and type(addon.BiosSettings) ~= "table" then
            error("ComputerMod: Addon '"..addon.addonName.."' .BiosSettings must be a table!", 1);
        end

        if addon.GameFormats and type(addon.GameFormats) ~= "table" then
            error("ComputerMod: Addon '"..addon.addonName.."' .GameFormats must be a table!", 1);
        end

        if addon.SoftwareTypes and type(addon.SoftwareTypes) ~= "table" then
            error("ComputerMod: Addon '"..addon.addonName.."' .SoftwareTypes must be a table!", 1);
        end

        if addon.FilePack and type(addon.FilePack) ~= "table" then
            error("ComputerMod: Addon '"..addon.addonName.."' .FilePack must be a table!", 1);
        end

        if addon.GamePack and type(addon.GamePack) ~= "table" then
            error("ComputerMod: Addon '"..addon.addonName.."' .GamePack must be a table!", 1);
        end

        if addon.SoftwarePack and type(addon.SoftwarePack) ~= "table" then
            error("ComputerMod: Addon '"..addon.addonName.."' .SoftwarePack must be a table!", 1);
        end

        return true
    else
        error("ComputerMod: Addon is not of class ComputerAddon!", 1);
    end
end

---@param addon ComputerAddon
---@return void
local function RunAddon(addon)
    if addon.BiosSettings then
        for i=1, #addon.BiosSettings do
            AddBiosSetting(addon.BiosSettings[i])
        end
    end

    if addon.GameFormats then
        for i=1, #addon.GameFormats do
            AddGameFormat(addon.GameFormats[i])
        end
    end

    if addon.SoftwareTypes then
        for i=1, #addon.SoftwareTypes do
            AddSoftwareType(addon.SoftwareTypes[i])
        end
    end

    if addon.FilePack then
        for i=1, #addon.FilePack do
            AddFile(addon.FilePack[i])
        end
    end

    if addon.GamePack then
        for i=1, #addon.GamePack do
            AddGame(addon.GamePack[i])
        end
    end

    if addon.SoftwarePack then
        for i=1, #addon.SoftwarePack do
            AddSoftware(addon.SoftwarePack[i])
        end
    end
end

---@param addon ComputerAddon
---@return void
local function AddAddon(addon)
    --- Validate
    if pcall(ValidateAddon, addon) then
        if not pcall(RunAddon, addon) then
            print("ComputerMod: There was a problem running addon '"..addon.addonName.."'!")
        else
            ComputerAddons:add(addon)
            print("ComputerMod: Added addon '"..addon.addonName.."'!")
        end
    end
end

--- COMPUTER

--- Get a Computer isntance on this square
---@param square IsoGridSquare
---@return Computer | nil
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
---@return Computer | nil
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
    local id = ComputerUtils.positionToId(x, y, z)
    if id and GlobalModData.computerStateLocations then
        return GlobalModData.computerStateLocations[id]
    end
end

--- Set the power state of the computer at this position
---@param x number
---@param y number
---@param z number
---@param state boolean
---@return void
local function SetComputerStateAtPosition(x, y, z, state)
    local id = ComputerUtils.positionToId(x, y, z)
    if id and GlobalModData.computerStateLocations then
        GlobalModData.computerStateLocations[id] = state
    end
end

--- Get the power state of the computer on this square
---@param square IsoGridSquare
---@return boolean
local function GetComputerStateOnSquare(square)
    local id = ComputerUtils.squareToId(square)
    if id and GlobalModData.computerStateLocations then
        return GlobalModData.computerStateLocations[id]
    end
end

--- Set the power state of the computer on this square
---@param square IsoGridSquare
---@param state boolean
---@return void
local function SetComputerStateOnSquare(square, state)
    local id = ComputerUtils.squareToId(square)
    if id and GlobalModData.computerStateLocations then
        GlobalModData.computerStateLocations[id] = state
    end
end

--- Add the computer to the known computer location database
---@param computer Computer
---@return void
local function AddComputerLocation(computer)
    if type(computer) == "table" and getmetatable(computer) == Classes.Computer then
        local id = ComputerUtils.squareToId(computer.square)
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
---@return void
local function RemoveComputerLocation(x, y, z)
    local id = ComputerUtils.positionToId(x, y, z)
    if id and GlobalModData.computerLocations[id] then
        GlobalModData.computerLocations[id] = nil
        print("ComputerMod: Removed Computer from ComputerLocations -> x:", x, " y:", y, " z:", z)
    end
end

--- CONTEXT MENU

---@param player number
---@param computerContext ISContextMenu
---@param computer Computer
---@return void
local function ComputerPowerManagementMenu(player, computerContext, computer)
    local character = getSpecificPlayer(player)
    local square = computer:getSquareInFront()

    -- Computer State Management
    if computer:hasElectricity() then
        local option = computerContext:addOption("Power Management")
        local context = ISContextMenu:getNew(computerContext)
        computerContext:addSubMenu(option, context)

        local function optionToggleComputer(inBios)
            ISTimedActionQueue.add(ISWalkToTimedAction:new(character, square))
            ISTimedActionQueue.add(Computer_Action_ToggleComputer:new(player, computer, inBios, 20))
        end

        TriggerEvent("OnBeforeComputerPowerManagementContextMenu", player, context, computer)
        if computer:isOn() then
            context:addOption("Turn off", nil, optionToggleComputer)
        else
            context:addOption("Turn on", false, optionToggleComputer)
            context:addOption("Turn on into BIOS", true, optionToggleComputer)
        end
        TriggerEvent("OnAfterComputerPowerManagementContextMenu", player, context, computer)
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
---@return void
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
---@return void
local function ComputerHardDriveManagementMenu(player, computerContext, computer)
    local harddrives = computer:getAllHarddrives()

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
---@return void
local function ComputerDiscDriveManagementMenu(player, computerContext, computer)
    local discdrives = computer:getAllDiscdrives()

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
---@return void
local function ComputerFloppyDriveManagementMenu(player, computerContext, computer)
    local floppydrives = computer:getAllFloppydrives()

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
---@return void
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

    if isDebugEnabled() then
        computerContext:addOption("[DEBUG] Reset Computer", nil, optionResetComputer)
    end
end

---@param player number
---@param context ISContextMenu
---@param computer Computer
---@return void
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

---@return void
local function AddTagToDisc()
    local item = getScriptManager():getItem("Base.Disc")
    if item then item:DoParam("Tags = ComputerMedium;ComputerDisc") end
    local item2 = getScriptManager():getItem("Base.Disc_Retail")
    if item2 then item:DoParam("Tags = ComputerMedium;ComputerDisc") end
end

---@return void
local function LoadGlobalModData()
    if not ModData.exists("ComputerMod") then
        ModData.create("ComputerMod")
        print("ComputerMod: Global mod data was created!")
    end

    GlobalModData = ModData.get("ComputerMod")
    if GlobalModData.computerLocations == nil then GlobalModData.computerLocations = {} end
    if GlobalModData.computerStateLocations == nil then GlobalModData.computerStateLocations = {} end

    print("ComputerMod: Global mod data has loaded!")
end

---@return void
local function InitializeComputers()
    if not GlobalModData or not GlobalModData.computerLocations then return; end

    local locations = GlobalModData.computerLocations
    for i=1, #locations do
        local position = locations[i]

        --print("COMPUTER STATE at ", position.x, ":",position.y, ":",position.z, GetComputerStateAtPosition(position.x, position.y, position.z))

        -- Handle computer audio
        if GetComputerStateAtPosition(position.x, position.y, position.z) then
            SoundManager.PlaySoundAt("ComputerHum", position.x, position.y, position.z, true)
        end
    end
end
InitializeComputers() -- call when reload

---@type number
local ticks = 0;

---@return void
local function UpdateComputers()
    ticks = ticks + 1
    if ticks > 200 then
        ticks = 0

        --- Start of Update

        ---@type table
        local locations = copyTable(GlobalModData.computerLocations)
        for i=1, #locations do
            local position = locations[i]

            ---@type Computer | nil
            local computer = GetComputerAtPosition(position.x, position.y, position.z)

            -- Handle computer power
            if computer and computer:isOn() and not computer:hasElectricity() then
                computer:toggleState(false, true) -- set will auto restart
                print("ComputerMod: Computer at x:", position.x, " y:", position.y, " z:", position.z, " shut down no power!")

            -- Handle computer auto restart
            elseif computer and computer:isOff() and computer:isAutoRestarting() and computer:hasElectricity() then
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

    ---@type Computer | nil
    local computer = GetComputerOnSquare(clickedSquare)
    if computer then
        AddComputerLocation(computer)
        FillComputerContextMenu(player, context, computer)
    end
end

Events.OnGameStart.Add(AddTagToDisc)
Events.OnGameStart.Add(LoadGlobalModData)
Events.OnGameStart.Add(InitializeComputers)
Events.OnTick.Add(UpdateComputers)
Events.OnPreFillWorldObjectContextMenu.Add(OnPreFillWorldObjectContextMenu)

--- COMPUTER EVENTS

CreateEvent("OnComputerPickedUp", "InventoryItem", "IsoGridSquare")
CreateEvent("OnComputerPlacedDown", "Computer")

CreateEvent("OnComputerBeforeBoot", "Computer", "boolean")
CreateEvent("OnComputerBoot", "Computer")
CreateEvent("OnComputerBootInBios", "Computer")
CreateEvent("OnComputerAfterBoot", "Computer")

CreateEvent("OnComputerBeforeShutDown", "Computer")
CreateEvent("OnComputerShutDown", "Computer")

CreateEvent("OnComputerHarddriveInstalled", "Computer", "Harddrive", "number")
CreateEvent("OnComputerHarddriveUninstalled", "Computer", "Harddrive", "number")

CreateEvent("OnComputerDiscdriveInstalled", "Computer", "Discdrive", "number")
CreateEvent("OnComputerDiscdriveUninstalled", "Computer", "Discdrive", "number")

CreateEvent("OnComputerFloppydriveInstalled", "Computer", "Floppydrive", "number")
CreateEvent("OnComputerFloppydriveUninstalled", "Computer", "Floppydrive", "number")

CreateEvent("OnComputerDiscInserted", "Computer", "Discdrive", "Disc")
CreateEvent("OnComputerDiscEjected", "Computer", "Discdrive", "Disc")

CreateEvent("OnComputerFloppyInserted", "Computer", "Floppydrive", "Floppy")
CreateEvent("OnComputerFloppyEjected", "Computer", "Floppydrive", "Floppy")

CreateEvent("OnBeforeComputerContextMenu", "number", "ISContextMenu", "Computer")
CreateEvent("OnAfterComputerContextMenu", "number", "ISContextMenu", "Computer")

CreateEvent("OnBeforeComputerPowerManagementContextMenu", "number", "ISContextMenu", "Computer")
CreateEvent("OnAfterComputerPowerManagementContextMenu", "number", "ISContextMenu", "Computer")

CreateEvent("OnBeforeComputerBiosManagementContextMenu", "number", "ISContextMenu", "Computer")
CreateEvent("OnAfterComputerBiosManagementContextMenu", "number", "ISContextMenu", "Computer")

CreateEvent("OnBeforeComputerHarddriveManagementContextMenu", "number", "ISContextMenu", "Computer")
CreateEvent("OnAfterComputerHarddriveManagementContextMenu", "number", "ISContextMenu", "Computer")

CreateEvent("OnBeforeComputerDiscdriveManagementContextMenu", "number", "ISContextMenu", "Computer")
CreateEvent("OnAfterComputerDiscdriveManagementContextMenu", "number", "ISContextMenu", "Computer")

CreateEvent("OnBeforeComputerFloppydriveManagementContextMenu", "number", "ISContextMenu", "Computer")
CreateEvent("OnAfterComputerFloppydriveManagementContextMenu", "number", "ISContextMenu", "Computer")

CreateEvent("OnBeforeComputerHardwareManagementContextMenu", "number", "ISContextMenu", "Computer")
CreateEvent("OnAfterComputerHardwareManagementContextMenu", "number", "ISContextMenu", "Computer")

CreateEvent("OnComputerFlagsChanged", "Computer", "string", "any")
CreateEvent("OnComputerBiosSettingChanged", "Computer", "string", "any")

---@param computer Computer
---@return void
function OnComputerAfterBoot(computer)
    SetComputerStateOnSquare(computer.square, true)
end

---@param computer Computer
---@return void
function OnComputerShutDown(computer)
    SetComputerStateOnSquare(computer.square, false)
end

---@param square IsoGridSquare
---@return void
function OnComputerPickedUp(_, square)
    RemoveComputerLocation(square:getX(), square:getY(), square:getZ())
end

---@param computer Computer
---@return void
function OnComputerPlacedDown(computer)
    AddComputerLocation(computer)
end

AddEvent("OnComputerAfterBoot", OnComputerAfterBoot)
AddEvent("OnComputerShutDown", OnComputerShutDown)
AddEvent("OnComputerPickedUp", OnComputerPickedUp)
AddEvent("OnComputerPlacedDown", OnComputerPlacedDown)

--- BIOS SETTINGS

AddBiosSetting("power_recovery", "Power Recovery", "Will not automatically restart when power becomes available.", "Will automatically restart when power becomes available.", false)
AddBiosSetting("enable_audio", "Audio", "Disable all computer audio.", "Enable all computer audio.", true)

--- GAME FORMATS

AddGameFormat("all")
AddGameFormat("disc")
AddGameFormat("floppy")

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

function ComputerMod.CreateAddon(...) return CreateAddon(...); end
function ComputerMod.AddAddon(...) return AddAddon(...); end

function ComputerMod.AddEvent(...) return AddEvent(...); end
function ComputerMod.RemoveEvent(...) return RemoveEvent(...); end
function ComputerMod.TriggerEvent(...) return TriggerEvent(...); end

function ComputerMod.GetAllBiosSettings() return GetAllBiosSettings(); end
function ComputerMod.GetBiosSettingByKey(...) return GetBiosSettingByKey(...); end

function ComputerMod.GetAllGameFormats() return GetAllGameFormats(); end
function ComputerMod.GetAllSoftwareTypes() return GetAllSoftwareTypes(); end

function ComputerMod.GetFileByIndex(...) return GetFileByIndex(...); end
function ComputerMod.GetAllFiles() return GetAllFiles(); end
function ComputerMod.GetRandomFile() return GetRandomFile(); end

function ComputerMod.GetGameById(...) return GetGameById(...); end
function ComputerMod.GetAllGames() return GetAllGames(); end
function ComputerMod.GetRandomGame() return GetRandomGame(); end

function ComputerMod.GetSoftwareById(...) return GetSoftwareById(...); end
function ComputerMod.GetAllSoftwares() return GetAllSoftwares(); end
function ComputerMod.GetRandomSoftware(...) return GetRandomSoftware(...); end

function ComputerMod.GetComputerOnSquare(...) return GetComputerOnSquare(...); end
function ComputerMod.GetComputerAtPosition(...) return GetComputerAtPosition(...); end

function ComputerMod.GetAllKnownComputerLocations() return GetAllKnownComputerLocations(); end

function ComputerMod.GetComputerStateAtPosition(...) return GetComputerStateAtPosition(...); end
function ComputerMod.GetComputerStateOnSquare(...) return GetComputerStateOnSquare(...); end
