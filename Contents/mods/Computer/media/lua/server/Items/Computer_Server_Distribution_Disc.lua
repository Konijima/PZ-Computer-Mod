require "Items/SuburbsDistributions"
require "Items/ProceduralDistributions"

--- ProceduralDistributions

local modifier = 1

-- CrateCompactDiscs
table.insert(ProceduralDistributions.list.CrateCompactDiscs.items, "Computer.Disc_Game")
table.insert(ProceduralDistributions.list.CrateCompactDiscs.items, 10 * modifier)

-- DeskGeneric
table.insert(ProceduralDistributions.list.DeskGeneric.items, "Computer.Disc_Game")
table.insert(ProceduralDistributions.list.DeskGeneric.items, 5 * modifier)

-- DresserGeneric
table.insert(ProceduralDistributions.list.DresserGeneric.junk.items, "Computer.Disc_Game")
table.insert(ProceduralDistributions.list.DresserGeneric.junk.items, 2 * modifier)

-- LivingRoomShelf
table.insert(ProceduralDistributions.list.LivingRoomShelf.items, "Computer.Disc_Game")
table.insert(ProceduralDistributions.list.LivingRoomShelf.items, 2 * modifier)

-- LivingRoomShelfNoTapes
table.insert(ProceduralDistributions.list.LivingRoomShelfNoTapes.items, "Computer.Disc_Game")
table.insert(ProceduralDistributions.list.LivingRoomShelfNoTapes.items, 2 * modifier)

-- Locker
table.insert(ProceduralDistributions.list.Locker.items, "Computer.Disc_Game")
table.insert(ProceduralDistributions.list.Locker.items, 2 * modifier)

-- LockerClassy
table.insert(ProceduralDistributions.list.LockerClassy.items, "Computer.Disc_Game")
table.insert(ProceduralDistributions.list.LockerClassy.items, 2 * modifier)

-- SchoolLockers
table.insert(ProceduralDistributions.list.SchoolLockers.items, "Computer.Disc_Game")
table.insert(ProceduralDistributions.list.SchoolLockers.items, 3 * modifier)

-- ShelfGeneric
table.insert(ProceduralDistributions.list.ShelfGeneric.items, "Computer.Disc_Game")
table.insert(ProceduralDistributions.list.ShelfGeneric.items, 2 * modifier)

-- WardrobeChild
table.insert(ProceduralDistributions.list.WardrobeChild.junk.items, "Computer.Disc_Game")
table.insert(ProceduralDistributions.list.WardrobeChild.junk.items, 3 * modifier)

-- WardrobeMan
table.insert(ProceduralDistributions.list.WardrobeMan.junk.items, "Computer.Disc_Game")
table.insert(ProceduralDistributions.list.WardrobeMan.junk.items, 2 * modifier)

-- postbox
table.insert(SuburbsDistributions.all.postbox.items, "Computer.Disc_Game")
table.insert(SuburbsDistributions.all.postbox.items, 2 * modifier)
