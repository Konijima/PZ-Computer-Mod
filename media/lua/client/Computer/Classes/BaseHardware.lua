---@class BaseHardware
local BaseHardware = {};
BaseHardware.Type = "BaseHardware";

---@return string
function BaseHardware:getItemFullType()
    return "Computer."..self.Type
end

---@return string
function BaseHardware:getTooltipDescription()
    return "No description set"
end

---@param inventory ItemContainer
---@return InventoryItem|nil
function BaseHardware:createItem(inventory)
    if instanceof(inventory, "ItemContainer") then
        local item = inventory:AddItem(self:getItemFullType())
        local modData = item:getModData()
        print("Setting mod data in item:")
        for i = 1, #self.Params do
            local classParam = self.Params[i]
            modData[classParam.name] = self[classParam.name]
            --print("-> ", classParam.name, " ", classParam.type, " ", type(self[classParam.name]))
        end
        item:setName(modData.name)
        return item
    end
end

---@param classType string
---@param classParams table
---@return BaseHardware
function BaseHardware:derive(classType, classParams)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.Type = classType;
    o.Params = {
        { name = "hardwareType", type = "string" },
        { name = "name", type = "string" },
    }
    if classParams and type(classParams) == "table" then
        for i, _ in ipairs(classParams) do
            local entry = classParams[i]
            if type(entry) ~= "table" then
                error("ComputerMod: Derive '"..classType.."' error param["..i.."] must be a table!")
            end
            if type(entry["name"]) ~= "string" then
                error("ComputerMod: Derive '"..classType.."' error param["..i.."] .name must be a string!")
            end
            if type(entry["type"]) ~= "string" then
                error("ComputerMod: Derive '"..classType.."' error param["..i.."] .type must be a string!")
            end
            table.insert(o.Params, entry);
        end
    end
    return o
end

---@return BaseHardware
function BaseHardware:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

---@vararg string|number|table|InventoryItem
function BaseHardware:init(...)
    local args = {...}

    -- Check if passing an InventoryItem
    if instanceof(args[1], "InventoryItem") and args[1]:getFullType() == self:getItemFullType() then
        local item = args[1]

        local modData = item:getModData() -- unused local, what for?
        for i = 1, #self.Params do
            local classParam = self.Params[i]
            self[classParam.name] = modData[classParam.name]
            if classParam.type == "table" and type(modData[classParam.name]) ~= "table" then
                self[classParam.name] = {}
            end
        end
        self.hardwareType = self.Type
        self.name = item:getName()

    -- Check if passing arguments
    elseif #args > 1 then
        for i = 1, #args do
            if type(args[i]) ~= self.Params[i].type then
                error("Error calling "..self.Type..":new - argument "..i.." ("..self.Params[i].name..") expected to be of type "..self.Params[i].type.." but was "..type(args[i])..".", 2);
            else
                self[self.Params[i].name] = args[i]
            end
        end

    -- Check if passing a key table
    elseif type(args[1]) == "table" then
        for i = 1, #self.Params do
            local classParam = self.Params[i]
            self[classParam.name] = args[1][classParam.name]
            if classParam.type == "table" and type(args[1][classParam.name]) ~= "table" then
                self[classParam.name] = {}
            end
        end
    end
end

return BaseHardware
