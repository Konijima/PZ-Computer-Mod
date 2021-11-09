-- PROBLEMS/BUGS
--- Doesn't consume power
--- Doesn't turn off when power is down
--- Power off only when interacting with it while power is down

local activeMods = getActivatedMods(); -- I believe an arrayList?
if not activeMods:contains("CommunityAPI") then

	print("Computer V1: CommunityAPI not found!")
	local PopupCommunityAPI = require("PopupCommunityAPI")
	Events.OnGameStart.Add(PopupCommunityAPI.Open)

else

	print("Computer V1: CommunityAPI is loaded!")

end

local ActiveComputer = nil
local ActiveComputerPlayer = nil
local ActiveComputerSquare = nil

ComputerMod = {
	SpriteComputerOff = {
		S = "appliances_com_01_72",
		E = "appliances_com_01_73",
		N = "appliances_com_01_74",
		W = "appliances_com_01_75",
	},
	SpriteComputerOn = {
		S = "appliances_com_01_76",
		E = "appliances_com_01_77",
		N = "appliances_com_01_78",
		W = "appliances_com_01_79",
	},
	Events = {},
	Games = {},
}

--- addGame
function ComputerMod.addGame(id, title, date, publisher, genre)
	if ComputerMod.Games[id] == nil then
		local newGame = {
			id = id,
			title = title,
			date = date,
			publisher = publisher,
			genre = genre,
		}
		ComputerMod.Games[id] = newGame
		print("Adding computer game: " .. id)
		return newGame
	end
end

--- getAllGames
function ComputerMod.getAllGames()
	return ComputerMod.Games
end

--- getGame
function ComputerMod.getGame(id)
	return ComputerMod.Games[id]
end

