-- TODO: Add fuel consumption and Generator UI informations
-- local original_ISGeneratorInfoWindow_update = ISGeneratorInfoWindow.update
-- function ISGeneratorInfoWindow:update()
--     original_ISGeneratorInfoWindow_update()

--     self.panel.description = ISGeneratorInfoWindow.getRichText(self.object, true) .. "test"
-- 	-- self:setWidth(self.panel:getWidth())
-- 	-- self:setHeight(self:titleBarHeight() + self.panel:getHeight())
-- end

-- local original_ISGeneratorInfoWindow_getRichText = ISGeneratorInfoWindow.getRichText
-- function ISGeneratorInfoWindow.getRichText(object, displayStats)
-- 	local square = object:getSquare()

--     local text = original_ISGeneratorInfoWindow_getRichText(object, displayStats)

--     -- stip
--     local lineToStrip = " <LINE> <RED> " .. getText("IGUI_Generator_IsToxic")
--     text = string.gsub(text, lineToStrip, "")

--     -- stip
--     lineToStrip = getText("IGUI_Total") .. ": " .. luautils.round(object:getTotalPowerUsing(), 2) .. " L/h <LINE> "
--     text = string.gsub(text, lineToStrip, "")

--     -- custom
--     --local computerPowerConsumption = 0;
--     --text = text .. "   " .. "Computer X1 (0.002L/h)" .. " <LINE> ";
--     text = text .. getText("IGUI_Total") .. ": " .. luautils.round(object:getTotalPowerUsing(), 2) .. " L/h <LINE> ";

-- 	if square and not square:isOutside() and square:getBuilding() then
-- 		text = text .. " <LINE> <RED> " .. getText("IGUI_Generator_IsToxic")
-- 	end
-- 	return text
-- end