require("ISBaseObject")

---@class File
local File = ISBaseObject:derive("File")

---@param inventory ItemContainer
---@return InventoryItem|nil
function File:createDiscItem(inventory)
    if inventory then
        local item = inventory:AddItem("Base.Disc")
        item:setName(item:getDisplayName() .. ": " .. self.title)
        item:getModData().title = self.title
        item:getModData().content = self.content
        return item
    end
end

---@param inventory ItemContainer
---@return InventoryItem|nil
function File:createFloppyItem(inventory)
    if inventory then
        local item = inventory:AddItem("Computer.Floppy")
        item:setName(item:getDisplayName() .. ": " .. self.title)
        item:getModData().title = self.title
        item:getModData().content = self.content
        return item
    end
end

---@return number
function File:calcSize()
    return 0 --TODO: calcSize
end

---@vararg string|table
---@return File
function File:new(...)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self

    local args = ...
    if type(...) ~= "table" then args = {...}; end
    
    local paramCheck = {
        {name = "title",    type = "string",  value = type(args[1])},
        {name = "content",  type = "string",  value = type(args[2])},
    }

    for i = 1, #args do
        if type(args[i]) ~= paramCheck[i].type then
            error("Error calling File:new - Argument["..i.."] ("..paramCheck[i].name..") expected to be of type "..paramCheck[i].type.." but was "..paramCheck[i].value..".", 2);
        else
            o[paramCheck[i].name] = args[i]
        end
    end

    return o
end

return File
