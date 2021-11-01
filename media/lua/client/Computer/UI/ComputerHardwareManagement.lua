require "ISUI/ISCollapsableWindow"
require "Computer/ComputerUtils"

local Harddrive = require("Computer/Classes/Harddrive")
local Discdrive = require("Computer/Classes/Discdrive")
local Floppydrive = require("Computer/Classes/Floppydrive")

---@alias drive Harddrive|Discdrive|Floppydrive

---@class ComputerHardwareManagement
ComputerHardwareManagement = ISCollapsableWindow:derive("ComputerMechanics");
ComputerHardwareManagement.alphaOverlay = 1;
ComputerHardwareManagement.alphaOverlayInc = true;
ComputerHardwareManagement.tooltip = nil;
ComputerHardwareManagement.cheat = false;
ComputerHardwareManagement.instance = nil;

local FNT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small);
local FNT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium);

function ComputerHardwareManagement:initialise()
    ISCollapsableWindow.initialise(self);
end

---@return void
function ComputerHardwareManagement:update()
    if self.computer:isOn() then
        self:close();
        return;
    end
    if self.computer and self.character and self.character:getSquare() ~= self.square then
        self:close();
        return;
    end
end

function ComputerHardwareManagement:prerender()
    ISCollapsableWindow.prerender(self)
    self:updateLayout()
end

---@param x number
---@param y number
function ComputerHardwareManagement:getMouseOverPart(x, y)
    -- TODO: Remove?
end

---@param x number
---@param y number
function ComputerHardwareManagement:onMouseDown(x, y)
    ISCollapsableWindow.onMouseDown(self, x, y);
end

---@param x number
---@param y number
function ComputerHardwareManagement:onRightMouseUp(x, y)
    -- TODO: Remove?
end

---@param x number
---@param y number
---@return void
function ComputerHardwareManagement:onListMouseDown(x, y)
    if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 and not getDebug() then return; end

    self.parent.mainlist.selected = 0;

    local row = self:rowAt(x, y);
    if row < 1 or row > #self.items then return end
    if not self.items[row].item or not self.items[row].item.listCategory then
        self.selected = row;
    end
end

---@param self ComputerHardwareManagement
---@param bayIndex number
---@param driveItem InventoryItem
---@param screwdriver InventoryItem
function ComputerHardwareManagement:optionInstallDrive(driveItem, bayIndex, screwdriver)
    if screwdriver then
        ISTimedActionQueue.add(ISWalkToTimedAction:new(self.character, self.square))
        if self.character:getPrimaryHandItem() ~= screwdriver then
            ISTimedActionQueue.add(ISEquipWeaponAction:new(self.character, screwdriver, 40, true, false))
        end
        if self.character:getSecondaryHandItem() ~= item then
            ISTimedActionQueue.add(ISEquipWeaponAction:new(self.character, driveItem, 20, false, false))
        end
        ISTimedActionQueue.add(Computer_Action_InstallDrive:new(self.player, self.computer, driveItem, bayIndex, screwdriver, 200))
    end
end

---@param self ComputerHardwareManagement
---@param bayIndex number
---@param screwdriver InventoryItem
function ComputerHardwareManagement:optionUninstallDrive(bayIndex, screwdriver)
    if screwdriver then
        ISTimedActionQueue.add(ISWalkToTimedAction:new(self.character, self.square))
        if self.character:getPrimaryHandItem() ~= screwdriver then
            ISTimedActionQueue.add(ISEquipWeaponAction:new(self.character, screwdriver, 40, true, false))
        end
        ISTimedActionQueue.add(Computer_Action_UninstallDrive:new(self.player, self.computer, bayIndex, screwdriver, 200))
    end
end

