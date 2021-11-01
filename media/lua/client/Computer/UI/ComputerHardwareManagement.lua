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
    if self.computer and self.character and self.character:DistTo(self.computer.square:getX(), self.computer.square:getY()) > 3 then
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

    self.parent.listbox.selected = 0;
    self.parent.drivelist.selected = 0;

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

    -- Get All Drives from inventory
    ---@type ArrayList
    local drivesInventory = ComputerUtils.findAllByTag(self.inventory, "ComputerDrive");

    ---@type drive
    local drive = self.computer:getDriveInBayIndex(bayIndex) -- get drive by index

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
    if not drive then
        if drivesInventory:size() > 0 then
            local bayOption = self.context:addOption(getText("IGUI_Install"));
            local bayContext = ISContextMenu:getNew(self.context)
            self.context:addSubMenu(bayOption, bayContext)
            for i=0, drivesInventory:size()-1 do
                local item = drivesInventory:get(i);

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
        tooltip.name = "Uninstall " .. drive:getName()
        if screwdriverItems:size() > 0 then
            uninstallOption = self.context:addOption("Uninstall " .. drive.name, self, self.optionUninstallDrive, bayIndex, screwdriverItems:get(0));
            tooltip.description = drive:getTooltipDescription()
            tooltip.description = tooltip.description .. " <LINE> <RGB:1,0,0> (Click to uninstall drive)"
        else
            uninstallOption = self.context:addOption("Uninstall " .. drive.name)
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
        self:drawText(item.text, 20, y, self.parent.partCatRGB.r, self.parent.partCatRGB.g, self.parent.partCatRGB.b, self.parent.partCatRGB.a, UIFont.Medium);
        y = y + 10;

    -- List
    else
        local partCol = self.parent.partRGB
        local optCol = self.parent.partOptRGB;
        local reqCol = self.parent.partReqRGB;

        ---@type drive
        local drive = self.parent.drives[item.item.index]

        if drive then -- Existing Part
            local itemWidth = getTextManager():MeasureStringX(UIFont.Small, item.text)
            self:drawText(item.text, 20, y - 5, self.parent.partRGB.r, self.parent.partRGB.g, self.parent.partRGB.b, self.parent.partRGB.a, UIFont.Small);
            self:drawText(drive.name, 100, y - 5, self.parent.partRGB.r, self.parent.partRGB.g, self.parent.partRGB.b, self.parent.partRGB.a, UIFont.Small);

        else
            local curColor = optCol;
            if item.required then curColor = reqCol; end
            self:drawText(item.text, 20, y - 5, partCol.r, partCol.g, partCol.b, partCol.a, UIFont.Small);
            self:drawText("Empty", 100, y - 5, curColor.r, curColor.g, curColor.b, curColor.a, UIFont.Small);
        end
    end

    return y + self.itemheight;
end

function ComputerHardwareManagement:updateLayout()
    self.listbox:setWidth(self.listWidth)
    self.drivelist:setWidth(self.listWidth)
    --self.drivelist:setX(self.listbox:getRight() + 5)
    self.drivelist:setX(5)
end

---@return void
function ComputerHardwareManagement:initParts()
    if not self.computer then return; end

    self.listbox:clear();
    self.drivelist:clear();

    local scrollbarWidth = self.listbox.vscroll:getWidth()
    local maxWidth = 390;

    self.drivelist:addItem("Drive Bays", {listCategory = true});

    self.hasOneDrive = false;

    for index = 1, self.drives.count do
        if self.drives[i] then self.hasOneDrive = true; end
        self.drivelist:addItem("[Bay "..tostring(index).."] ", {
            index = index,
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

    self.listbox = ISScrollingListBox:new(5, y, 400, self.height-rh-5-y);
    self.listbox:initialise();
    self.listbox:instantiate();
    self.listbox:setAnchorLeft(true);
    self.listbox:setAnchorRight(false);
    self.listbox:setAnchorTop(true);
    self.listbox:setAnchorBottom(true);
    self.listbox.itemheight = FNT_HGT_SMALL;
    self.listbox.drawBorder = true;
    self.listbox.backgroundColor.a = 0;
    self.listbox.doDrawItem = ComputerHardwareManagement.doDrawItem;
    self.listbox.onRightMouseUp = ComputerHardwareManagement.onListRightMouseUp;
    self.listbox.onMouseDown = ComputerHardwareManagement.onListMouseDown;
    self.listbox.parent = self;
    --self:addChild(self.listbox);

    self.drivelist = ISScrollingListBox:new(10 + self.listbox.width, y, 400, self.height-rh-5-y);
    self.drivelist:initialise();
    self.drivelist:instantiate();
    self.drivelist:setAnchorLeft(true);
    self.drivelist:setAnchorRight(false);
    self.drivelist:setAnchorTop(true);
    self.drivelist:setAnchorBottom(true);
    self.drivelist.itemheight = FNT_HGT_SMALL;
    self.drivelist.drawBorder = true;
    self.drivelist.backgroundColor.a = 0;
    self.drivelist.doDrawItem = ComputerHardwareManagement.doDrawItem;
    self.drivelist.onRightMouseUp = ComputerHardwareManagement.onListRightMouseUp;
    self.drivelist.onMouseDown = ComputerHardwareManagement.onListMouseDown;
    self.drivelist.parent = self;
    self:addChild(self.drivelist);

    self:initParts();
end

---@param player number
---@param computer Computer
---@return ComputerHardwareManagement
function ComputerHardwareManagement:new(player, computer)
    local width = 400;
    local height = 600;

    --Start in corner
    local x = (getCore():getScreenWidth()) - (width + 100);
    local y = (getCore():getScreenHeight()) - (height + 100);

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

    o.minimumHeight = height;
    o:setResizable(false);
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
