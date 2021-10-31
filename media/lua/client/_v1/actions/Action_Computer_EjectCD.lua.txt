require "TimedActions/ISBaseTimedAction"

Action_Computer_EjectCD = ISBaseTimedAction:derive("Action_Computer_EjectCD");

function Action_Computer_EjectCD:isValid()
	return ComputerMod.getCurrentDisc(self.computer) ~= nil
end

function Action_Computer_EjectCD:update()
	self.character:faceThisObject(self.computer)
end

function Action_Computer_EjectCD:start()
	if self.sound ~= "" then
		self.audio = self.character:getEmitter():playSound(self.sound)
	end
end

function Action_Computer_EjectCD:stop()
	if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
		self.character:stopOrTriggerSound(self.audio)
	end
	ISBaseTimedAction.stop(self);
end

function Action_Computer_EjectCD:perform()

	local discItem = ComputerMod.ejectDisc(self.character:getInventory(), self.computer)

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function Action_Computer_EjectCD:new(player, computer, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.player = player;
	o.character = getSpecificPlayer(player)
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time;
	-- custom fields
	o.sound = "ComputerEjectDisc"
	o.audio = 0
	o.computer = computer
	return o;
end