---@param item table
---@param x number
---@param y number
---@return void
function ComputerHardwareManagement:doPartContextMenu(item, x, y)
    if UIManager.getSpeedControls():getCurrentGameSpeed() == 0 then return; end
    self.context = ISContextMenu.get(self.player, x + self:getAbsoluteX(), y + self:getAbsoluteY());

    ---@type number
    local bayIndex = item.index

    ---@type ArrayList
    local screwdriverItems = ComputerUtils.findAllByTag(self.inventory, "Screwdriver");

    ---@type ArrayList
    local hardwareItems = ComputerUtils.findAllByTag(self.inventory, "ComputerHardware");

    ---@type BaseHardware
    local bayDrive = self.computer:getDriveInBayIndex(bayIndex) -- get drive by index

    -- get valid screwdrivers
    local validScrewdriverItems = getScriptManager():getItemsTag("Screwdriver");
    local neededDescription = "";
    if validScrewdriverItems then
        for i=0, validScrewdriverItems:size()-1 do
            neededDescription = neededDescription .. validScrewdriverItems:get(i):getDisplayName();
            if i < validScrewdriverItems:size()-1 then
                neededDescription = neededDescription .. ",";
            end
        end
    end

    -- Empty Bay
    if not bayDrive then
        -- We have some hardware in inventory
        if hardwareItems:size() > 0 then
            local bayOption = self.context:addOption(getText("IGUI_Install"));
            local bayContext = ISContextMenu:getNew(self.context)
            self.context:addSubMenu(bayOption, bayContext)
            for i=0, hardwareItems:size()-1 do
                local item = hardwareItems:get(i);

                local hardware
                if item:getType() == "Harddrive" then
                    hardware = Harddrive:new(item)
                elseif item:getType() == "Discdrive" then
                    hardware = Discdrive:new(item)
                elseif item:getType() == "Floppydrive" then
                    hardware = Floppydrive:new(item)
                end

                --- Install Option
                local installOption
                local tooltip = ISToolTip:new()
                tooltip.name = "Install " .. item:getDisplayName()
                if screwdriverItems:size() > 0 then
                    installOption = bayContext:addOption(item:getDisplayName(), self, self.optionInstallDrive, item, bayIndex, screwdriverItems:get(0))
                    tooltip.description = hardware:getTooltipDescription()
                    tooltip.description = tooltip.description .. " <LINE> <RGB:0,1,0> (Click to install drive)"
                else
                    installOption = bayContext:addOption(item:getDisplayName())
                    installOption.notAvailable = true
                    tooltip.description = "Needs:"
                    tooltip.description = tooltip.description .. " <LINE> <RGB:1,0,0> " .. neededDescription .. " 0/1";
                end
                installOption.toolTip = tooltip
            end
        end

        -- Bay have a drive
    else
        local uninstallOption
        local tooltip = ISToolTip:new()
        tooltip.name = "Uninstall " .. bayDrive.name
        if screwdriverItems:size() > 0 then
            uninstallOption = self.context:addOption("Uninstall " .. bayDrive.name, self, self.optionUninstallDrive, bayIndex, screwdriverItems:get(0));
            tooltip.description = bayDrive:getTooltipDescription()
            tooltip.description = tooltip.description .. " <LINE> <RGB:1,0,0> (Click to uninstall drive)"
        else
            uninstallOption = self.context:addOption("Uninstall " .. bayDrive.name)
            uninstallOption.notAvailable = true
            tooltip.description = "Needs:"
            tooltip.description = tooltip.description .. " <LINE> <RGB:1,0,0> "..neededDescription.." 0/1"
        end
        uninstallOption.toolTip = tooltip
    end
end

---@param x number
---@param y number
function ComputerHardwareManagement:onListRightMouseUp(x, y)
    self:onMouseDown(x, y);
    if self.items[self.selected] and self.items[self.selected].item and not self.items[self.selected].item.listCategory then
        print("List on item: ",self.items[self.selected].text, self.items[self.selected].item);
        self.parent:doPartContextMenu(self.items[self.selected].item, self:getX() + x, self:getY() + self:getYScroll()+ y);
    end
