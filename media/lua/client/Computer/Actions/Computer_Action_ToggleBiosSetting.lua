require "TimedActions/ISBaseTimedAction"

Computer_Action_ToggleBiosSetting = ISBaseTimedAction:derive("Computer_Action_ToggleBiosSetting");

function Computer_Action_ToggleBiosSetting:isValid()
    return self.computer:exist() and self.computer:isBiosActive()
end

function Computer_Action_ToggleBiosSetting:update()
    self.character:faceThisObject(self.computer.isoObject)
end

function Computer_Action_ToggleBiosSetting:start()
    if self.sound ~= "" then
        self.audio = self.character:getEmitter():playSound(self.sound)
    end

    self:setActionAnim("VehicleWorkOnMid")
end

function Computer_Action_ToggleBiosSetting:stop()
    if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
        self.character:stopOrTriggerSound(self.audio)
    end
    ISBaseTimedAction.stop(self);
end

function Computer_Action_ToggleBiosSetting:perform()
    if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
        self.character:stopOrTriggerSound(self.audio)
    end

    self.computer:setBiosValue(self.settingKey, self.settingValue)

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

---@param player number
---@param computer Computer
---@param settingKey string
---@param settingValue string | boolean | number
---@param time number
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
    o.sound = "ComputerKeyboardFast"
    o.audio = 0
    o.computer = computer
    o.settingKey = settingKey
    o.settingValue = settingValue
    return o;
end
