require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"

--- ProceduralDistributions

local distributionTable = {

    --- CrateCompactDiscs
    {
        location = "ProceduralDistributions.list.CrateCompactDiscs.items",
        items = {
            {"Computer.Disc_Game", 10},
            {"Computer.Floppy", 10},
        },
    },

    --- DeskGeneric
    {
        location = "ProceduralDistributions.list.DeskGeneric.items",
        items = {
            {"Computer.Disc_Game", 5},
            {"Computer.Floppy", 5},
        },
    },

    --- DresserGeneric
    {
        location = "ProceduralDistributions.list.DresserGeneric.junk.items",
        items = {
            {"Computer.Disc_Game", 1},
            {"Computer.Floppy", 1},
        },
    },

    --- LivingRoomShelf
    {
        location = "ProceduralDistributions.list.LivingRoomShelf.items",
        items = {
            {"Computer.Disc_Game", 2},
            {"Computer.Floppy", 2},
        },
    },

    --- LivingRoomShelfNoTapes
    {
        location = "ProceduralDistributions.list.LivingRoomShelfNoTapes.items",
        items = {
            {"Computer.Disc_Game", 2},
            {"Computer.Floppy", 2},
        },
    },

    --- Locker
    {
        location = "ProceduralDistributions.list.Locker.items",
        items = {
            {"Computer.Disc_Game", 1},
            {"Computer.Floppy", 1},
        },
    },

    --- LockerClassy
    {
        location = "ProceduralDistributions.list.LockerClassy.items",
        items = {
            {"Computer.Disc_Game", 1},
            {"Computer.Floppy", 1},
        },
    },

    --- SchoolLockers
    {
        location = "ProceduralDistributions.list.SchoolLockers.items",
        items = {
            {"Computer.Disc_Game", 3},
            {"Computer.Floppy", 3},
        },
    },

    --- ShelfGeneric
    {
        location = "ProceduralDistributions.list.ShelfGeneric.items",
        items = {
            {"Computer.Disc_Game", 1},
            {"Computer.Floppy", 1},
        },
    },

    --- WardrobeChild
    {
        location = "ProceduralDistributions.list.WardrobeChild.junk.items",
        items = {
            {"Computer.Disc_Game", 3},
            {"Computer.Floppy", 3},
        },
    },

    --- WardrobeMan
    {
        location = "ProceduralDistributions.list.WardrobeMan.junk.items",
        items = {
            {"Computer.Disc_Game", 1},
            {"Computer.Floppy", 1},
        },
    },

    --- postbox
    {
        location = "SuburbsDistributions.all.postbox.items",
        items = {
            {"Computer.Disc_Game", 10},
            {"Computer.Floppy", 10},
        },
    },
}

------------------------------------------------------------------------------------------------------

--- split string by character
local function split(s) --TODO: switch to luautils.split instead of our own?
    result = {}
    for i in string.gmatch(s, "[^%.]+") do
        table.insert(result, i)
    end
    return result
end

--- getLocation function
local function getLocation(locationParts)
    if locationParts then
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

--- add function
local function add(location, item, odd)
    table.insert(location, item)
    table.insert(location, odd)
end

--- process
for t=1, #distributionTable do
    local table = distributionTable[t]
    local locationParts = split(table.location)
    local location = getLocation(locationParts)

    if location then
        for e=1, #table.items do
            local item = table.items[e][1]
            local odd = table.items[e][2]
    
            if not pcall(add, location, item, odd) then
                print("ComputerMod: Error distribution adding table '"..item.."':'"..odd.."' at '"..table.location.."'!")
            else
                print("ComputerMod: Distribution added '"..item.."':'"..odd.."' to table '"..table.location.."'!")
            end
        end
    else
        print("ComputerMod: Error distribution invalid location at '"..table.location.."'!")
    end
end
