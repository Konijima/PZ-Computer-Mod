require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"

--- Set all odds to 100 for testing
local test = false

--- ProceduralDistributions

local addonDistributionTable = {}

local distributionTable = {

    --- CrateCompactDiscs
    {
        location = "ProceduralDistributions.list.CrateCompactDiscs.items",
        items = {
            {"Computer.Disc_Game", 10},
            {"Computer.Disc_Software", 10},
            {"Computer.Disc_Learning", 10},
            {"Computer.Floppy", 10},
            {"Computer.Floppy_Game", 10},
            {"Computer.Floppy_Software", 10},
            {"Computer.Floppy_Learning", 10},
        },
    },

    --- DeskGeneric
    {
        location = "ProceduralDistributions.list.DeskGeneric.items",
        items = {
            {"Computer.Disc_Game", 5},
            {"Computer.Disc_Software", 5},
            {"Computer.Disc_Learning", 5},
            {"Computer.Floppy", 5},
            {"Computer.Floppy_Game", 5},
            {"Computer.Floppy_Software", 5},
            {"Computer.Floppy_Learning", 5},
        },
    },

    --- DresserGeneric
    {
        location = "ProceduralDistributions.list.DresserGeneric.junk.items",
        items = {
            {"Computer.Disc_Game", 1},
            {"Computer.Disc_Software", 1},
            {"Computer.Disc_Learning", 1},
            {"Computer.Floppy", 1},
            {"Computer.Floppy_Game", 1},
            {"Computer.Floppy_Software", 1},
            {"Computer.Floppy_Learning", 1},
        },
    },

    --- LivingRoomShelf
    {
        location = "ProceduralDistributions.list.LivingRoomShelf.items",
        items = {
            {"Computer.Disc_Game", 2},
            {"Computer.Disc_Software", 2},
            {"Computer.Disc_Learning", 2},
            {"Computer.Floppy", 2},
            {"Computer.Floppy_Game", 2},
            {"Computer.Floppy_Software", 2},
            {"Computer.Floppy_Learning", 2},
        },
    },

    --- LivingRoomShelfNoTapes
    {
        location = "ProceduralDistributions.list.LivingRoomShelfNoTapes.items",
        items = {
            {"Computer.Disc_Game", 2},
            {"Computer.Disc_Software", 2},
            {"Computer.Disc_Learning", 2},
            {"Computer.Floppy", 2},
            {"Computer.Floppy_Game", 2},
            {"Computer.Floppy_Software", 2},
            {"Computer.Floppy_Learning", 2},
        },
    },

    --- Locker
    {
        location = "ProceduralDistributions.list.Locker.items",
        items = {
            {"Computer.Disc_Game", 1},
            {"Computer.Disc_Software", 1},
            {"Computer.Disc_Learning", 1},
            {"Computer.Floppy", 1},
            {"Computer.Floppy_Game", 1},
            {"Computer.Floppy_Software", 1},
            {"Computer.Floppy_Learning", 1},
        },
    },

    --- LockerClassy
    {
        location = "ProceduralDistributions.list.LockerClassy.items",
        items = {
            {"Computer.Disc_Game", 1},
            {"Computer.Disc_Software", 1},
            {"Computer.Disc_Learning", 1},
            {"Computer.Floppy", 1},
            {"Computer.Floppy_Game", 1},
            {"Computer.Floppy_Software", 1},
            {"Computer.Floppy_Learning", 1},
        },
    },

    --- SchoolLockers
    {
        location = "ProceduralDistributions.list.SchoolLockers.items",
        items = {
            {"Computer.Disc_Game", 3},
            {"Computer.Disc_Software", 3},
            {"Computer.Disc_Learning", 3},
            {"Computer.Floppy", 3},
            {"Computer.Floppy_Game", 3},
            {"Computer.Floppy_Software", 3},
            {"Computer.Floppy_Learning", 3},
        },
    },

    --- ShelfGeneric
    {
        location = "ProceduralDistributions.list.ShelfGeneric.items",
        items = {
            {"Computer.Disc_Game", 1},
            {"Computer.Disc_Software", 1},
            {"Computer.Disc_Learning", 1},
            {"Computer.Floppy", 1},
            {"Computer.Floppy_Game", 1},
            {"Computer.Floppy_Software", 1},
            {"Computer.Floppy_Learning", 1},
        },
    },

    --- WardrobeChild
    {
        location = "ProceduralDistributions.list.WardrobeChild.junk.items",
        items = {
            {"Computer.Disc_Game", 3},
            {"Computer.Disc_Software", 3},
            {"Computer.Disc_Learning", 3},
            {"Computer.Floppy", 3},
            {"Computer.Floppy_Game", 3},
            {"Computer.Floppy_Software", 3},
            {"Computer.Floppy_Learning", 3},
        },
    },

    --- WardrobeMan
    {
        location = "ProceduralDistributions.list.WardrobeMan.junk.items",
        items = {
            {"Computer.Disc_Game", 1},
            {"Computer.Disc_Software", 1},
            {"Computer.Disc_Learning", 1},
            {"Computer.Floppy", 1},
            {"Computer.Floppy_Game", 1},
            {"Computer.Floppy_Software", 1},
            {"Computer.Floppy_Learning", 1},
        },
    },

    --- postbox
    {
        location = "SuburbsDistributions.all.postbox.items",
        items = {
            {"Computer.Disc_Game", 2},
            {"Computer.Disc_Software", 2},
            {"Computer.Disc_Learning", 2},
            {"Computer.Floppy", 2},
            {"Computer.Floppy_Game", 2},
            {"Computer.Floppy_Software", 2},
            {"Computer.Floppy_Learning", 2},
        },
    },
}

