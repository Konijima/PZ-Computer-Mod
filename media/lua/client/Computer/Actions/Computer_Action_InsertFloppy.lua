require "TimedActions/ISBaseTimedAction"

Computer_Action_InsertFloppy = ISBaseTimedAction:derive("Computer_Action_InsertFloppy");

function Computer_Action_InsertFloppy:isValid()
    return true
end

function Computer_Action_InsertFloppy:update()
    self.character:faceThisObject(self.computer.isoObject)
end

function Computer_Action_InsertFloppy:start()
    if self.sound ~= "" then
        self.audio = self.character:getEmitter():playSound(self.sound)
    end
end

function Computer_Action_InsertFloppy:stop()
    if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
        self.character:stopOrTriggerSound(self.audio)
    end
    ISBaseTimedAction.stop(self);
end

function Computer_Action_InsertFloppy:perform()
    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self);
end

function Computer_Action_InsertFloppy:new(player, computer, floppydrive, floppy, time)
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
    o.floppydrive = floppydrive
    o.floppy = floppy
    return o;
end
