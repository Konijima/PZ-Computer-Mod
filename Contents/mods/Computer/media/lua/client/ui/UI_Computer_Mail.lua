require "ISUI/ISPanel"

UI_Computer_Mail = ISPanel:derive("UI_Computer_Mail");

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local FONT_HGT_LARGE = getTextManager():getFontHeight(UIFont.Large)

--************************************************************************--
--** ISPanel:initialise
--**
--************************************************************************--

function UI_Computer_Mail:initialise()
    ISPanel.initialise(self);
    self:create();
end


function UI_Computer_Mail:setVisible(visible)
    self.javaObject:setVisible(visible);
end

function UI_Computer_Mail:render()
    local z = 20;

    self:drawText("AOL Mail", self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, "AOL Mail") / 2), z, 1,1,1,1, UIFont.Medium);
    z = z + 50;
    self:drawText("Inbox empty.", self.width/2 - (getTextManager():MeasureStringX(UIFont.Small, "Inbox empty.") / 2), z, 1,1,1,1, UIFont.Small);
    z = z + 50;
end

function UI_Computer_Mail:create()
    local btnWid = 150
    local btnHgt = math.max(25, FONT_HGT_SMALL + 3 * 2)
    local padBottom = 10

    local y = 70;

    self.cancel = ISButton:new((self:getWidth() / 2) - btnWid / 2, self:getHeight() - padBottom - btnHgt, btnWid, btnHgt, getText("UI_btn_close"), self, UI_Computer_Mail.onOptionMouseDown);
    self.cancel.internal = "CANCEL";
    self.cancel:initialise();
    self.cancel:instantiate();
    self.cancel.borderColor = self.buttonBorderColor;
    self:addChild(self.cancel);
end

function UI_Computer_Mail:updateButtons()
    
end

function UI_Computer_Mail:onOptionMouseDown(button, x, y)
    if button.internal == "CANCEL" then
        self:close()
    end
end

function UI_Computer_Mail:close()
    self:setVisible(false)
    self:removeFromUIManager()
    UI_Computer_Mail.instance = nil;
end

function UI_Computer_Mail:new(x, y, width, height, player)
    local o = {};
    o = ISPanel:new(getCore():getScreenWidth() / 2 - width / 2, getCore():getScreenHeight() / 2 - height / 2, width, height);
    setmetatable(o, self);
    self.__index = self;
    self.player = player;
    o.variableColor={r=0.9, g=0.55, b=0.1, a=1};
    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1};
    o.backgroundColor = {r=0, g=0, b=0, a=0.8};
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5};
    o.zOffsetSmallFont = 25;
    o.moveWithMouse = true;
    UI_Computer_Mail.instance = o
    return o;
end
