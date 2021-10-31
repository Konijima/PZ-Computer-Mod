require "TimedActions/ISBaseTimedAction"

Computer_Action_UninstallDrive = ISBaseTimedAction:derive("Computer_Action_UninstallDrive");

function Computer_Action_UninstallDrive:isValid()
    return self.computer ~= nil and self.tool ~= nil
end

function Computer_Action_UninstallDrive:update()
    self.character:faceThisObject(self.computer.isoObject)

    self.tool:setJobDelta(self:getJobDelta())
    self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function Computer_Action_UninstallDrive:start()
    if self.sound ~= "" then
        self.audio = self.character:getEmitter():playSound(self.sound)
    end

    self.tool:setJobType(self.jotText)
    self.tool:setJobDelta(0.0)

    self:setActionAnim("VehicleWorkOnMid")
end

function Computer_Action_UninstallDrive:stop()
    if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
        self.character:stopOrTriggerSound(self.audio)
    end

    self.tool:setJobDelta(0.0)

    ISBaseTimedAction.stop(self)
end

function Computer_Action_UninstallDrive:perform()
    if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
        self.character:stopOrTriggerSound(self.audio)
    end

    self.tool:setJobDelta(0.0)

    self.computer:uninstallDriveFromBayIndex(self.inventory, self.bayIndex)
    self.character:getXp():AddXP(Perks.Electricity, 3)

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end

---@param player number
---@param computer Computer
---@param bayIndex number
---@param tool InventoryItem
---@param time number
function Computer_Action_UninstallDrive:new(player, computer, bayIndex, tool, time)
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
    o.jotText = "Uninstall Drive..."
    o.sound = "ComputerInstallDrive"
    o.audio = 0
    o.computer = computer
    o.bayIndex = bayIndex
    o.tool = tool
    return o;
end
