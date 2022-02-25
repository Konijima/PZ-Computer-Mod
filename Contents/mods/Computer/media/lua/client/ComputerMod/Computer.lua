local GameAPI = require("ComputerMod/GameAPI");

-- PROBLEMS/BUGS
--- Doesn't consume power
--- Doesn't turn off when power is down
--- Power off only when interacting with it while power is down

--[[local activeMods = getActivatedMods(); -- I believe an arrayList?
if not activeMods:contains("CommunityAPI") then

	print("Computer V1: CommunityAPI not found!")
	local PopupCommunityAPI = require("PopupCommunityAPI")
	Events.OnGameStart.Add(PopupCommunityAPI.Open)

else

	print("Computer V1: CommunityAPI is loaded!")

end]]

local ActiveComputer = nil
local ActiveComputerPlayer = nil
local ActiveComputerSquare = nil
local MaxGames = 8;
local LightSources = {};

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

local function evalRecurseDiscGame(item)
	return item:getType() == "Disc_Game"
end

function ComputerMod.GetComputerOnSquare(square)
	local computer;
	local objects = square:getObjects()
	for i = 0, objects:size() - 1 do
		local object = objects:get(i)
		if ComputerMod.isComputer(object) then
			computer = object;
			break
		end
	end
	return computer;
end

function ComputerMod.AddLight(computer)
	local x, y, z = computer:getX(), computer:getY(), computer:getZ();
	local id = x .. "|" .. y .. "|" .. z;
	if LightSources[id] then
		getCell():removeLamppost(LightSources[id]);
	end
	LightSources[id] = IsoLightSource.new(x, y, z, 0.5, 1, 0.5, 3);
	getCell():addLamppost(LightSources[id]);
end

function ComputerMod.RemoveLight(computer)
	local x, y, z = computer:getX(), computer:getY(), computer:getZ();
	local id = x .. "|" .. y .. "|" .. z;
	if LightSources[id] then
		getCell():removeLamppost(LightSources[id]);
		LightSources[id] = nil;
	end
end

--- addGame
function ComputerMod.addGame(id, title, date, publisher, genre, audio)
	GameAPI.Add(id, title, date, publisher, genre, audio);
	-- if ComputerMod.Games[id] == nil then
	-- 	local newGame = {
	-- 		id = id,
	-- 		title = title,
	-- 		date = date,
	-- 		publisher = publisher,
	-- 		genre = genre,
	-- 		audio = audio,
	-- 	}
	-- 	ComputerMod.Games[id] = newGame
	-- 	print("Adding computer game: " .. id)
	-- 	return newGame
	-- end
end

function ComputerMod.getRandomAudio()
	return "ComputerGame" .. ZombRand(1, 14)
end

--- getAllGames
function ComputerMod.getAllGames()
	return GameAPI.GetAll();
	-- return ComputerMod.Games
end

--- getGame
function ComputerMod.getGame(id)
	return GameAPI.Get(id);
	-- return ComputerMod.Games[id]
end

