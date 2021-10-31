require "TimedActions/ISBaseTimedAction"
require("Computer/UI/ComputerHardwareManagement")

Computer_Action_HardwareManagement = ISBaseTimedAction:derive("Computer_Action_HardwareManagement");

function Computer_Action_HardwareManagement:isValid()
    return self.computer ~= nil
end

function Computer_Action_HardwareManagement:update()
    self.character:faceThisObject(self.computer.isoObject)
end

function Computer_Action_HardwareManagement:start()
    self:setActionAnim("VehicleWorkOnMid")
end

function Computer_Action_HardwareManagement:stop()
    ISBaseTimedAction.stop(self);
end

function Computer_Action_HardwareManagement:perform()

    -- OPEN UI HERE
    local PCUI = ComputerHardwareManagement:new(self.player, self.computer)
    PCUI:initialise()
    PCUI:addToUIManager()

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

function Computer_Action_HardwareManagement:new(player, computer, time)
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
    return o;
end
