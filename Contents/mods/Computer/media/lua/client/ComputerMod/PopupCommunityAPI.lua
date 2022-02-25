require("CommunityAPI")
require("ISUI/ISCollapsableWindow")

---@class CommunityAPIPopup
local CommunityAPIPopup = ISCollapsableWindow:derive("CommunityAPIPopup");
CommunityAPIPopup.alphaOverlay = 1;
CommunityAPIPopup.alphaOverlayInc = true;
CommunityAPIPopup.tooltip = nil;
CommunityAPIPopup.cheat = false;
CommunityAPIPopup.instance = nil;

local FNT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small);
local FNT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium);

function CommunityAPIPopup:initialise()
    ISCollapsableWindow.initialise(self);
    --self.ticks = 0
end

function CommunityAPIPopup:close()
    self:setVisible(false);
    self:removeFromUIManager();
    CommunityAPIPopup.instance = nil;
    --UIManager.getSpeedControls():SetCurrentGameSpeed(1)
end

---@return void
function CommunityAPIPopup:update()
    --self.ticks = self.ticks + 1

    --if self.ticks > 20 and UIManager.getSpeedControls():getCurrentGameSpeed() > 0 then
    --    UIManager.getSpeedControls():SetCurrentGameSpeed(0)
    --end
end

function CommunityAPIPopup:prerender()
    ISCollapsableWindow.prerender(self)

    local logoScale = getCore():getScreenWidth() / 1920
    local tex = self.imageTexture
    local logoX = 0 * logoScale
    local logoY = 0 * logoScale
    local logoWidth = tex:getWidth() * logoScale
    local logoHgt = tex:getHeight() * logoScale
    self:drawTextureScaled(tex, 0, 0, logoWidth, logoHgt, 1, 1, 1, 1.0);
end

function CommunityAPIPopup:render()
    ISCollapsableWindow.render(self);
    if self.isCollapsed then return end

    local x = 5;
    local y = self:titleBarHeight() + 10;
    local lineHgt = FNT_HGT_SMALL;
    local rectWidth = self:getWidth()-10;
    local rectHgt = 5 + FNT_HGT_MEDIUM + FNT_HGT_SMALL * (5+1); -- +1 for the progressbar

    local lines = {}; -- TODO add Text and whatnot

    x = x + 5;
    y = y + 5;
end

---@param x number
---@param y number
function CommunityAPIPopup:onMouseDown(x, y)
    ISCollapsableWindow.onMouseDown(self, x, y);
end

---@param y number
---@param item table
---@return number
function CommunityAPIPopup:doDrawItem(y, item, alt)
    return y
end


function CommunityAPIPopup:createChildren()
    ISCollapsableWindow.createChildren(self);
    if self.resizeWidget then self.resizeWidget.yonly = true end

    self.resizeWidget:setVisible(false)
end

function CommunityAPIPopup:isKeyConsumed(key)
    return key == Keyboard.KEY_ESCAPE
end

function CommunityAPIPopup:onKeyRelease(key)
    if key == Keyboard.KEY_ESCAPE then
        self:close()
    end
end

---@return CommunityAPIPopup
function CommunityAPIPopup:new()
    local width = 800;
    local height = 600;

    --Start in corner
    local x = getCore():getScreenWidth() / 2 - (width / 2);
    local y = getCore():getScreenHeight() / 2 - (height / 2);

    local o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self);
    self.__index = self;

    o.title = "The new CommunityAPI is available!";
    useTextureFiltering(true)
    o.imageTexture = getTexture("media/textures/community_api_popup_1.png")
    useTextureFiltering(false)
    o.clearStentil = false;
    o.leftListHasFocus = true
    o:setWantKeyEvents(true)

    if CommunityAPIPopup.instance then
        CommunityAPIPopup.instance:close()
    end

    CommunityAPIPopup.instance = o

    return o
end

------------------------------------------------------------------------------------------

local PopupCommunityAPI = {}

function PopupCommunityAPI.Open()
    print("Computer V1: PopupCommunityAPI open!")

    local popup = CommunityAPIPopup:new()
    popup:initialise()
    popup:addToUIManager()
end

return PopupCommunityAPI