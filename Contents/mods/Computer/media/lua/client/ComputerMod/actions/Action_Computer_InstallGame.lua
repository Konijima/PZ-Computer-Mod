require "TimedActions/ISBaseTimedAction"

Action_Computer_InstallGame = ISBaseTimedAction:derive("Action_Computer_InstallGame");

function Action_Computer_InstallGame:isValid()
	return ComputerMod.getCurrentDisc(self.computer) ~= nil and not ComputerMod.isGameInstalled(self.computer, self.game)
end

function Action_Computer_InstallGame:update()
	self.character:faceThisObject(self.computer)
end

function Action_Computer_InstallGame:start()
	if self.sound ~= "" then
		self.audio = self.character:getEmitter():playSound(self.sound)
	end
end

function Action_Computer_InstallGame:stop()
    if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
		self.character:stopOrTriggerSound(self.audio)
	end
	ISBaseTimedAction.stop(self);
end

function Action_Computer_InstallGame:perform()

	ComputerMod.installGame(self.computer, self.game)

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function Action_Computer_InstallGame:new(player, computer, game, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.player = player;
	o.character = getSpecificPlayer(player)
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time;
	-- custom fields
	o.sound = "ComputerDiscActivity"
	o.audio = 0
	o.computer = computer
	o.game = game
	return o;
end
