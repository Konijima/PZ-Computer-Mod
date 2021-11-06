local InventoryTooltipInstance = require("Computer/Managers/InventoryTooltipInstance")

---@class InventoryTooltipManager
InventoryTooltipManager = {}
InventoryTooltipManager.Tooltips = {}

---@return InventoryTooltipInstance
function InventoryTooltipManager:CreateToolTip(itemFullType)
    local newTooltip = InventoryTooltipInstance:new(itemFullType)
    InventoryTooltipManager.Tooltips[itemFullType] = newTooltip
    return newTooltip
end
