require("Computer/ComputerUtils")
require("Computer/Managers/InventoryTooltipManager")

local function typeField(result, item)
    result.value = item:getType()
end

local function conditionProgress(result, item)
    result.value = 0.25
    result.color = ComputerUtils.getVariableRGB(result.value, 1)
end

local function capacityProgress(result, item)
    result.value = 0.75
    result.color = ComputerUtils.getVariableReversedRGB(result.value, 1)
end

local function dynamicLabel(result, item)
    result.value = "This is a very long dynamic label that\ncan change depending of the items\nstate or what ever you need!"
    result.labelColor = { r=1, g=0, b=0.5, a=1 }
end

local Processor = InventoryTooltipManager:CreateToolTip("Computer.Processor")

Processor:addField("Hardware", typeField)
Processor:addField("Cores", "1 core / 1 thread")
Processor:addField("Frequency", "1 MHz")
Processor:addField("Cache", "1 MB")
Processor:addProgress("Condition", conditionProgress)
Processor:addProgress("Capacity", capacityProgress)
Processor:addProgress("Speed", 0.5)
Processor:addSpacer()
Processor:addLabel("This is some label!", { r=1, g=0, b=0, a=1 })
Processor:addSpacer()
Processor:addLabel(dynamicLabel)