--- getRandomGame
function ComputerMod.getRandomGame()
	local keys = {}
	for k in pairs(ComputerMod.Games) do
		table.insert(keys, k)
	end
	local rand = ZombRand(#keys+1)
	local game = ComputerMod.Games[keys[rand]]
	return game
end

--- getGameDiscTooltipDescription
function ComputerMod.getGameDiscTooltipDescription(game)
	local gameData = ComputerMod.getGame(game.id)
	local description = ""
	if gameData then
		description = " <RGB:1,1,0.8> Title:                 <RGB:1,1,1> " .. gameData.title
		description = description .. " <LINE> <RGB:1,1,0.8> Publisher:     <RGB:1,1,1> " .. gameData.publisher
		description = description .. " <LINE> <RGB:1,1,0.8> Released:      <RGB:1,1,1> " .. gameData.date
		description = description .. " <LINE> <RGB:1,1,0.8> Genre:              <RGB:1,1,1> " .. gameData.genre
	else
		description = " <RGB:1,0,0> Unknown Disc"
	end
	return description
end

--- getRetailDiscTooltipDescription
function ComputerMod.getRetailDiscTooltipDescription(media)
	local description = ""
	description = " <RGB:1,1,0.8> Title:            <RGB:1,1,1> " .. media.title
	description = description .. " <LINE> <RGB:1,1,0.8> Author:     <RGB:1,1,1> " .. media.author
	return description
end

--- getDiscType
function ComputerMod.getDiscType(disc)
	if disc  then
		return disc:getType()
	end
end

--- getRetailDiscData
function ComputerMod.getRetailDiscData(disc)
	if disc and disc:getType() == "Disc_Retail" then
		local mediaData = disc:getMediaData()
		local media = {
			title = mediaData:getTitleEN(),
			author = mediaData:getAuthorEN(),
			type = mediaData:getMediaType(),
			index = mediaData:getIndex(),
		}
		return media
	end
end

--- getGameDiscData
function ComputerMod.getGameDiscData(disc)
	if disc and disc:getType() == "Disc_Game" then
		return disc:getModData().game
	end
end

--- setGameDiscData
function ComputerMod.setGameDiscData(disc, game)
	if disc and disc:getType() == "Disc_Game" then
		disc:setName("Game CD: " .. game.title)
		disc:getModData().game = game
	end
end

--- isComputerSpriteOff
function ComputerMod.isComputerSpriteOff(spriteName)
	if spriteName == ComputerMod.SpriteComputerOff.S or spriteName == ComputerMod.SpriteComputerOff.E or spriteName == ComputerMod.SpriteComputerOff.N or spriteName == ComputerMod.SpriteComputerOff.W then
		return true
	end
	return false
end

--- isComputerSpriteOn
function ComputerMod.isComputerSpriteOn(spriteName)
	if spriteName == ComputerMod.SpriteComputerOn.S or spriteName == ComputerMod.SpriteComputerOn.E or spriteName == ComputerMod.SpriteComputerOn.N or spriteName == ComputerMod.SpriteComputerOn.W then
		return true
	end
	return false
end

--- isAnyComputerSprite
function ComputerMod.isAnyComputerSprite(spriteName)
	if ComputerMod.isComputerSpriteOff(spriteName) or ComputerMod.isComputerSpriteOn(spriteName) then
		return true
	end
	return false
end

--- getComputerSpriteFacing
function ComputerMod.getComputerSpriteFacing(spriteName)
	if spriteName == ComputerMod.SpriteComputerOn.S or spriteName == ComputerMod.SpriteComputerOff.S then
		return "S"
	end
	if spriteName == ComputerMod.SpriteComputerOn.E or spriteName == ComputerMod.SpriteComputerOff.E then
		return "E"
	end
	if spriteName == ComputerMod.SpriteComputerOn.N or spriteName == ComputerMod.SpriteComputerOff.N then
		return "N"
	end
	if spriteName == ComputerMod.SpriteComputerOn.W or spriteName == ComputerMod.SpriteComputerOff.W then
		return "W"
	end
end

--- isComputer
function ComputerMod.isComputer(computer)
	if computer and computer:getSprite() then
		return ComputerMod.isAnyComputerSprite(computer:getSprite():getName())
	end
	return false
end

--- isComputerOff
function ComputerMod.isComputerOff(computer)
	if computer and computer:getSprite() then
		return ComputerMod.isComputerSpriteOn(computer:getSprite():getName())
	end
	return false
end

--- isComputerOn
function ComputerMod.isComputerOn(computer)
	if computer and computer:getSprite() then
		return ComputerMod.isComputerSpriteOn(computer:getSprite():getName())
	end
	return false
end

--- getComputerFacing
function ComputerMod.getComputerFacing(computer)
	if computer and ComputerMod.isComputer(computer) then
		return ComputerMod.getComputerSpriteFacing(computer:getSprite():getName())
	end
end

--- getComputerData
function ComputerMod.getComputerData(computer)
	local computerData
	if computer and ComputerMod.isComputer(computer) then
		computerData = computer:getModData().computerData
	end
	if computerData == nil then
		computerData = {}
		computer:getModData().computerData = {}
	end
	return computerData
end

-- getCurrentDisc
function ComputerMod.getCurrentDisc(computer)
	if computer and ComputerMod.isComputer(computer) then
		local computerData = ComputerMod.getComputerData(computer)
		if computerData and computerData.currentDisc then
			return computerData.currentDisc
		end
	end
end

-- insertDisc
function ComputerMod.insertDisc(inventory, computer, disc)
	if computer and ComputerMod.isComputer(computer) then
		if disc and not ComputerMod.getCurrentDisc(computer) then
			local computerData = ComputerMod.getComputerData(computer)
			local discData = {
				type = disc:getType(),
				name = disc:getDisplayName(),
			}

			print("*** INSERTED DISC ***")
			print("Disc type: " .. tostring(discData.type))
			print("Disc name: " .. tostring(discData.name))

			if discData.type == "Disc" then

			elseif discData.type == "Disc_Game" then
				discData.game = ComputerMod.getGameDiscData(disc)
			elseif discData.type == "Disc_Retail" then
				discData.media = ComputerMod.getRetailDiscData(disc)
			end

			computerData.currentDisc = discData
			inventory:Remove(disc)

			ComputerMod.Events.OnDiscInserted(computer, discData)

			return computerData.currentDisc
		end
	end
end

-- ejectDisc
function ComputerMod.ejectDisc(inventory, computer)
	if computer and ComputerMod.isComputer(computer) then
		if ComputerMod.getCurrentDisc(computer) then
			local computerData = ComputerMod.getComputerData(computer)

			local item
			if computerData.currentDisc.type == "Disc" then
				item = inventory:AddItem("Base.Disc")

			elseif computerData.currentDisc.type == "Disc_Game" then
				item = inventory:AddItem("Computer.Disc_Game")
				local game = computerData.currentDisc.game
				if game then
					ComputerMod.setGameDiscData(item, game)
				end

			elseif computerData.currentDisc.type == "Disc_Retail" then
				item = inventory:AddItem("Base.Disc_Retail")
				local list = getZomboidRadio():getRecordedMedia():getAllMediaForType(computerData.currentDisc.media.type)
				for i=0, list:size()-1 do
					local other = list:get(i)
					if other:getIndex() == computerData.currentDisc.media.index then
						item:setRecordedMediaData(other)
						break
					end
				end
			end

			print("*** EJECTED DISC ***")
			print("Disc type: " .. tostring(computerData.currentDisc.type))
			print("Disc name: " .. tostring(computerData.currentDisc.name))

			computerData.currentDisc = nil

			ComputerMod.Events.OnDiscEjected(computer, item)

			return item
		end
	end
end

--- getAllInstalledGameIds
function ComputerMod.getAllInstalledGameIds(computer)
	if computer and ComputerMod.isComputer(computer) then
		local installed = {}
		local computerData = ComputerMod.getComputerData(computer)
		if computerData and computerData.installedGames then
			for i=1, #computerData.installedGames do
				local gameId = computerData.installedGames[i]
				if ComputerMod.getGame(gameId) then
					table.insert(installed, gameId)
				end
			end
		end
		return installed
	end
end

--- isGameInstalled
function ComputerMod.isGameInstalled(computer, game)
	if computer and ComputerMod.isComputer(computer) then
		local computerData = ComputerMod.getComputerData(computer)
		if computerData and computerData.installedGames then
			for i=1, #computerData.installedGames do
				if computerData.installedGames[i] == game.id and ComputerMod.getGame(game.id) then
					return true
				end
			end
		end
	end
end

--- installGame
function ComputerMod.installGame(computer, game)
	if computer and ComputerMod.isComputer(computer) then
		if not ComputerMod.isGameInstalled(computer, game) and ComputerMod.getGame(game.id) then
			local computerData = ComputerMod.getComputerData(computer)
			if computerData.installedGames == nil then
				computerData.installedGames = {}
			end
			table.insert(computerData.installedGames, game.id)
			print("Installed game " .. game.id)
			return true
		end
	end
end

--- uninstallGame
function ComputerMod.uninstallGame(computer, game)
	if computer and ComputerMod.isComputer(computer) then
		if ComputerMod.isGameInstalled(computer, game) and ComputerMod.getGame(game.id) then
			local computerData = ComputerMod.getComputerData(computer)
			for i=1, #computerData.installedGames do
				if computerData.installedGames[i] == game.id then
					table.remove(computerData.installedGames, i)
					print("Uninstalled game " .. game.id)
					return true
				end
			end
		end
	end
end

--- setActiveComputer
function ComputerMod.setActiveComputer(computer, playerNum)
	if computer and ComputerMod.isComputer(computer) then
		local playerObj = getSpecificPlayer(playerNum)
		ActiveComputer = computer
		ActiveComputerPlayer = playerNum
		ActiveComputerSquare = playerObj:getSquare()
	end
end

--- getComputerFrontSquare
function ComputerMod.getComputerFrontSquare(computer)
	if computer and ComputerMod.isComputer(computer) then
		local square = computer:getSquare()
		local x = square:getX()
		local y = square:getY()
		local z = square:getZ()
		local facing = nil

		if ComputerMod.isComputerOn(computer) then
			facing = ComputerMod.getComputerFacing(computer)
		else
			facing = computer:getProperties():Val("Facing")
		end

		if facing == "S" then
			square = getCell():getGridSquare(x,y+1,z);
		end

		if facing == "E" then
			square = getCell():getGridSquare(x+1,y,z);
		end

		if facing == "N" then
			square = getCell():getGridSquare(x,y-1,z);
		end

		if facing == "W" then
			square = getCell():getGridSquare(x-1,y,z);
		end

		return square
	end
end

local function setComputerOff(computer)
	if computer and ComputerMod.isComputer(computer) then
		local facing = nil

		if ComputerMod.isComputerOn(computer) then
			facing = ComputerMod.getComputerFacing(computer)
		else
			facing = computer:getProperties():Val("Facing")
		end

		computer:setSpriteFromName(ComputerMod.SpriteComputerOff[facing])

		ComputerMod.Events.OnComputerShutDown()
	end
end

local function doToggleComputer(player, computer, newState)
	local playerObj = getSpecificPlayer(player)
	local square = ComputerMod.getComputerFrontSquare(computer)
	ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, square))
	ISTimedActionQueue.add(Action_Computer_Toggle:new(player, computer, 20));
