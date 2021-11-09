require "TimedActions/ISBaseTimedAction"

Action_Computer_UninstallGame = ISBaseTimedAction:derive("Action_Computer_UninstallGame");

function Action_Computer_UninstallGame:isValid()
	return ComputerMod.isGameInstalled(self.computer, self.game)
end

function Action_Computer_UninstallGame:update()
	self.character:faceThisObject(self.computer)
end

function Action_Computer_UninstallGame:start()
	if self.sound ~= "" then
		self.audio = self.character:getEmitter():playSound(self.sound)
	end
end

function Action_Computer_UninstallGame:stop()
    if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
		self.character:stopOrTriggerSound(self.audio)
	end
	ISBaseTimedAction.stop(self);
end

function Action_Computer_UninstallGame:perform()
	if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
		self.character:stopOrTriggerSound(self.audio)
	end
	
	ComputerMod.uninstallGame(self.computer, self.game)

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function Action_Computer_UninstallGame:new(player, computer, game, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.player = player;
	o.character = getSpecificPlayer(player)
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time;
	-- custom fields
	o.sound = "ComputerKeyboardFast"
	o.audio = 0
	o.computer = computer
	o.game = game
	return o;
end
