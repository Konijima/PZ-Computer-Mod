require "TimedActions/ISBaseTimedAction"

Action_Computer_OpenMail = ISBaseTimedAction:derive("Action_Computer_OpenMail");

function Action_Computer_OpenMail:isValid()
	return true
end

function Action_Computer_OpenMail:update()
	self.character:faceThisObject(self.computer)
end

function Action_Computer_OpenMail:start()
	
end

function Action_Computer_OpenMail:stop()
	ISBaseTimedAction.stop(self);
end

function Action_Computer_OpenMail:perform()
	if UI_Computer_Mail.instance then
		UI_Computer_Mail.instance:close()
	end

	local modal = UI_Computer_Mail:new(0, 0, 300, 200, self.character)
	modal:initialise();
	modal:addToUIManager();

	-- Set computer as active
	ComputerMod.setActiveComputer(self.computer, self.player)

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function Action_Computer_OpenMail:new(player, computer, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.player = player
	o.character = getSpecificPlayer(player)
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = time
	-- custom fields
	o.computer = computer
	return o;
end