end

local function doOpenMail(player, computer)
	local playerObj = getSpecificPlayer(player)
	local square = ComputerMod.getComputerFrontSquare(computer)
	ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, square))
	ISTimedActionQueue.add(Action_Computer_OpenMail:new(player, computer, 20));
end

local function doOpenNotepad(player, computer)
	local playerObj = getSpecificPlayer(player)
	local square = ComputerMod.getComputerFrontSquare(computer)
	ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, square))
	ISTimedActionQueue.add(Action_Computer_OpenNotepad:new(player, computer, nil, 20));
end

local function doPlayGame(player, computer, game)
	local playerObj = getSpecificPlayer(player)
	local square = ComputerMod.getComputerFrontSquare(computer)
	ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, square))
	ISTimedActionQueue.add(Action_Computer_PlayGame:new(player, computer, game, 100000));
end

local function doInsertDisc(player, computer, disc)
	local playerObj = getSpecificPlayer(player)
	local square = ComputerMod.getComputerFrontSquare(computer)
	ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, square))
	ISTimedActionQueue.add(Action_Computer_InsertCD:new(player, computer, disc, 200));
end

local function doEjectDisc(player, computer)
	local playerObj = getSpecificPlayer(player)
	local square = ComputerMod.getComputerFrontSquare(computer)
	ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, square))
	ISTimedActionQueue.add(Action_Computer_EjectCD:new(player, computer, 200));
