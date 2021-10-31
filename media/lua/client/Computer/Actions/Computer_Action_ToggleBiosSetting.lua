require "TimedActions/ISBaseTimedAction"

Computer_Action_ToggleBiosSetting = ISBaseTimedAction:derive("Computer_Action_ToggleBiosSetting");

function Computer_Action_ToggleBiosSetting:isValid()
    return self.computer:isBiosActive()
end

function Computer_Action_ToggleBiosSetting:update()
    self.character:faceThisObject(self.computer.isoObject)
end

function Computer_Action_ToggleBiosSetting:start()

end

function Computer_Action_ToggleBiosSetting:stop()
    ISBaseTimedAction.stop(self);
end

function Computer_Action_ToggleBiosSetting:perform()
    self.computer:setBiosValue(self.settingKey, self.settingValue)

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

function Computer_Action_ToggleBiosSetting:new(player, computer, settingKey, settingValue, time)
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
    o.settingKey = settingKey
    o.settingValue = settingValue
    return o;
end
