require "TimedActions/ISBaseTimedAction"

Computer_Action_InstallDrive = ISBaseTimedAction:derive("Computer_Action_InstallDrive");

function Computer_Action_InstallDrive:isValid()
    return self.computer ~= nil and self.item ~= nil and self.tool ~= nil
end

function Computer_Action_InstallDrive:update()
    self.character:faceThisObject(self.computer.isoObject)

    self.item:setJobDelta(self:getJobDelta())
    self.tool:setJobDelta(self:getJobDelta())
    self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function Computer_Action_InstallDrive:start()
    if self.sound ~= "" then
        self.audio = self.character:getEmitter():playSound(self.sound)
    end

    self:setActionAnim("VehicleWorkOnMid")
    self.item:setJobType(self.jotText)
    self.item:setJobDelta(0.0)
    self.tool:setJobType(self.jotText)
    self.tool:setJobDelta(0.0)
end

function Computer_Action_InstallDrive:stop()
    if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
        self.character:stopOrTriggerSound(self.audio)
    end
    self.item:setJobDelta(0.0)
    self.tool:setJobDelta(0.0)

    ISBaseTimedAction.stop(self);
end

function Computer_Action_InstallDrive:perform()
    if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
        self.character:stopOrTriggerSound(self.audio)
    end

    self.item:setJobDelta(0.0)
    self.tool:setJobDelta(0.0)

    self.character:setSecondaryHandItem(nil)

    self.computer:installDriveItemInBayIndex(self.inventory, self.item, self.bayIndex)
    self.character:getXp():AddXP(Perks.Electricity, 3)

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end

function Computer_Action_InstallDrive:new(player, computer, item, bayIndex, tool, time)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.player = player;
    o.character = getSpecificPlayer(player)
    o.inventory = o.character:getInventory()
    o.stopOnWalk = true;
    o.stopOnRun = true;
    o.maxTime = time;
    -- custom fields
    o.jotText = "Install Drive..."
    o.sound = "ComputerInstallDrive"
    o.audio = 0
    o.computer = computer
    o.item = item
    o.bayIndex = bayIndex
    o.tool = tool
    return o;
end
