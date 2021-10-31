require "TimedActions/ISBaseTimedAction"

Action_Computer_OpenNotepad = ISBaseTimedAction:derive("Action_Computer_OpenNotepad");

function Action_Computer_OpenNotepad:isValid()
	return true
end

function Action_Computer_OpenNotepad:update()
	self.character:faceThisObject(self.computer)
end

function Action_Computer_OpenNotepad:start()
	
end

function Action_Computer_OpenNotepad:stop()
	ISBaseTimedAction.stop(self);
end

function Action_Computer_OpenNotepad:perform()
	local fontHgt = getTextManager():getFontFromEnum(UIFont.Small):getLineHeight()
	local height = 110 + (15 * fontHgt);
	local modal = UI_Computer_Notepad:new(0, 0, 280, height, nil, ISInventoryPaneContextMenu.onWriteSomethingClick, self.character, self.disk, self.disk:seePage(1), self.disk:getName(), 15, true, self.disk:getPageToWrite());
	modal:initialise();
	modal:addToUIManager();
	if JoypadState.players[self.player+1] then
		setJoypadFocus(self.player, modal)
	end

	-- Set computer as active
	ComputerMod.setActiveComputer(self.computer, self.player)

	-- needed to remove from queue / start next.
	ISBaseTimedAction.perform(self);
end

function Action_Computer_OpenNotepad:new(player, computer, disk, time)
	local o = {}
	setmetatable(o, self)
	self.__index = self
	o.player = player
	o.character = getSpecificPlayer(player)
	o.stopOnWalk = true
	o.stopOnRun = true
	o.maxTime = time
	-- custom fields
	o.computer = computer
	o.disk = disk
	return o;
end