--- getRandomGame
function ComputerMod.getRandomGame()
	return GameAPI.GetRandom();
	-- local keys = {}
	-- for k in pairs(ComputerMod.Games) do
	-- 	table.insert(keys, k)
	-- end
	-- local rand = ZombRand(#keys+1)
	-- local game = ComputerMod.Games[keys[rand]]
	-- return game
end

--- getGameDiscTooltipDescription
function ComputerMod.getGameDiscTooltipDescription(game)
	local gameData
	if game then
		gameData = ComputerMod.getGame(game.id)
	end
	local description = ""
	if gameData then
		description = " <RGB:1,1,0.8> Title: <RGB:1,1,1> <SPACE> " .. gameData.title
		description = description .. " <LINE> <RGB:1,1,0.8> Publisher: <RGB:1,1,1> <SPACE> " .. gameData.publisher
		--description = description .. " <LINE> <RGB:1,1,0.8> Released:      <RGB:1,1,1> " .. gameData.date
		description = description .. " <LINE> <RGB:1,1,0.8> Genre: <RGB:1,1,1> <SPACE> " .. gameData.genre
	else
		description = " <RGB:1,0,0> Unknown Disc"
	end
	return description
end

--- getRetailDiscTooltipDescription
function ComputerMod.getRetailDiscTooltipDescription(media)
	local description = ""
	description = " <RGB:1,1,0.8> Title: <RGB:1,1,1> <SPACE> " .. media.title
	description = description .. " <LINE> <RGB:1,1,0.8> Author: <RGB:1,1,1> <SPACE>" .. media.author
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
		if disc:getModData().game and ComputerMod.getGame(disc:getModData().game.id) then
			return ComputerMod.getGame(disc:getModData().game.id)
		end
	end
end

--- setGameDiscData
function ComputerMod.setGameDiscData(disc, game)
	if disc and disc:getType() == "Disc_Game" then
		disc:setName("Game CD: " .. game.title)
		local modData = disc:getModData()
		modData.game = game
		--modData:transmitModData()
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

function ComputerMod.isComputerPowered(computer)
	return computer and ((SandboxVars.AllowExteriorGenerator and computer:getSquare():haveElectricity()) or (SandboxVars.ElecShutModifier > -1 and GameTime:getInstance():getNightsSurvived() < SandboxVars.ElecShutModifier and not computer:getSquare():isOutside()))
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
			computer:transmitModData() -- fix for mp
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
			computer:transmitModData() -- fix for mp

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
				if game and computerData.installedGames[i] == game.id and ComputerMod.getGame(game.id) then
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
			computer:transmitModData() -- fix for mp
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
					computer:transmitModData() -- fix for mp
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

			computer:setSpriteFromName(ComputerMod.SpriteComputerOff[facing])
			if isClient() then computer:transmitUpdatedSpriteToServer() end
	
			ComputerMod.Events.OnComputerShutDown(computer)
		end
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
	ISTimedActionQueue.add(Action_Computer_InstallGame:new(player, computer, game, 300));
end

local function doUninstallGame(player, computer, game)
	local playerObj = getSpecificPlayer(player)
	local square = ComputerMod.getComputerFrontSquare(computer)
	ISTimedActionQueue.add(ISWalkToTimedAction:new(playerObj, square))
	ISTimedActionQueue.add(Action_Computer_UninstallGame:new(player, computer, game, 150));
end

local function doComputerMenu(player, context, worldobjects, test)
	if test == true then return end
	
	local playerObj = getSpecificPlayer(player)
	local playerInv = playerObj:getInventory()
	local computer = nil

	if clickedSquare then

		computer = ComputerMod.GetComputerOnSquare(clickedSquare);

		if not computer then
			for i = 1, #worldobjects do
				if ComputerMod.isComputer(worldobjects[i]) then
					computer = worldobjects[i];
					print("Found computer in worldobjects")
					break
				end
			end
		end

		if not computer then
			local sx, sy, sz = clickedSquare:getX(), clickedSquare:getY(), clickedSquare:getZ();
			local square = getCell():getGridSquare(sx + 1, sy + 1, sz);
			if square then
				computer = ComputerMod.GetComputerOnSquare(square);
				if computer then
					print("Found computer in offset position")
				end
			end
		end
		
		if computer then
			local state = ComputerMod.isComputerOn(computer)

			local option = context:addOptionOnTop("Desktop Computer");
			if ComputerMod.isComputerPowered(computer) then
				local subContext = ISContextMenu:getNew(context)
				context:addSubMenu(option, subContext)
				
				ComputerMod.Events.OnBeforeInteractionMenuPoweredOptions(player, computer, state, option, subContext)
				ComputerMod.Events.OnInteractionMenuPoweredOptions(player, computer, state, option, subContext)
				ComputerMod.Events.OnAfterInteractionMenuPoweredOptions(player, computer, state, option, subContext)
			else
				option.toolTip = ISToolTip:new()
				option.toolTip.name = "Desktop Computer"
				option.toolTip.description = " <RGB:1,0.3,0.3> A power source is required!"
				option.toolTip:setTexture("appliances_com_01_73");
				option.notAvailable = true;
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

		local computerInfoOption = subContext:addOption("Computer Info");
		computerInfoOption.toolTip = ISToolTip:new();
		computerInfoOption.toolTip.name = "Computer Info";
		computerInfoOption.toolTip:setTexture("appliances_com_01_77");
		local currentDiscName = "none";
		if currentDisc and currentDisc.game then currentDiscName = currentDisc.game.title; end
		local description = " <RGB:1,1,0.8> Installed Games: <RGB:1,1,1> <LINE> " .. tostring(#allInstalledGamesIds) .. "/" .. tostring(MaxGames) .. " <LINE><LINE>";
		description = description .. " <RGB:1,1,0.8> Current Disc: <RGB:1,1,1> <LINE> " .. currentDiscName;
		computerInfoOption.toolTip.description = description;

		if currentDisc then
			if currentDisc.type == "Disc" then
				-- option = subContext:addOption("Play Game", playerNum, doPlayGame, computer, currentDisc.game)
			end

			if currentDisc.type == "Disc_Game" then
				local option;
				if currentDisc.game then
					local game = ComputerMod.getGame(currentDisc.game.id);
					option = subContext:addOption("Play Disc", playerNum, doPlayGame, computer, game)
					option.toolTip = ISToolTip:new()
					option.toolTip:setTexture("Item_Disc");
					option.toolTip.name = "Play " .. currentDisc.name
					option.toolTip.description = ComputerMod.getGameDiscTooltipDescription(currentDisc.game)
				end

				if currentDisc.game and not ComputerMod.isGameInstalled(computer, currentDisc.game) then
					option = subContext:addOption("Install Disc", playerNum, doInstallGame, computer, currentDisc.game)
					option.toolTip = ISToolTip:new()
					option.toolTip:setTexture("Item_Disc");
					option.toolTip.name = "Install " .. currentDisc.name
					if #allInstalledGamesIds >= MaxGames then
						option.notAvailable = true;
						option.toolTip.description = " <RGB:1,0.3,0.3> Not enough space available to install this disc.";
					else
						option.toolTip.description = ComputerMod.getGameDiscTooltipDescription(currentDisc.game)
					end
				end
			end

			if currentDisc.type == "Disc_Retail" then
				--local option = subContext:addOption("Read Disc", playerNum, doPlayGame, computer)
				--option.toolTip = ISToolTip:new()
				--option.toolTip.name = currentDisc.name
				--option.toolTip.description = ComputerMod.getRetailDiscTooltipDescription(currentDisc.media)
			end

			local option = subContext:addOption("Eject Disc", playerNum, doEjectDisc, computer)
			option.toolTip = ISToolTip:new()
			option.toolTip:setTexture("Item_Disc");
			option.toolTip.name = "Eject " .. currentDisc.name

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
					local items = playerInv:getAllEvalRecurse(evalRecurseDiscGame)
					local discAdded = ArrayList.new();
					for i=0, items:size() - 1 do
						local item = items:get(i)
						local game = item:getModData().game;
						local displayName = item:getDisplayName();
						local description = ComputerMod.getGameDiscTooltipDescription(ComputerMod.getGameDiscData(item));
						if not discAdded:contains(displayName) then
							discAdded:add(displayName);
							if ComputerMod.isGameInstalled(computer, game) then
								displayName = displayName .. " (Installed)";
								description = description .. " <LINE> <LINE> (Disc Already Installed)"
							end
							local discOption = diskDriveContext:addOption(displayName, playerNum, doInsertDisc, computer, item)
							discOption.toolTip = ISToolTip:new()
							discOption.toolTip:setTexture("Item_Disc");
							discOption.toolTip.name = "Insert " .. item:getName()
							discOption.toolTip.description = description;
						end
					end
				end
			end
		end

		if #allInstalledGamesIds > 0 then

			-- Play Installed Discs
			local playGameOption = subContext:addOption("Play Game");
			local playGameContext = ISContextMenu:getNew(subContext);
			subContext:addSubMenu(playGameOption, playGameContext);
			for i = 1, #allInstalledGamesIds do
				local game = ComputerMod.getGame(allInstalledGamesIds[i]);
				if game then
					local gameOption = playGameContext:addOption(game.title, playerNum, doPlayGame, computer, game)
					gameOption.toolTip = ISToolTip:new()
					gameOption.toolTip.name = "Play " .. game.title
					gameOption.toolTip.description = ComputerMod.getGameDiscTooltipDescription(game)
				end
			end
			
			-- Uninstall Installed Discs
			local uninstallGameOption = subContext:addOption("Uninstall Game")
			local uninstallContext = ISContextMenu:getNew(subContext)
			uninstallContext:addSubMenu(uninstallGameOption, uninstallContext)
			for i=1, #allInstalledGamesIds do
				local game = ComputerMod.getGame(allInstalledGamesIds[i])
				if game then
					local uninstallGameOption = uninstallContext:addOption(game.title, playerNum, doUninstallGame, computer, game)
					uninstallGameOption.toolTip = ISToolTip:new()
					uninstallGameOption.toolTip.name = "Uninstall " .. game.title
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
	if computer then
		local data = {
			x = computer:getX(),
			y = computer:getY(),
			z = computer:getZ(),
		};
		sendClientCommand("ComputerMod", "ComputerTurnedOn", data);
		getSoundManager():PlayWorldSound("ComputerStartupMusic", computer:getSquare(), 0, 8, 1, false);
		ComputerMod.AddLight(computer);
	end
end

--- Event OnComputerShutDown
function ComputerMod.Events.OnComputerShutDown(computer)
	if computer then
		if UI_Computer_Mail.instance then
			UI_Computer_Mail.instance:close()
		end
	
		if UI_Computer_Notepad.instance then
			UI_Computer_Notepad.instance:close()
		end
	
		local data = {
			x = computer:getX(),
			y = computer:getY(),
			z = computer:getZ(),
		};
		sendClientCommand("ComputerMod", "ComputerTurnedOff", data);
	
		ComputerMod.RemoveLight(computer);
	end
end

--- Event OnDiscInserted
function ComputerMod.Events.OnDiscInserted(computer, discData)
	
end

--- Event OnDiscEjected
function ComputerMod.Events.OnDiscEjected(computer, discItem)
	
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

-- --- Find all ComputerMedium in container when loot is spawning
-- ---@param containerName string
-- ---@param containerType string
-- ---@param container ItemContainer
-- local function OnFillContainer(containerName, containerType, container)
-- 	if instanceof(container, "ItemContainer") then
-- 		if container and container:contains("Disc_Game") then
-- 			local containerItems = container:getItems()
-- 			if containerItems and containerItems:size() > 0 then
-- 				for cindex=0,containerItems:size()-1 do
-- 					local citem = containerItems:get(cindex)
-- 					if citem:getType() == "Disc_Game" then
-- 						if not ComputerMod.getGameDiscData(citem) then
-- 							local game = ComputerMod.getRandomGame()
-- 							if game then
-- 								ComputerMod.setGameDiscData(citem, game)
-- 								print("Randomize new Game CD:")
-- 								print("Title: " .. tostring(game.title))
-- 								print("Date: " .. tostring(game.date))
-- 								print("Publisher: " .. tostring(game.publisher))
-- 								print("Genre: " .. tostring(game.genre))
-- 							end
-- 						end
-- 					end
-- 				end
-- 			end
-- 		end
-- 	end
-- end

local function OnPreFillInventoryObjectContextMenu(player, context, items)
	local foundCds = ArrayList.new();
	for i = 1, #items do
		if instanceof(items[i], "InventoryItem") and items[i]:getType() == "Disc_Game" then
			foundCds:add(items[i]);
		elseif items[i].items then
			for j = 1, #items[i].items do
				if instanceof(items[i].items[j], "InventoryItem") and items[i].items[j]:getType() == "Disc_Game" and not foundCds:contains(items[i].items[j]) then
					foundCds:add(items[i].items[j]);
				end
			end
		end
	end
	print("Found " .. tostring(foundCds:size()) .. " game cd")
	for i = 0, foundCds:size() - 1 do
		local gameCd = foundCds:get(i);
		if not ComputerMod.getGameDiscData(gameCd) then
			GameAPI.RandomizeDiscItem(gameCd);
		end
	end
end

local function loadGridsquare(square)
	local computer = ComputerMod.GetComputerOnSquare(square);
	if computer and ComputerMod.isComputerOn(computer) then
		if ComputerMod.isComputerPowered(computer) then
			ComputerMod.AddLight(computer);
		else
			setComputerOff(computer);
		end
	end
end
Events.LoadGridsquare.Add(loadGridsquare);

local function onServerCommands(module, command, data)
	if module ~= "ComputerMod" then return; end

	if command == "ComputerTurnedOn" then
		local square = getCell():getGridSquare(data.x, data.y, data.z);
		if square then
			local computer = ComputerMod.GetComputerOnSquare(square);
			ComputerMod.AddLight(computer);
		end
	end

	if command == "ComputerTurnedOff" then
		local square = getCell():getGridSquare(data.x, data.y, data.z);
		if square then
			local computer = ComputerMod.GetComputerOnSquare(square);
			ComputerMod.RemoveLight(computer);
		end
	end
end
Events.OnServerCommand.Add(onServerCommands);

-- Events.OnFillContainer.Add(OnFillContainer)
Events.OnFillInventoryObjectContextMenu.Add(OnPreFillInventoryObjectContextMenu)
Events.OnFillWorldObjectContextMenu.Add(doComputerMenu)
Events.OnTick.Add(doOnTickPlayerMoveAwayFromComputer)