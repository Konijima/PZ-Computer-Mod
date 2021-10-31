require "TimedActions/ISBaseTimedAction"

Computer_Action_UninstallGame = ISBaseTimedAction:derive("Computer_Action_UninstallGame");

function Computer_Action_UninstallGame:isValid()
    return true
end

function Computer_Action_UninstallGame:update()
    self.character:faceThisObject(self.computer.isoObject)
end

function Computer_Action_UninstallGame:start()
    if self.sound ~= "" then
        self.audio = self.character:getEmitter():playSound(self.sound)
    end
end

function Computer_Action_UninstallGame:stop()
    if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
        self.character:stopOrTriggerSound(self.audio)
    end
    ISBaseTimedAction.stop(self);
end

function Computer_Action_UninstallGame:perform()
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

---@param player number
---@param computer Computer
---@param harddrive Harddrive
---@param gameId string
---@param time number
function Computer_Action_UninstallGame:new(player, computer, harddrive, gameId, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.player = player;
    o.character = getSpecificPlayer(player)
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    -- custom fields
    o.sound = ""
    o.audio = 0
    o.computer = computer
    o.harddrive = harddrive
    o.gameId = gameId
    return o;
end
