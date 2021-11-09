require "TimedActions/ISBaseTimedAction"

Action_Computer_PlayGame = ISBaseTimedAction:derive("Action_Computer_PlayGame");

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

	self.character:getStats():setStress(self.character:getStats():getStress() - (0.0005 * getGameTime():getMultiplier()))
	self.character:getBodyDamage():setBoredomLevel(self.character:getBodyDamage():getBoredomLevel() - (ZomboidGlobals.BoredomDecrease * 1.5 * getGameTime():getMultiplier()))

	if math.fmod(self.haloDelay, 300) == 0 then
		HaloTextHelper.addTextWithArrow(self.character, getText("IGUI_HaloNote_Boredom"), false, HaloTextHelper.getColorGreen())
	end
	self.haloDelay = self.haloDelay + 1
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
	if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
		self.character:stopOrTriggerSound(self.audio)
	end
	if self.audio2 ~= 0 and self.character:getEmitter():isPlaying(self.audio2) then
		self.character:stopOrTriggerSound(self.audio2)
	end
	ISBaseTimedAction.stop(self);
end

function Action_Computer_PlayGame:perform()
	if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
		self.character:stopOrTriggerSound(self.audio)
	end
	if self.audio2 ~= 0 and self.character:getEmitter():isPlaying(self.audio2) then
		self.character:stopOrTriggerSound(self.audio2)
	end
	-- needed to remove from queue / start next.
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
	o.maxTime = time;
	-- custom fields
	o.haloDelay = 1
	o.game = game
	o.sound = "ComputerMouseClicks"
	o.music = "ComputerGame1"
	o.audio = 0
	o.audio2 = 0
	o.computer = computer
	return o;
end
