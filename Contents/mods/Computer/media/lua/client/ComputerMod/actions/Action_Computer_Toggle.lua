require "TimedActions/ISBaseTimedAction"

Action_Computer_Toggle = ISBaseTimedAction:derive("Action_Computer_Toggle");

function Action_Computer_Toggle:isValid()
	return true
end

function Action_Computer_Toggle:update()
	self.character:faceThisObject(self.computer)
end

function Action_Computer_Toggle:start()
	if self.sound ~= "" then
		self.audio = self.character:getEmitter():playSound(self.sound)
	end
end

function Action_Computer_Toggle:stop()
	ISBaseTimedAction.stop(self);
end

function Action_Computer_Toggle:perform()
	local facing = nil

	if ComputerMod.isComputerOn(self.computer) then
		facing = ComputerMod.getComputerFacing(self.computer)
		self.computer:setSpriteFromName(ComputerMod.SpriteComputerOff[facing])
		if isClient() then self.computer:transmitUpdatedSpriteToServer() end -- fix for mp
		ComputerMod.Events.OnComputerShutDown(self.computer)
	else
		facing = self.computer:getProperties():Val("Facing")
		self.computer:setSpriteFromName(ComputerMod.SpriteComputerOn[facing])
		if isClient() then self.computer:transmitUpdatedSpriteToServer() end -- fix for mp
		ComputerMod.Events.OnComputerStartup(self.computer)
	end

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function Action_Computer_Toggle:new(player, computer, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.player = player;
	o.character = getSpecificPlayer(player)
	o.stopOnWalk = true;
	o.stopOnRun = true;
	o.maxTime = time;
	-- custom fields
	o.sound = "ComputerToggle"
	o.audio = 0
	o.computer = computer
	return o;
end
