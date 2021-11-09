require "TimedActions/ISBaseTimedAction"

Computer_Action_UninstallHardware = ISBaseTimedAction:derive("Computer_Action_UninstallHardware");

function Computer_Action_UninstallHardware:isValid()
    return self.computer:exist() and self.tool ~= nil and self.hardwares[self.slotKey] ~= nil
end

function Computer_Action_UninstallHardware:update()
    self.character:faceThisObject(self.computer.isoObject)

    --self.tool:setJobDelta(self:getJobDelta())
    self.character:setMetabolicTarget(Metabolics.LightDomestic)
end

function Computer_Action_UninstallHardware:start()
    if self.sound ~= "" then
        self.audio = self.character:getEmitter():playSound(self.sound)
    end

    --self.tool:setJobType(self.jotText)
    --self.tool:setJobDelta(0.0)

    self:setActionAnim("Loot")
    if self.computer:isOnGround() then
        self.character:SetVariable("LootPosition", "Low")
    else
        self.character:SetVariable("LootPosition", "Mid")
    end
end

function Computer_Action_UninstallHardware:stop()
    if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
        self.character:stopOrTriggerSound(self.audio)
    end

    --self.tool:setJobDelta(0.0)

    ISBaseTimedAction.stop(self)
end

function Computer_Action_UninstallHardware:perform()
    if self.audio ~= 0 and self.character:getEmitter():isPlaying(self.audio) then
        self.character:stopOrTriggerSound(self.audio)
    end

    --self.tool:setJobDelta(0.0)

    self.computer:uninstallHardwareItemFromSlot(self.inventory, self.slotKey)
    self.character:getXp():AddXP(Perks.Electricity, 2)

    -- needed to remove from queue / start next.
    ISBaseTimedAction.perform(self)
end

---@param player number
---@param computer Computer
---@param slotKey string
---@param tool InventoryItem
---@param time number
function Computer_Action_UninstallHardware:new(player, computer, slotKey, tool, time)
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
    o.jotText = "Uninstall"
    o.sound = "ComputerInstallDrive"
    o.audio = 0
    o.computer = computer
    o.slotKey = slotKey
    o.tool = tool
    o.hardwares = computer:getAllHardwares()
    return o;
end
