require("Computer/ComputerMod")
local Computer = require("Computer/Classes/Computer")

------------------------------------------------------------------------------------------------------------------------

-- Handle computer pick up

local original_ISMoveableSpriteProps_pickUpMoveableInternal = ISMoveableSpriteProps.pickUpMoveableInternal

---@param _character IsoPlayer
---@param _square IsoGridSquare
---@param _object IsoObject
---@param _sprInstance IsoSprite
---@param _spriteName string
---@return InventoryItem
function ISMoveableSpriteProps:pickUpMoveableInternal(_character, _square, _object, _sprInstance, _spriteName, _createItem, _rotating, ...)

    local computer = Computer:new(_object)

    -- Check if its a computer
    if computer then

        -- Get the new item
        local item = original_ISMoveableSpriteProps_pickUpMoveableInternal(self, _character, _square, _object, _sprInstance, _spriteName, _createItem, _rotating, ...)

        -- Set the computerData to the item
        if item then

            local computerData = computer:getData()
            if computerData then
                item:getModData().computerData = copyTable(computerData)
                print("Computer data transferred into movable item!")
            end

            ComputerMod.TriggerEvent("OnComputerPickedUp", item, _square)

            return item;
        end

    else -- we can just return whatever the original returns.
        return original_ISMoveableSpriteProps_pickUpMoveableInternal(self, _character, _square, _object, _sprInstance, _spriteName, _createItem, _rotating, ...)
    end

end

------------------------------------------------------------------------------------------------------------------------

-- Handle computer placement

local original_ISMoveableSpriteProps_placeMoveableInternal = ISMoveableSpriteProps.placeMoveableInternal

---@param _square IsoGridSquare
---@param _item InventoryItem
---@param _spriteName string
function ISMoveableSpriteProps:placeMoveableInternal(_square, _item, _spriteName, ...)

    -- Check if its a computer
    if Computer.IsSpriteOff(_spriteName) then

        -- Get the computerData from the item
        local computerData = {}
        if _item and _item:hasModData() and _item:getModData().computerData then
            computerData = copyTable(_item:getModData().computerData);
        end

        -- Place the computer | Please always return original function, just in case anything changes
        local ret = original_ISMoveableSpriteProps_placeMoveableInternal(self, _square, _item, _spriteName, ...)

        -- Get the computer on square
        local computer = ComputerMod.GetComputerOnSquare(_square)

        -- Set the computerData to the object
        if computer and computerData then
            computer.isoObject:getModData().data = computerData;
            ComputerMod.TriggerEvent("OnComputerPlacedDown", computer)
            print("Computer data transferred into object!")
        end

        return ret; -- we return original return.
    else -- please always return original, just in case anything changes
        return original_ISMoveableSpriteProps_placeMoveableInternal(self, _square, _item, _spriteName, ...)
    end

end

------------------------------------------------------------------------------------------------------------------------

-- Handle computer dismantle

local original_ISMoveableSpriteProps_scrapObjectInternal = ISMoveableSpriteProps.scrapObjectInternal

function ISMoveableSpriteProps:scrapObjectInternal( _character, _scrapDef, _square, _object, _scrapResult, _chance, _perkName )

    local computer
    local sprite = _object:getSprite()
    if sprite then
        local spriteName = sprite:getName()
        if Computer.IsSpriteOff(spriteName) then
            computer = Computer:new(_object)
        end
    end

    original_ISMoveableSpriteProps_scrapObjectInternal(self, _character, _scrapDef, _square, _object, _scrapResult, _chance, _perkName)

    -- Has been dismantled and was a computer
    if computer then
        -- Give back all hardwares
        local inventory = _character:getInventory()
        for slotKey, hardware in pairs(computer:getAllHardwares()) do
            if hardware then
                computer:uninstallHardwareItemFromSlot(inventory, slotKey)
            end
        end

        -- Give back all drives
        local drives = computer:getAllDrives()
        for i=1, drives.count do
            computer:uninstallDriveFromBayIndex(inventory, i)
        end

        print("Computer was dismantled!")
    end

end