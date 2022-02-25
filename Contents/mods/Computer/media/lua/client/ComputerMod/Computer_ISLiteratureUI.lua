require 'ISUI/ISLiteratureUI';

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)

local ISLiteratureGameList = ISScrollingListBox:derive("ISLiteratureGameList")

local ISLiteratureUI_createChildren = ISLiteratureUI.createChildren;
function ISLiteratureUI:createChildren(...)
    ISLiteratureUI_createChildren(self, ...);
    
    local listboxGameCD = ISLiteratureGameList:new(0, 0, self.width, self.tabs.height - self.tabs.tabHeight, self.character);
    listboxGameCD:setAnchorRight(true);
    listboxGameCD:setAnchorBottom(true);
    listboxGameCD:setFont(UIFont.Small, 2);
    listboxGameCD.itemheight = math.max(32, FONT_HGT_SMALL) + 2 * 2;
    self.tabs:addView(getText("UI_Computer_ListCategory"), listboxGameCD);
    self.listboxGameCD = listboxGameCD;

    self:setAddonLists();
end

function ISLiteratureUI:setAddonLists()
    local GameAPI = require 'ComputerMod/GameAPI';
    local games = {};
    
    for id, value in pairs(GameAPI.GetAll()) do
        table.insert(games, value);
    end

    local sortFunc = function(a, b)
        return not string.sort(a.title, b.title);
    end
    table.sort(games, sortFunc);

    self.listboxGameCD:clear();
    for id, game in pairs(games) do
        self.listboxGameCD:addItem(game.title, game);
    end
end

function ISLiteratureGameList:doDrawItem(y, item, alt)
	if y + self:getYScroll() >= self.height then return y + item.height end
	if y + item.height + self:getYScroll() <= 0 then return y + item.height end

	self:drawRectBorder(0, y, self:getWidth(), item.height, 0.5, self.borderColor.r, self.borderColor.g, self.borderColor.b)

	local texture = self.texture;
	if texture then
		local texWidth = texture:getWidthOrig()
		local texHeight = texture:getHeightOrig()
		local a = 1
		if texWidth <= 32 and texHeight <= 32 then
			self:drawTexture(texture,6+(32-texWidth)/2,y+(item.height-texHeight)/2,a,1,1,1)
		else
			self:drawTextureScaledAspect(texture,6,y+(item.height-texHeight)/2,32,32,a,1,1,1)
		end
	end

	local itemPadY = (item.height - self.fontHgt) / 2
	local r,g,b,a = 0.5,0.5,0.5,1.0
    if self.modData.playedGameCD then
        self.modData.playedGameCD["GameCD_" .. item.item.title] = self.modData.playedGameCD["GameCD_" .. item.item.title] or 0;
        if self.modData.playedGameCD["GameCD_" .. item.item.title] >= Action_Computer_PlayGame.TotalPlayTime then
            r,g,b = 1.0,1.0,1.0
        end
    end
	self:drawText(item.text, 6 + 32 + 6, y+itemPadY, r, g, b, a, self.font)

	y = y + item.height
	return y;
end

function ISLiteratureGameList:new(x, y, width, height, character)
	local o = ISScrollingListBox.new(self, x, y, width, height)
	o.character = character
    o.modData = character:getModData();
    o.texture = getTexture("Item_Disc");
	return o
end