end

local function doInstallGame(player, computer, game)
	local playerObj = getSpecificPlayer(player)
	local square = ComputerMod.getComputerFrontSquare(computer)
	ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, square))
	ISTimedActionQueue.add(Action_Computer_InstallGame:new(player, computer, game, 500));
end

local function doUninstallGame(player, computer, game)
	local playerObj = getSpecificPlayer(player)
	local square = ComputerMod.getComputerFrontSquare(computer)
	ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, square))
	ISTimedActionQueue.add(Action_Computer_UninstallGame:new(player, computer, game, 200));
end

local function doComputerMenu(player, context, worldobjects, test)
	if test == true then return end

	local playerObj = getSpecificPlayer(player)
	local playerInv = playerObj:getInventory()
	local square = clickedSquare
	local computer = nil

	if square then

		local objects = square:getObjects()
		for i = 0, objects:size() - 1 do
			local object = objects:get(i)
			if ComputerMod.isComputer(object) then
				computer = object;
				break
			end
		end
		
		if computer then
			local powered = ((SandboxVars.AllowExteriorGenerator and square:haveElectricity()) or (SandboxVars.ElecShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier and not square:isOutside()))
			local state = ComputerMod.isComputerOn(computer)

			local option = context:addOption("Desktop Computer");
			if powered then
				local subContext = ISContextMenu:getNew(context)
				context:addSubMenu(option, subContext)
				
				ComputerMod.Events.OnBeforeInteractionMenuPoweredOptions(player, computer, state, option, subContext)
				ComputerMod.Events.OnInteractionMenuPoweredOptions(player, computer, state, option, subContext)
				ComputerMod.Events.OnAfterInteractionMenuPoweredOptions(player, computer, state, option, subContext)
			else
				option.toolTip = ISToolTip:new()
				option.toolTip.name = "Computer require a power source!"
				setComputerOff(computer)
			end

		end
	end