end

---@param y number
---@param item table
---@return number
function ComputerHardwareManagement:doDrawItem(y, item, alt)
    -- NOTE: Draws background box of item if selected/hovered and not a category
    if not item.item or item.item.listCategory ~= true then
        if item.itemindex == self.selected then
            self:drawRect(0, y, self:getWidth(), item.height, 0.1, 1.0, 1.0, 1.0);
        elseif item.itemindex == self.mouseoverselected and ((self.parent.context and not self.parent.context:isVisible()) or not self.parent.context) then
            self:drawRect(0, y, self:getWidth(), item.height, 0.05, 1.0, 1.0, 1.0);
        end
    end

    -- Add some space before the title
    y = y + 5

    -- Category
    if item.item and item.item.listCategory == true then
        self:drawText(item.text, 10, y, self.parent.partCatRGB.r, self.parent.partCatRGB.g, self.parent.partCatRGB.b, self.parent.partCatRGB.a, UIFont.Medium);
        y = y + 10;

        -- List
    else
        local partCol = self.parent.partRGB
        local optCol = self.parent.partOptRGB;
        local reqCol = self.parent.partReqRGB;

        ---@type drive
        local drive = self.parent.drives[item.item.index]

        if drive then -- Existing Part
            local driveNameWidth = getTextManager():MeasureStringX(UIFont.Small, drive.name)
            self:drawText(item.text, 20, y - 2, self.parent.partRGB.r, self.parent.partRGB.g, self.parent.partRGB.b, self.parent.partRGB.a, UIFont.Small);
            self:drawText(drive.name, 120, y - 2, self.parent.partRGB.r, self.parent.partRGB.g, self.parent.partRGB.b, self.parent.partRGB.a, UIFont.Small);

            if item.item.condition ~= nil then
                self:drawText(" ("..item.item.condition.value..")", 120 + driveNameWidth, y - 2, item.item.condition.color.r, item.item.condition.color.g, item.item.condition.color.b, 1, UIFont.Small);
            end
        else
            local curText = "None";
            local curColor = optCol;
            if item.item.required then
                curText = "Missing";
                curColor = reqCol;
            elseif item.item.type == "Drive" then
                curText = "Empty";
            end
            self:drawText(item.text, 20, y - 2, partCol.r, partCol.g, partCol.b, partCol.a, UIFont.Small);
            self:drawText(curText, 120, y - 2, curColor.r, curColor.g, curColor.b, curColor.a, UIFont.Small);
        end
    end

    return y + self.itemheight;
end

function ComputerHardwareManagement:updateLayout()
    self.mainlist:setWidth(self.listWidth)
    self.mainlist:setX(5)
end

---@return void
function ComputerHardwareManagement:initParts()
    if not self.computer then return; end

    local maxWidth = 390;
    self.hasOneDrive = false;

    self.mainlist:clear();

    self.mainlist:addItem("Hardware Slots", { listCategory = true});

    self.mainlist:addItem("Processor", { type = "CPU", required = true });
    self.mainlist:addItem("Graphic Card", { type = "GPU", required = true });
    self.mainlist:addItem("Power Supply", { type = "PowerSupply", required = true });
    self.mainlist:addItem("Network Card", { type = "NetworkCard", });
    self.mainlist:addItem("Sound Card", { type = "SoundCard", });
    self.mainlist:addItem("Car Battery", { type = "Battery", });

    self.mainlist:addItem("Drive Bays", {listCategory = true});

    for index = 1, self.drives.count do
        if self.drives[i] then self.hasOneDrive = true; end
        local tempConditionValue = ZombRand(0, 100)
        self.mainlist:addItem("Drive Bay "..tostring(index), {
            index = index,
            type = "Drive",
            condition = {
                color = self.getConditionRGB(tempConditionValue),
                value = tempConditionValue.."%"
            },
        });
    end

    self.listWidth = maxWidth
    self:updateLayout()
