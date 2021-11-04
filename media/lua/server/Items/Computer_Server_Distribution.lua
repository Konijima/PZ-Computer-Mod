require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"

--- Set all odds to 100 for testing
local test = false

--- ProceduralDistributions

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

--- Distribution table for addons
local addonDistributionTable = {}

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

---@param table table
---@param location table
local function process_location(table, location)
    if location then
        for e=1, #table.items do
            local item = table.items[e][1]
            local odd = table.items[e][2]

            if test then
                odd = 100
            end

            if not add(location, item, odd) then
                error("ComputerMod: Error distribution adding table '"..item.."':'"..odd.."' at '"..table.location.."'!")
            else
                print("ComputerMod: Distribution added '"..item.."':'"..odd.."' to table '"..table.location.."'!")
            end
        end
    else
        error("ComputerMod: Error distribution invalid location at '"..table.location.."'!")
    end
end

---@param table table the distribution table to process 'distributionTable | addonDistributionTable'
---@return number
local function process(table)
    local errorCount = 0
    for t=1, #distributionTable do
        local table = distributionTable[t]
        local locationParts = split(table.location)
        local location = getLocation(locationParts)

        if not pcall(process_location, table, location) then
            errorCount = errorCount + 1
        end
    end
    return errorCount
end

-- Start Processing
local errorCount = process(distributionTable)
if errorCount == 0 then
    print("ComputerMod: Adding to the distribution table process completed!")
else
    print("ComputerMod: Adding to the distribution table process completed with "..errorCount.." error(s)!")
end

--- ADDONS

local function addLocation(location, items)
    if type(location) ~= "string" then
        error("ComputerAddDistributionLocation: error 'location' must be a string, got a " .. type(location) .. "!", 3)
    end
    if type(items) ~= "table" then
        error("ComputerAddDistributionLocation: error 'items' must be a table, got a " .. type(items) .. "!", 3)
    end

    -- TODO: Do logic here, maybe more validation too!
end

--- Function
---@param location string
---@param items table
function ComputerAddDistributionLocation(location, items)
    if not pcall(addLocation, location, items) then
        print("ComputerAddDistributionLocation: There was an error trying to add distribution location!")
    else
        local errorCount = process(addonDistributionTable)
        if errorCount == 0 then
            print("ComputerAddDistributionLocation: Adding to the distribution table process completed!")
        else
            print("ComputerAddDistributionLocation: Adding to the distribution table process completed with "..errorCount.." error(s)!")
        end
        addonDistributionTable = {} -- reset
    end
end