end

--- Event OnBeforeInteractionMenuPoweredOptions
function ComputerMod.Events.OnBeforeInteractionMenuPoweredOptions(playerNum, computer, state, option, subContext)
	if not state then
		subContext:addOption("Turn on", playerNum, doToggleComputer, computer)
	end
end

--- Event OnInteractionMenuPoweredOptions
function ComputerMod.Events.OnInteractionMenuPoweredOptions(playerNum, computer, state, option, subContext)
	if state then

		local playerObj = getSpecificPlayer(playerNum)
		local playerInv = playerObj:getInventory()
		local currentDisc = ComputerMod.getCurrentDisc(computer)
		local allInstalledGamesIds = ComputerMod.getAllInstalledGameIds(computer)

		if currentDisc then
			if currentDisc.type == "Disc" then
				
			end

			if currentDisc.type == "Disc_Game" then
				local option
				if ComputerMod.isGameInstalled(computer, currentDisc.game) then
					option = subContext:addOption("Play Disc", playerNum, doPlayGame, computer, currentDisc.game)
				elseif ComputerMod.getGame(currentDisc.game.id) then
					option = subContext:addOption("Install Disc", playerNum, doInstallGame, computer, currentDisc.game)
				end
				if option then
					option.toolTip = ISToolTip:new()
					option.toolTip.name = currentDisc.name
					option.toolTip.description = ComputerMod.getGameDiscTooltipDescription(currentDisc.game)
				end
			end

			if currentDisc.type == "Disc_Retail" then
				local option = subContext:addOption("Read Disc", playerNum, doPlayGame, computer)
				option.toolTip = ISToolTip:new()
				option.toolTip.name = currentDisc.name
				option.toolTip.description = ComputerMod.getRetailDiscTooltipDescription(currentDisc.media)
			end

			local option = subContext:addOption("Eject Disc", playerNum, doEjectDisc, computer)
			option.toolTip = ISToolTip:new()
			option.toolTip.name = currentDisc.name

			if currentDisc.type == "Disc" then
				option.toolTip.description = " <RGB:1,0,0> Unknown Disc"
			end

			if currentDisc.type == "Disc_Game" then
				option.toolTip.description = ComputerMod.getGameDiscTooltipDescription(currentDisc.game)
			end

			if currentDisc.type == "Disc_Retail" then
				option.toolTip.description = ComputerMod.getRetailDiscTooltipDescription(currentDisc.media)
			end

		-- Doesnt have a disc inserted
		else
			if not playerInv:contains("Disc") and not playerInv:contains("Disc_Game") and not playerInv:contains("Disc_Retail") then
				local option = subContext:addOption("No disc");
				option.notAvailable = true
			else
				local diskDriveOption = subContext:addOption("Insert Disc");
				local diskDriveContext = ISContextMenu:getNew(subContext)
				subContext:addSubMenu(diskDriveOption, diskDriveContext)
				
				--- Game CD
				if playerInv:contains("Disc_Game") then
					local diskGameOption = diskDriveContext:addOption("Game CD")
					local diskGameContext = ISContextMenu:getNew(diskDriveContext)
					diskDriveContext:addSubMenu(diskGameOption, diskGameContext)
					local items = playerInv:getAllEvalRecurse(function(item)
						return item:getType() == "Disc_Game"
					end)
					for i=0, items:size() - 1 do
						local item = items:get(i)
						local discOption = diskGameContext:addOption(item:getDisplayName(), playerNum, doInsertDisc, computer, item)
						discOption.toolTip = ISToolTip:new()
						discOption.toolTip.name = item:getName()
						discOption.toolTip.description = ComputerMod.getGameDiscTooltipDescription(ComputerMod.getGameDiscData(item))
					end
				end
	
				--- Retail CD
				if playerInv:contains("Disc_Retail") then
					local diskRetailOption = diskDriveContext:addOption("Media CD")
					local diskRetailContext = ISContextMenu:getNew(diskDriveContext)
					diskDriveContext:addSubMenu(diskRetailOption, diskRetailContext)
					local items = playerInv:getAllEvalRecurse(function(item)
						return item:getType() == "Disc_Retail"
					end)
					for i=0, items:size() - 1 do
						local item = items:get(i)
						local discOption = diskRetailContext:addOption(item:getDisplayName(), playerNum, doInsertDisc, computer, item)
						discOption.toolTip = ISToolTip:new()
						discOption.toolTip.name = item:getName()
						discOption.toolTip.description = ComputerMod.getRetailDiscTooltipDescription(ComputerMod.getRetailDiscData(item))
					end
				end
	
				--- Writable CD
				if playerInv:contains("Disc") then
					local diskWritableOption = diskDriveContext:addOption("Writable CD")
					local diskWritableContext = ISContextMenu:getNew(diskDriveContext)
					diskDriveContext:addSubMenu(diskWritableOption, diskWritableContext)
					local items = playerInv:getAllEvalRecurse(function(item)
						return item:getType() == "Disc"
					end)
					for i=0, items:size() - 1 do
						local item = items:get(i)
						local discOption = diskWritableContext:addOption(item:getDisplayName(), playerNum, doInsertDisc, computer, item)
						discOption.toolTip = ISToolTip:new()
						discOption.toolTip.name = item:getName()
						discOption.toolTip.description = " <RGB:1,0,0> Unknown Disc"
					end
				end
			end
		end

		if #allInstalledGamesIds > 0 then
			local uninstallGameOption = subContext:addOption("Uninstall Game")
			local uninstallContext = ISContextMenu:getNew(subContext)
			uninstallContext:addSubMenu(uninstallGameOption, uninstallContext)

			for i=1, #allInstalledGamesIds do
				local game = ComputerMod.getGame(allInstalledGamesIds[i])
				if game then
					local uninstallGameOption = uninstallContext:addOption(game.title, playerNum, doUninstallGame, computer, game)
					uninstallGameOption.toolTip = ISToolTip:new()
					uninstallGameOption.toolTip.name = game.title
					uninstallGameOption.toolTip.description = ComputerMod.getGameDiscTooltipDescription(game)
				end
			end
		end
	end
