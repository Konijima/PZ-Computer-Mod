---@class BaseHardware
local BaseHardware = {};
BaseHardware.Type = "BaseHardware";
BaseHardware.BaseType = "BaseHardware";
BaseHardware.Params = {
    { name = "type", type = "string" },
    { name = "name", type = "string" },
};

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
            local param = self.Params[i]
            modData[param.name] = self[param.name]
            print("-> ", param.name, " ", param.type, " ", type(self[param.name]))
        end
        item:setName(modData.name)
        return item
    end
end

---@param newType string
---@param name string
function BaseHardware:derive(newType, params)
    local o = {}
    setmetatable(o, self)
    self.__index = self
    o.Type = newType;
    if params and type(params) == "table" then
        for i, v in ipairs(params) do
            table.insert(o.Params, v);
        end
    end
    return o
end

function BaseHardware:new()
    local o = {}
    setmetatable(o, self)
    self.__index = self
    return o
end

function BaseHardware:init(...)
    local args = {...}

    -- Check if passing data
    if instanceof(args[1], "InventoryItem") and args[1]:getFullType() == self:getItemFullType() then
        print("Passing an item ", self.Type)
        local item = args[1]

        local modData = item:getModData() -- unused local, what for?
        for i = 1, #self.Params do
            local param = self.Params[i]
            self[param.name] = modData[param.name]
            if param.type == "table" and type(modData[param.name]) ~= "table" then
                self[param.name] = {}
            end
        end
        self.type = self.Type
        self.name = item:getName()

        -- Check if passing params
    elseif #args > 1 then
        print("Passing a args ", self.Type)
        for i = 1, #args do
            if type(args[i]) ~= self.Params[i].type then
                error("Error calling "..self.Type..":new - argument "..i.." ("..self.Params[i].name..") expected to be of type "..self.Params[i].type.." but was "..type(args[i])..".", 2);
            else
                self[self.Params[i].name] = args[i]
            end
        end

        -- Check if passing a table
    elseif type(args[1]) == "table" then
        print("Passing a table ", self.Type)
        for i = 1, #self.Params do
            local param = self.Params[i]
            self[param.name] = args[1][param.name]
            if param.type == "table" and type(args[1][param.name]) ~= "table" then
                self[param.name] = {}
            end
        end
    end
end

return BaseHardware
