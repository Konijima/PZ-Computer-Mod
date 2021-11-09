require "TimedActions/ISBaseTimedAction"

Action_Computer_InsertCD = ISBaseTimedAction:derive("Action_Computer_InsertCD");

function Action_Computer_InsertCD:isValid()
	return ComputerMod.getCurrentDisc(self.computer) == nil and self.character:getInventory():contains(self.disc)
end

function Action_Computer_InsertCD:update()
	self.character:faceThisObject(self.computer)
end

function Action_Computer_InsertCD:start()
	if self.sound ~= "" then
		self.audio = self.character:getEmitter():playSound(self.sound)
	end
end

function Action_Computer_InsertCD:stop()
	if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
		self.character:stopOrTriggerSound(self.audio)
	end
	ISBaseTimedAction.stop(self);
end

function Action_Computer_InsertCD:perform()

	local currentDisc = ComputerMod.insertDisc(self.character:getInventory(), self.computer, self.disc)

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function Action_Computer_InsertCD:new(player, computer, disc, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.player = player;
	o.character = getSpecificPlayer(player)
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time;
	-- custom fields
	o.sound = "ComputerInsertDisc"
	o.audio = 0
	o.computer = computer
	o.disc = disc
	return o;
end