end

--- Event OnAfterInteractionMenuPoweredOptions
function ComputerMod.Events.OnAfterInteractionMenuPoweredOptions(playerNum, computer, state, option, subContext)
	if state then
		subContext:addOption("Turn off", playerNum, doToggleComputer, computer)
	end
end

--- Event OnComputerStartup
function ComputerMod.Events.OnComputerStartup(computer)
	getSoundManager():PlayWorldSound("ComputerStartupMusic", computer:getSquare(), 0, 8, 1, false);
end

--- Event OnDiscInserted
function ComputerMod.Events.OnDiscInserted(computer, discData)
	
end

--- Event OnDiscEjected
function ComputerMod.Events.OnDiscEjected(computer, discItem)
	
end

--- Event OnComputerShutDown
function ComputerMod.Events.OnComputerShutDown(computer)
	if UI_Computer_Mail.instance then
		UI_Computer_Mail.instance:close()
	end

	if UI_Computer_Notepad.instance then
		UI_Computer_Notepad.instance:close()
	end
end

--- Event OnMovingAwayFromComputer
function ComputerMod.Events.OnMovingAwayFromComputer()
	if UI_Computer_Mail.instance then
		UI_Computer_Mail.instance:close()
	end

	if UI_Computer_Notepad.instance then
		UI_Computer_Notepad.instance:close()
	end
end

local function doOnTickPlayerMoveAwayFromComputer()
	if ActiveComputer ~= nil then
		local playerObj = getSpecificPlayer(ActiveComputerPlayer)
		
		if playerObj and playerObj:getSquare() ~= ActiveComputerSquare then
			ComputerMod.Events.OnMovingAwayFromComputer()

			ActiveComputer = nil
			ActiveComputerPlayer = nil
			ActiveComputerSquare = nil
		end
	end
end

Events.OnPreFillWorldObjectContextMenu.Add(doComputerMenu)
Events.OnTick.Add(doOnTickPlayerMoveAwayFromComputer)
