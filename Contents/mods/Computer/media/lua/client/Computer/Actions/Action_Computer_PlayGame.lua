require "TimedActions/ISBaseTimedAction"

local Action_Computer_PlayGame = ISBaseTimedAction:derive("Action_Computer_PlayGame");

function Action_Computer_PlayGame:isValid()
	return ComputerMod.getCurrentDisc(self.computer) ~= nil and ComputerMod.isGameInstalled(self.computer, self.game)
end

function Action_Computer_PlayGame:update()
	if self.sound ~= "" and self.audio ~= 0 and not self.character:getEmitter():isPlaying(self.audio) then
		self.audio = self.character:getEmitter():playSound(self.sound)
	end
	if self.music ~= "" and self.audio2 ~= 0 and not self.character:getEmitter():isPlaying(self.audio2) then
		self.audio2 = self.character:getEmitter():playSound(self.music)
	end

	self.character:PlayAnim("Idle")
	self.character:faceThisObject(self.computer)

	self.character:getStats():setStress(self.character:getStats():getStress() - (0.0001 * getGameTime():getMultiplier()))
	self.character:getStats():setFatigue(self.character:getStats():getFatigue() + (0.000015 * getGameTime():getMultiplier()))
	self.character:getBodyDamage():setBoredomLevel(self.character:getBodyDamage():getBoredomLevel() - (0.01 * getGameTime():getMultiplier()))

	local boredom = self.character:getBodyDamage():getBoredomLevel() / 100
	local fatigue = self.character:getStats():getFatigue()
	local thirst = self.character:getStats():getThirst()
	local hunger = self.character:getStats():getHunger()
	local stress = self.character:getStats():getStress()

	if math.fmod(self.speechDelay, 1250) == 0 then
		self.character:Say(getText("UI_Computer_FunSpeech_" .. ZombRand(0, 26)))
	end

	if math.fmod(self.haloDelay, 750) == 0 then
		if boredom > stress and boredom > 0 then
			HaloTextHelper.addTextWithArrow(self.character, getText("IGUI_HaloNote_Boredom"), false, HaloTextHelper.getColorGreen())
		elseif stress > boredom and stress > 0 then
			HaloTextHelper.addTextWithArrow(self.character, getText("IGUI_HaloNote_Stress"), false, HaloTextHelper.getColorGreen())
		elseif fatigue > 0 then
			HaloTextHelper.addTextWithArrow(self.character, getText("IGUI_HaloNote_Fatigue"), true, HaloTextHelper.getColorRed())
		end
	end
	self.speechDelay = self.speechDelay + 1
	self.haloDelay = self.haloDelay + 1

	if fatigue >= 0.9 then
		self.character:Say(getText("UI_Computer_TiredSpeech_" .. ZombRand(0, 3)))
		self:stopAction()
	elseif thirst >= 0.85 then
		self.character:Say(getText("UI_Computer_ThirstySpeech_" .. ZombRand(0, 3)))
		self:stopAction()
	elseif hunger >= 0.7 then
		self.character:Say(getText("UI_Computer_HungrySpeech_" .. ZombRand(0, 3)))
		self:stopAction()
	end
end

function Action_Computer_PlayGame:stopAction()
	if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
		self.character:stopOrTriggerSound(self.audio)
	end
	if self.audio2 ~= 0 and self.character:getEmitter():isPlaying(self.audio2) then
		self.character:stopOrTriggerSound(self.audio2)
	end
	ISBaseTimedAction.forceStop(self);
end

function Action_Computer_PlayGame:start()
	if self.sound ~= "" then
		self.audio = self.character:getEmitter():playSound(self.sound)
	end
	if self.music ~= "" then
		self.audio2 = self.character:getEmitter():playSound(self.music)
	end
end

function Action_Computer_PlayGame:stop()
	self:stopAction()
end

function Action_Computer_PlayGame:perform()
	self:stopAction()
end

function Action_Computer_PlayGame:new(player, computer, game, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.player = player;
	o.character = getSpecificPlayer(player)
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time;
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

return Action_Computer_PlayGame