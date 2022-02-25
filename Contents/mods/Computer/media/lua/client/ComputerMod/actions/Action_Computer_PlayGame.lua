require "TimedActions/ISBaseTimedAction"

Action_Computer_PlayGame = ISBaseTimedAction:derive("Action_Computer_PlayGame");

Action_Computer_PlayGame.TotalPlayTime = 10000;

function Action_Computer_PlayGame:isValid()
	return true;
end

function Action_Computer_PlayGame:update()
	if self.sound ~= "" and self.audio ~= 0 and not self.character:getEmitter():isPlaying(self.audio) then
		self.audio = self.character:getEmitter():playSound(self.sound)
	end
	if self.music ~= "" and self.audio2 ~= 0 and not self.character:getEmitter():isPlaying(self.audio2) then
		self.audio2 = self.character:getEmitter():playSound(self.music)
	end

	self.character:faceThisObject(self.computer)

	local stats = self.character:getStats();
	local body = self.character:getBodyDamage();
	local multiplier = getGameTime():getMultiplier();

	local thirst = stats:getThirst();
	local hunger = stats:getHunger();

	local stress = stats:getStress();
	stress = stress - 0.0001 * multiplier;
	stress = math.max(0, stress);

	local unhappyness = body:getUnhappynessLevel();
	unhappyness = unhappyness - 0.01 * multiplier;
	unhappyness = math.max(0, unhappyness);
	
	local boredom = body:getBoredomLevel();
	boredom = boredom - 0.005 * multiplier;
	boredom = math.max(0, boredom);

	local fatigue = stats:getFatigue();
	fatigue = fatigue + 0.00003 * multiplier;
	fatigue = math.min(1, fatigue);

	local endurance = stats:getEndurance();
	endurance = endurance + 0.00005 * multiplier;
	endurance = math.min(1, endurance);
	
	stats:setStress(stress);
	stats:setFatigue(fatigue);
	stats:setEndurance(endurance);
	body:setBoredomLevel(boredom);
	body:setUnhappynessLevel(unhappyness);
	
	if math.fmod(self.speechDelay, 1250) == 0 then
		self.character:Say(getText("UI_Computer_FunSpeech_" .. ZombRand(0, 26)))
	end

	if math.fmod(self.haloDelay, 750) == 0 then
		if boredom > 0 then
			HaloTextHelper.addTextWithArrow(self.character, getText("IGUI_HaloNote_Boredom"), false, HaloTextHelper.getColorGreen())
		end
		if stress > 0 then
			HaloTextHelper.addTextWithArrow(self.character, getText("IGUI_HaloNote_Stress"), false, HaloTextHelper.getColorGreen())
		end
		if unhappyness > 0 then
			HaloTextHelper.addTextWithArrow(self.character, getText("IGUI_HaloNote_Unhappiness"), false, HaloTextHelper.getColorGreen())
		end
		if endurance < 0.9 then
			HaloTextHelper.addTextWithArrow(self.character, getText("IGUI_HaloNote_Endurance"), true, HaloTextHelper.getColorGreen())
		end
		
		HaloTextHelper.addTextWithArrow(self.character, getText("IGUI_HaloNote_Fatigue"), true, HaloTextHelper.getColorRed())
	end
	self.speechDelay = self.speechDelay + 1
	self.haloDelay = self.haloDelay + 1

	if fatigue >= 0.9 then
		self.character:Say(getText("UI_Computer_TiredSpeech_" .. ZombRand(0, 3)))
		self:stop()
	elseif thirst >= 0.85 then
		self.character:Say(getText("UI_Computer_ThirstySpeech_" .. ZombRand(0, 3)))
		self:stop()
	elseif hunger >= 0.7 then
		self.character:Say(getText("UI_Computer_HungrySpeech_" .. ZombRand(0, 3)))
		self:stop()
	end

	
	if self.modData.playedGameCD["GameCD_" .. self.game.title] < Action_Computer_PlayGame.TotalPlayTime then
		self.modData.playedGameCD["GameCD_" .. self.game.title] = self.modData.playedGameCD["GameCD_" .. self.game.title] + getGameTime():getMultiplier();
	end

	addSound(self.character, self.character:getX(), self.character:getY(), self.character:getZ(), 15, 15);
end

function Action_Computer_PlayGame:stopSounds()
	if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
		self.character:stopOrTriggerSound(self.audio)
	end
	if self.audio2 ~= 0 and self.character:getEmitter():isPlaying(self.audio2) then
		self.character:stopOrTriggerSound(self.audio2)
	end
end

function Action_Computer_PlayGame:start()
	if self.sound ~= "" then
		self.audio = self.character:getEmitter():playSound(self.sound)
	end
	if self.music ~= "" then
		self.audio2 = self.character:getEmitter():playSound(self.music)
	end

	-- Continue where we left off
	if self.modData.playedGameCD["GameCD_" .. self.game.title] < Action_Computer_PlayGame.TotalPlayTime then
		self.modData.playedGameCD["GameCD_" .. self.game.title] = self.modData.playedGameCD["GameCD_" .. self.game.title] + getGameTime():getMultiplier();
		self:setCurrentTime(self.modData.playedGameCD["GameCD_" .. self.game.title]);
	end

	self:setActionAnim("Loot");
	self:setAnimVariable("LootPosition", "");
	self.character:clearVariable("LootPosition");
	if self.computer:getRenderYOffset() < 0 then
		self:setAnimVariable("LootPosition", "Low");
	end
	self:setOverrideHandModels(nil, nil);
end

function Action_Computer_PlayGame:stop()
	self:stopSounds()
	ISBaseTimedAction.stop(self);
	self.action:forceStop();
end

function Action_Computer_PlayGame:perform()
	self:stopSounds();

	-- Say something when game has been completed
	self.character:Say(getText("UI_Computer_PlayCompleteSpeech_" .. ZombRand(0, 3)));

	ISBaseTimedAction.perform(self);
end

function Action_Computer_PlayGame:new(player, computer, game, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.player = player;
	o.character = getSpecificPlayer(player)
	o.stopOnWalk = true;
	o.stopOnRun = true;

	-- Prepare Game Current Progress
	o.modData = o.character:getModData();
	o.modData.playedGameCD = o.modData.playedGameCD or {};
	o.modData.playedGameCD["GameCD_" .. game.title] = o.modData.playedGameCD["GameCD_" .. game.title] or 0;

	-- Set Max Time
	if o.modData.playedGameCD["GameCD_" .. game.title] < Action_Computer_PlayGame.TotalPlayTime then
		o.maxTime = Action_Computer_PlayGame.TotalPlayTime;
	else
		o.maxTime = -1;
		o.character:Say(getText("UI_Computer_PlayAgainSpeech_" .. ZombRand(0, 3), game.title));
	end

	-- custom fields
	o.speechDelay = 1
	o.haloDelay = 1
	o.game = ComputerMod.getGame(game.id)
	o.sound = "ComputerMouseClicks"
	if type(o.game.audio) == "string" then
		o.music = o.game.audio
	else
		o.music = ComputerMod.getRandomAudio()
	end
	o.audio = 0
	o.audio2 = 0
	o.computer = computer
	return o;
end
