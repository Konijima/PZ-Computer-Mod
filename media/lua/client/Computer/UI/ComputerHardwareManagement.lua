require "ISUI/ISCollapsableWindow"
require "Computer/ComputerUtils"

local Harddrive = require("Computer/Classes/Harddrive")
local Discdrive = require("Computer/Classes/Discdrive")
local Floppydrive = require("Computer/Classes/Floppydrive")

---@alias drive Harddrive | Discdrive | Floppydrive

---@class ComputerHardwareManagement
ComputerHardwareManagement = ISCollapsableWindow:derive("ComputerMechanics");
ComputerHardwareManagement.alphaOverlay = 1;
ComputerHardwareManagement.alphaOverlayInc = true;
ComputerHardwareManagement.tooltip = nil;
ComputerHardwareManagement.cheat = false;

local FNT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small);
local FNT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium);

---@return void
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

---@return void
function ComputerHardwareManagement:prerender()
    ISCollapsableWindow.prerender(self)
    self:updateLayout()
end

---@param x number
---@param y number
---@return void
function ComputerHardwareManagement:getMouseOverPart(x, y)
    -- TODO: Remove?
end

---@param x number
---@param y number
---@return void
function ComputerHardwareManagement:onMouseDown(x, y)
    ISCollapsableWindow.onMouseDown(self, x, y);
end

---@param x number
---@param y number
---@return void
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
---@return void
function ComputerHardwareManagement.optionInstallDrive(self, driveItem, bayIndex, screwdriver)
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
---@return void
function ComputerHardwareManagement.optionUninstallDrive(self, bayIndex, screwdriver)
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
    local drives = ComputerUtils.findAllByTag(self.inventory, "ComputerDrive");

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

    -- If no part
    if not drive then
        if drives:size() > 0 then
            local bayOption = self.context:addOption(getText("IGUI_Install"));
            local bayContext = ISContextMenu:getNew(self.context)
            self.context:addSubMenu(bayOption, bayContext)
            for i=0, drives:size()-1 do
                local item = drives:get(i);
                if screwdriverItems:size() > 0 then
                    local installOption = bayContext:addOption(item:getDisplayName(), self, self.optionInstallDrive, item, bayIndex, screwdriverItems:get(0))
                    local toolTip = ISToolTip:new()
                    toolTip.name = getText("IGUI_Install") .. " " .. item:getDisplayName()
                    toolTip.description = ""

                    if item:getType() == "Harddrive" then
                        local drive = Harddrive:new(item)
                        toolTip.description = toolTip.description .. "<RGB:1,1,1> Files: " .. #drive.files .. " <LINE> "
                        toolTip.description = toolTip.description .. "<RGB:1,1,1> Games: " .. #drive.games .. " <LINE> "
                        toolTip.description = toolTip.description .. "<RGB:1,1,1> Softwares: " .. #drive.softwares .. " <LINE> "
                    end
                    toolTip.description = toolTip.description .. "<RGB:0,1,0> (Click to install drive)"
                    installOption.toolTip = toolTip
                else
                    local installOption = bayContext:addOption(item:getDisplayName())
                    installOption.notAvailable = true
                    local toolTip = ISToolTip:new()
                    toolTip.name = getText("IGUI_Install") .. " " .. item:getDisplayName()
                    toolTip.description = "Needs:"
                    toolTip.description = toolTip.description .. " <LINE> <RGB:1,0,0> " .. neededDescription .. " 0/1";
                    installOption.toolTip = toolTip
                end
            end
        end
    else
        if screwdriverItems:size() > 0 then
            self.context:addOption("Uninstall " .. drive.name, self, self.optionUninstallDrive, bayIndex, screwdriverItems:get(0));
        else
            local bayOption = self.context:addOption(getText("IGUI_Uninstall").. " " .. drive.name)
            bayOption.notAvailable = true
            local toolTip = ISToolTip:new()
            toolTip.description = "Needs:"
            toolTip.description = toolTip.description .. " <LINE> <RGB:1,0,0> "..neededDescription.." 0/1"
            bayOption.toolTip = toolTip
        end
    end
end

