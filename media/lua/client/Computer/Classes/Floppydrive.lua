require("ISBaseObject")

---@class Floppydrive
local Floppydrive = ISBaseObject:derive("Floppydrive")

---@return string
function Floppydrive:getName()
    return self.name
end

---@return string
function Floppydrive:getType()
    return Floppydrive.Type
end

---@return Floppydrive
function Floppydrive:getClass()
    return Floppydrive
end

---@return string
function Floppydrive:getItemFullType()
    return "Computer.Floppydrive"
end

---@return string
function Floppydrive:getTooltipDescription()
    local description = " <RGB:1,1,1> Floppy: <RGB:1,0,0> Empty <LINE> "
    return description
end

---@param inventory ItemContainer
---@return InventoryItem|nil
function Floppydrive:createItem(inventory)
    if inventory then
        local item = inventory:AddItem(self:getItemFullType())
        local modData = item:getModData()
        modData.type = self:getType()
        modData.name = self:getName()
        item:setName(modData.name)
        return item
    end
end

---@vararg string|table|InventoryItem
---@return Floppydrive
function Floppydrive:new(...)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self

    local args = {...}

    -- Check if passing a Harddrive as data
    if #args > 1 then
        local paramCheck = {
            {name = "type",         type = "string", value = type(args[1])},
            {name = "name",         type = "string", value = type(args[2])},
        }
        
        for i = 1, #args do
            if type(args[i]) ~= paramCheck[i].type then
                error("Error calling Harddrive:new - argument "..i.." ("..paramCheck[i].name..") expected to be of type "..paramCheck[i].type.." but was "..paramCheck[i].value..".", 2);
            else
                o[paramCheck[i].name] = args[i]
            end
        end

    -- Check if passing a Harddrive as an Item
    elseif instanceof(args[1], "InventoryItem") and args[1]:getFullType() == o:getItemFullType() then
        local item = args[1]

        local modData = item:getModData() --TODO: unused local variable?
        o.type = o:getType()
        o.name = item:getName()

    elseif type(args[1]) == "table" then
        o.type = o:getType()
        o.name = args[1].name
    end

    return o
end

return Floppydrive
