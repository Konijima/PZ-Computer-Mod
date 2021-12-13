--- pickUpMoveableInternal
local original_ISMoveableSpriteProps_pickUpMoveableInternal = ISMoveableSpriteProps.pickUpMoveableInternal
function ISMoveableSpriteProps:pickUpMoveableInternal(_character, _square, _object, _sprInstance, _spriteName, _createItem, _rotating, ...)

	-- Check if its a computer
	if ComputerMod.isComputerSpriteOff(_spriteName) then

		-- Get the computer data from the object
		local computerData = {}
		if _object:hasModData() and _object:getModData().computerData then
			computerData = copyTable(_object:getModData().computerData)
		end

		-- Get the new item
		local item = original_ISMoveableSpriteProps_pickUpMoveableInternal(self, _character, _square, _object, _sprInstance, _spriteName, _createItem, _rotating, ...)

		-- Set the computerData to the item
		if item then

			if computerData then
				item:getModData().computerData = computerData
			end

			return item;
		end

	else
		local item = original_ISMoveableSpriteProps_pickUpMoveableInternal(self, _character, _square, _object, _sprInstance, _spriteName, _createItem, _rotating, ...)
		return item
	end

end

--- placeMoveableInternal
local original_ISMoveableSpriteProps_placeMoveableInternal = ISMoveableSpriteProps.placeMoveableInternal
function ISMoveableSpriteProps:placeMoveableInternal(_square, _item, _spriteName, ...)

	-- Check if its a computer
	if ComputerMod.isComputerSpriteOff(_spriteName) then

		-- Get the computerData from the item
		local computerData = {}
		if _item and _item:hasModData() and _item:getModData().computerData then
			computerData = copyTable(_item:getModData().computerData);
		end

		-- Place the computer
		original_ISMoveableSpriteProps_placeMoveableInternal(self, _square, _item, _spriteName, ...)

		-- Get the computer on square
		local object
		for i = _square:getObjects():size(),1,-1 do
			local obj = _square:getObjects():get(i-1)
			local sprite = obj:getSprite()
			if sprite then
				if ComputerMod.isComputerSpriteOff(sprite:getName()) then
					object = obj
					break
				end
			end
		end

		-- Set the computerData to the object
		if object and computerData then
			object:getModData().computerData = computerData;
			object:transmitModData() -- fix for mp
		end

	else
		original_ISMoveableSpriteProps_placeMoveableInternal(self, _square, _item, _spriteName, ...)
	end

end