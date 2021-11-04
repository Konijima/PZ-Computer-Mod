require "DistributionAPI"

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

AddDistributionTable("ComputerMod", distributionTable)