---@param x number
---@param y number
---@return void
function ComputerHardwareManagement:onListRightMouseUp(x, y)
    self:onMouseDown(x, y);
    if self.items[self.selected] and self.items[self.selected].item and not self.items[self.selected].item.listCategory then
        print("List on item: ",self.items[self.selected].text, self.items[self.selected].item);
        self.parent:doPartContextMenu(self.items[self.selected].item, self:getX() + x, self:getY() + self:getYScroll()+ y);
    end
end

---@param y number
---@param item table
---To-Do: @param alt ???
---@return void
function ComputerHardwareManagement:doDrawItem(y, item, alt)
    -- NOTE: Draws background box of item if selected/hovered and not a category
    if not item.item or item.item.listCategory ~= true then
        if item.itemindex == self.selected then
            self:drawRect(0, y, self:getWidth(), item.height, 0.1, 1.0, 1.0, 1.0);
        elseif item.itemindex == self.mouseoverselected and ((self.parent.context and not self.parent.context:isVisible()) or not self.parent.context) then
            self:drawRect(0, y, self:getWidth(), item.height, 0.05, 1.0, 1.0, 1.0);
        end
    end

    if item.item and item.item.listCategory == true then -- Category
        self:drawText(item.text, 0, y, self.parent.partCatRGB.r, self.parent.partCatRGB.g, self.parent.partCatRGB.b, self.parent.partCatRGB.a, UIFont.Medium);
        y = y + 5;
    else
        local partCol = self.parent.partRGB
        local optCol = self.parent.partOptRGB;
        local reqCol = self.parent.partReqRGB;

        ---@type drive
        local drive = self.parent.drives[item.item.index]

        if drive then -- Existing Part
            self:drawText(item.text, 20, y, self.parent.partRGB.r, self.parent.partRGB.g, self.parent.partRGB.b, self.parent.partRGB.a, UIFont.Small);
            self:drawText(drive.name, getTextManager():MeasureStringX(UIFont.Small, item.text) + 42, y, self.parent.partRGB.r, self.parent.partRGB.g, self.parent.partRGB.b, self.parent.partRGB.a, UIFont.Small);

        else
            local curColor = optCol;
            if item.required then curColor = reqCol; end
            self:drawText(item.text, 20, y, partCol.r, partCol.g, partCol.b, partCol.a, UIFont.Small);
            self:drawText("Empty", getTextManager():MeasureStringX(UIFont.Small, item.text) + 42, y, curColor.r, curColor.g, curColor.b, curColor.a, UIFont.Small);
        end
    end

    return y + self.itemheight;
end

---@return void
function ComputerHardwareManagement:updateLayout()
    self.listbox:setWidth(self.listWidth)
    self.drivelist:setWidth(self.listWidth)
    self.drivelist:setX(self.listbox:getRight() + 20)
end

---@return void
function ComputerHardwareManagement:initParts()
    if not self.computer then return; end

    self.listbox:clear();
    self.drivelist:clear();

    local scrollbarWidth = self.listbox.vscroll:getWidth()
    local maxWidth = 385;

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

---@return void
function ComputerHardwareManagement:createChildren()
    ISCollapsableWindow.createChildren(self);
    if self.resizeWidget then self.resizeWidget.yonly = true end
    self:setInfo("Computer Hardware");

    local rh = self.resizeable and self:resizeWidgetHeight() or 0;
    local y = self:titleBarHeight() + 25 + FNT_HGT_MEDIUM + FNT_HGT_SMALL * 6

    self.listbox = ISScrollingListBox:new(5, y, 220, self.height-rh-10-y);
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
    self:addChild(self.listbox);

    self.drivelist = ISScrollingListBox:new(5 + self.listbox.width + 20, y, 220, self.height-rh-10-y);
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
    local width = 800;
    local height = 600;
    local x = (getCore():getScreenWidth() / 2) - (width / 2);
    local y = (getCore():getScreenHeight() / 2) - (height / 2);

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
    o:setResizable(true);
    o.partCatRGB = {r=1, g=1, b=1, a=1}; --       CATEGORY Color
    o.partRGB =    {r=0.8, g=0.8, b=0.8, a=1}; -- Part Existing Color
    o.partReqRGB = {r=1, g=0, b=0, a=1}; --       Part Missing & Required Color
    o.partOptRGB = {r=0.8, g=0.5, b=0.5, a=1}; -- Part Missing & Optional Color
    o.title = "Computer Hardware";
    o.clearStentil = false;
    o.leftListHasFocus = true
    o:setWantKeyEvents(true)
    return o
end
