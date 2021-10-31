require "TimedActions/ISBaseTimedAction"

Computer_Action_ToggleComputer = ISBaseTimedAction:derive("Computer_Action_ToggleComputer");

function Computer_Action_ToggleComputer:isValid()
    return self.computer ~= nil and self.computer:hasElectricity()
end

function Computer_Action_ToggleComputer:update()
    self.character:faceThisObject(self.computer.isoObject)
end

function Computer_Action_ToggleComputer:start()
	self:setActionAnim("VehicleWorkOnMid")
end

function Computer_Action_ToggleComputer:stop()
    ISBaseTimedAction.stop(self);
end

function Computer_Action_ToggleComputer:perform()
    self.computer:toggleState(self.inBios)

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

function Computer_Action_ToggleComputer:new(player, computer, inBios, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.player = player;
    o.character = getSpecificPlayer(player)
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    -- custom fields
    o.computer = computer
    o.inBios = inBios
    return o;
end
