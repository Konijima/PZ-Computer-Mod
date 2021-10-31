require("ISBaseObject")
require("Computer/ComputerUtils")

---@class Game
local Game = ISBaseObject:derive("Game")

---@param inventory ItemContainer
---@return InventoryItem | nil
function Game:createDiscItem(inventory)
    if inventory then
        local item = inventory:AddItem("Computer.Disc_Game")
        item:setName(item:getDisplayName() .. ": " .. self.title)
        item:getModData().gameId = self.id
        return item
    end
end

---@param inventory ItemContainer
---@return InventoryItem | nil
function Game:createFloppyItem(inventory)
    if inventory then
        local item = inventory:AddItem("Computer.Floppy_Game")
        item:setName(item:getDisplayName() .. ": " .. self.title)
        item:getModData().gameId = self.id
        return item
    end
end

---@return string
function Game:getOptionTooltipDescription()
    local description = " <RGB:1,1,0.8> Title:                 <RGB:1,1,1> " .. self.title
    description = description .. " <LINE> <RGB:1,1,0.8> Publisher:     <RGB:1,1,1> " .. self.publisher
    description = description .. " <LINE> <RGB:1,1,0.8> Released:      <RGB:1,1,1> " .. self.date
    description = description .. " <LINE> <RGB:1,1,0.8> Genre:              <RGB:1,1,1> " .. self.genre
    return description
end

---@vararg string | number | table
---@return Game
function Game:new(...)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self

    local args = ...
    if type(...) ~= "table" then args = {...}; end

    local paramCheck = {
        {name = "id",               type = "string",  value = type(args[1])},
        {name = "title",            type = "string",  value = type(args[2])},
        {name = "year",             type = "string",  value = type(args[3])},
        {name = "publisher",        type = "string",  value = type(args[4])},
        {name = "genre",            type = "string",  value = type(args[5])},
        {name = "boredomModifier",  type = "number",  value = type(args[6])},
        {name = "stressModifier",   type = "number",  value = type(args[7])},
        {name = "audioName",        type = "string",  value = type(args[8])},
        {name = "coverTexture",     type = "string",  value = type(args[9])},
        {name = "size",             type = "number",  value = type(args[10])},
        {name = "format",           type = "string",  value = type(args[11])}, values = ComputerMod.GetAllGameFormats(),
    }

    for i = 1, #args do
        if type(args[i]) ~= paramCheck[i].type then
            error("Error calling Game:new - Argument["..i.."] ("..paramCheck[i].name..") expected to be of type "..paramCheck[i].type.." but was "..paramCheck[i].value..".", 2);
        elseif paramCheck[i].values and not ComputerUtils.tableContains(paramCheck[i].values, paramCheck[i].value) then
            error("Error calling Game:new - Argument["..i.."] ("..paramCheck[i].name..") expected to be of type "..paramCheck[i].type.." but was "..paramCheck[i].value..".", 2);
        else
            o[paramCheck[i].name] = args[i]
        end
    end

    return o
end

return Game