end

function ComputerHardwareManagement:createChildren()
    ISCollapsableWindow.createChildren(self);
    if self.resizeWidget then self.resizeWidget.yonly = true end

    self.resizeWidget:setVisible(false)
    self:setInfo(" <CENTRE> <SIZE:medium> This is the Hardware Management Panel. <LINE> <LINE> <SIZE:small> <LEFT> Welcome to the computer Hardware Management menu! <LINE> <LINE> Here you can find informations about your current computer hardwares. If you have a screwdriver, right click a bay to install or remove hardware. <LINE> <LINE> Left click to get more detailed informations from each installed hardware. <LINE> <LINE> The hardware menu can only be accessed while the computer is off. <LINE> <LINE> ");

    --local rh = self.resizeable and self:resizeWidgetHeight() or 0;
    local rh = 0;
    local y = self:titleBarHeight() + 25 + FNT_HGT_MEDIUM + FNT_HGT_SMALL * 6

    self.mainlist = ISScrollingListBox:new(10, y, self.width, 300);
    self.mainlist:initialise();
    self.mainlist:instantiate();
    self.mainlist:setAnchorLeft(true);
    self.mainlist:setAnchorRight(false);
    self.mainlist:setAnchorTop(true);
    self.mainlist:setAnchorBottom(true);
    self.mainlist.itemheight = FNT_HGT_SMALL;
    self.mainlist.drawBorder = true;
    self.mainlist.backgroundColor.a = 0;
    self.mainlist.doDrawItem = ComputerHardwareManagement.doDrawItem;
    self.mainlist.onRightMouseUp = ComputerHardwareManagement.onListRightMouseUp;
    self.mainlist.onMouseDown = ComputerHardwareManagement.onListMouseDown;
    self.mainlist.parent = self;
    self:addChild(self.mainlist);

    self:initParts();
end

function ComputerHardwareManagement:isKeyConsumed(key)
    return key == Keyboard.KEY_ESCAPE
end

function ComputerHardwareManagement:onKeyRelease(key)
    if key == Keyboard.KEY_ESCAPE then
        if isPlayerDoingActionThatCanBeCancelled(self.character) then
            stopDoingActionThatCanBeCancelled(self.character)
        else
            self:close()
        end
    end
end

function ComputerHardwareManagement.getConditionRGB(condition)
    local r = ((100 - condition) / 100) ;
    local g = (condition / 100);
    return {r = r, g = g, b = 0};
end

---@param player number
---@param computer Computer
---@return ComputerHardwareManagement
function ComputerHardwareManagement:new(player, computer)
    local width = 400;
    local height = 450;

    --Start in corner
    local x = getCore():getScreenWidth() - (width + 100);
    local y = getCore():getScreenHeight() - (height + 100);

    local o = ISCollapsableWindow:new(x, y, width, height);
    setmetatable(o, self);
    self.__index = self;

    o.player = player;
    o.character = getSpecificPlayer(player);
    o.inventory = o.character:getInventory();
    o.computer = computer;
    o.square = computer:getSquareInFront();
    o.drives = computer:getAllDrives();
    o.hasOneDrive = false;

    o.partCatRGB = {r=1, g=1, b=1, a=1}; --       CATEGORY Color
    o.partRGB =    {r=0.8, g=0.8, b=0.8, a=1}; -- Part Existing Color
    o.partReqRGB = {r=1, g=0, b=0, a=1}; --       Part Missing & Required Color
    o.partOptRGB = {r=0.8, g=0.5, b=0.5, a=1}; -- Part Missing & Optional Color
    o.title = "Hardware Management";
    o.clearStentil = false;
    o.leftListHasFocus = true
    o:setWantKeyEvents(true)

    if ComputerHardwareManagement.instance then
        ComputerHardwareManagement.instance:close()
        ComputerHardwareManagement.instance = nil
    end

    ComputerHardwareManagement.instance = o

    return o
end
