require("Computer/ComputerMod")
local Computer = require("Computer/Classes/Computer")

------------------------------------------------------------------------------------------------------------------------

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

    else
        local item = original_ISMoveableSpriteProps_pickUpMoveableInternal(self, _character, _square, _object, _sprInstance, _spriteName, _createItem, _rotating, ...)
        return item
    end

end

------------------------------------------------------------------------------------------------------------------------

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

        -- Place the computer
        original_ISMoveableSpriteProps_placeMoveableInternal(self, _square, _item, _spriteName, ...)

        -- Get the computer on square
        local computer = ComputerMod.GetComputerOnSquare(_square)

        -- Set the computerData to the object
        if computer and computerData then
            computer.isoObject:getModData().data = computerData;
            ComputerMod.TriggerEvent("OnComputerPlacedDown", computer)
            print("Computer data transferred into object!")
        end

    else
        original_ISMoveableSpriteProps_placeMoveableInternal(self, _square, _item, _spriteName, ...)
    end

end