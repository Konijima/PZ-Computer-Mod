require("CommunityAPI")

local ItemTooltipAPI = CommunityAPI.Client.ItemTooltip

local Discdrive = ItemTooltipAPI.CreateToolTip("Computer.Discdrive")

function extraItems(result, item)

    result.value = { "Base.Disc" }
end

Discdrive:addExtraItems("Contains", extraItems)