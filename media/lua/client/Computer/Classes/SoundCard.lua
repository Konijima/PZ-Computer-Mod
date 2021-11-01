require("Computer/Classes/BaseHardware")

---@class SoundCard
local SoundCard = BaseHardware:derive("SoundCard", "Sound Card")

---@return string
function SoundCard:getTooltipDescription()
    local description = ""
    return description
end

---@param inventory ItemContainer
---@return InventoryItem|nil
function SoundCard:createItem(inventory)
    if inventory then
        local item = inventory:AddItem(self:getItemFullType())
        local modData = item:getModData()
        modData.type = self.Type
        modData.name = self.name
        item:setName(modData.name)
        return item
    end
end

---@vararg string|table|InventoryItem
---@return SoundCard
function SoundCard:new(...)
    local o = BaseHardware:new()
    setmetatable(o, self)
    self.__index = self

    local args = {...}

    -- Check if passing data
    if #args > 1 then
        local paramCheck = {
            {name = "type",         type = "string", value = type(args[1])},
            {name = "name",         type = "string", value = type(args[2])},
        }
        
        for i = 1, #args do
            if type(args[i]) ~= paramCheck[i].type then
                error("Error calling "..self.Type..":new - argument "..i.." ("..paramCheck[i].name..") expected to be of type "..paramCheck[i].type.." but was "..paramCheck[i].value..".", 2);
            else
                o[paramCheck[i].name] = args[i]
            end
        end

    -- Check if passing an Item
    elseif instanceof(args[1], "InventoryItem") and args[1]:getFullType() == o:getItemFullType() then
        local item = args[1]

        local modData = item:getModData() -- unused local, what for?
        o.type = o.Type
        o.name = item:getName()

    elseif type(args[1]) == "table" then
        o.type = o.Type
        o.name = args[1].name
    end

    return o
end

return PowerSupply