------------------------------------------------------------------------------------------------------

---@param s string
local function split(s)
    if type(s) == "string" then
        local result = {}
        for i in string.gmatch(s, "[^%.]+") do
            table.insert(result, i)
        end
        return result
    end
end

---@param locationParts table<string>
local function getLocation(locationParts)
    if type(locationParts) == "table" then
        local partCount = #locationParts
        --local location = _G[locationParts[1]]; TODO: Fix to this?
        local location = ProceduralDistributions
        local locationString = locationParts[1]

        if locationParts[1] == "SuburbsDistributions" then
            location = SuburbsDistributions
        elseif locationParts[1] == "ProceduralDistributions" then
            location = ProceduralDistributions
        else
            return nil
        end

        for i=2, #locationParts do
            if location[locationParts[i]] then
                locationString = locationString .. "-" .. locationParts[i]
                location = location[locationParts[i]]
            else
                return nil; -- Break out of it and return nil instead of allowing incomplete location!
            end
            if i >= partCount then
                return location
            end
        end
    end
end

---@param location table
---@param item string
---@param odd number
---@return boolean
local function add(location, item, odd)
    if type(location) == "table" then
        table.insert(location, item)
        table.insert(location, odd)
        return true
    end
end

---@param addonName string
---@param table table
---@param location table
local function process_location(addonName, table, location)
    if location then
        for e=1, #table.items do
            local item = table.items[e][1]
            local odd = table.items[e][2]

            if test then
                odd = 100
            end

            if not add(location, item, odd) then
                error(addonName..": Error distribution adding table '"..item.."':'"..odd.."' at '"..table.location.."'!")
            else
                print(addonName..": Distribution added '"..item.."':'"..odd.."' to table '"..table.location.."'!")
            end
        end
    else
        error(addonName..": Error distribution invalid location at '"..table.location.."'!")
    end
end

---@param addonName string
---@param distributionToProcess table the distribution table to process 'distributionTable | addonDistributionTable'
---@return number
local function process(addonName, distributionToProcess)
    local errorCount = 0
    for t=1, #distributionToProcess do
        local table = distributionToProcess[t]
        local locationParts = split(table.location)
        local location = getLocation(locationParts)

        if not pcall(process_location, addonName, table, location) then
            errorCount = errorCount + 1
        end
    end
    return errorCount
end

-- Start Processing
print("---------------------------------------------------------------------------------------")
local errorCount = process("ComputerMod", distributionTable)
if errorCount == 0 then
    print("ComputerMod: Adding to the distribution table process completed!")
else
    print("ComputerMod: Adding to the distribution table process completed with "..errorCount.." error(s)!")
end
print("---------------------------------------------------------------------------------------")


--- ADDONS



---@param addonName string
---@param locationEntry table
local function addLocation(addonName, locationEntry)
    if type(locationEntry) ~= "table" then
        error(addonName..": ComputerAddDistributionLocations error a Location Entry must be a table, got a " .. type(locationEntry) .. "!", 3)
    end
    if type(locationEntry.location) ~= "string" then
        error(addonName..": ComputerAddDistributionLocations error 'location' must be a string, got a " .. type(locationEntry.location) .. "!", 3)
    end
    if type(locationEntry.items) ~= "table" then
        error(addonName..": ComputerAddDistributionLocations error 'items' must be a table, got a " .. type(locationEntry.items) .. "!", 3)
    end

    -- TODO: More validation per entry
    -- Verify location is correct
    -- Verify items are in the right format

    table.insert(addonDistributionTable, locationEntry)
end

---@param addonName string
---@param locationsTable table
local function addLocations(addonName, locationsTable)
    if type(locationsTable) == "table" then
        for i=1, #locationsTable do
            addLocation(addonName, locationsTable[i])
        end
    else
        print(addonName..": ComputerAddDistributionLocations did not receive a locations table!")
    end
end

--- Add locations table
---@param addonName string
---@param locationsTable table
function ComputerAddDistributionLocations(addonName, locationsTable)
    if type(addonName) ~= "string" then
        print("ComputerAddDistributionLocations: An addon didn't specify a name using the method ComputerAddDistributionLocations!")
        return
    end
    if not pcall(addLocations, addonName, locationsTable) then
        print(addonName..": There was an error trying to add distribution locations!")
    else
        if #locationsTable > 0 then
            print("---------------------------------------------------------------------------------------")
            local errorCount = process(addonName, addonDistributionTable)
            if errorCount == 0 then
                print(addonName..": Adding to the distribution table process completed!")
            else
                print(addonName..": Adding to the distribution table process completed with "..errorCount.." error(s)!")
            end
            print("---------------------------------------------------------------------------------------")
            addonDistributionTable = {} -- reset
        end
    end
end