require("ISBaseObject")

---------------------------------------------------------------------------------

--{{{ class InventoryTooltipField

---@class InventoryTooltipField
local InventoryTooltipField = ISBaseObject:derive("InventoryTooltipField")

---@param item InventoryItem
function InventoryTooltipField:getValue(item)
    local valueType = type(self.getValueFunc)
    if valueType == "function" then
        self.getValueFunc(self.result, item)
    elseif valueType == "string" or valueType == "number" or valueType == "boolean" then
        self.result.value = self.getValueFunc
    end
end

---@param fieldType string field, label, progress, spacer
---@param name string
---@param param string|number|boolean|function
function InventoryTooltipField:new(fieldType, name, getValueFunc, labelColor)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self
    o.fieldType = fieldType
    o.name = name
    o.result = {
        value = nil,
        color = nil,
        labelColor = nil,
    }
    o.getValueFunc = getValueFunc

    if fieldType == "label" and type(labelColor) == "table" then
        if type(o.result.labelColor) ~= "table" then o.result.labelColor = {}; end
        if type(labelColor.r) == "number" then o.result.labelColor.r = labelColor.r; end
        if type(labelColor.g) == "number" then o.result.labelColor.g = labelColor.g; end
        if type(labelColor.b) == "number" then o.result.labelColor.b = labelColor.b; end
        if type(labelColor.a) == "number" then o.result.labelColor.a = labelColor.a; end
    end

    return o
end

--}}}

---------------------------------------------------------------------------------

--{{{ class InventoryTooltipInstance

---@class InventoryTooltipInstance
local InventoryTooltipInstance = ISBaseObject:derive("InventoryTooltipInstance")

---@param name string
---@param getValueFunc string|number|boolean|function
---@return InventoryTooltipField
function InventoryTooltipInstance:addField(name, getValueFunc)
    self.fields[name] = InventoryTooltipField:new("field", name, getValueFunc)
    return self.fields[name]
end

---@param getValueFunc string|function
---@return InventoryTooltipField
function InventoryTooltipInstance:addLabel(getValueFunc, paramColor)
    local name = "label_" .. self:fieldCount()
    self.fields[name] = InventoryTooltipField:new("label", name, getValueFunc, paramColor)
    return self.fields[name]
end

---@param name string
---@param getValueFunc number|function
---@return InventoryTooltipField
function InventoryTooltipInstance:addProgress(name, getValueFunc)
    self.fields[name] = InventoryTooltipField:new("progress", name, getValueFunc)
    return self.fields[name]
end

---@param getValueFunc string|number|boolean|function
---@return InventoryTooltipField
function InventoryTooltipInstance:addSpacer()
    local name = "spacer_" .. self:fieldCount()
    self.fields[name] = InventoryTooltipField:new("spacer", name)
    return self.fields[name]
end

---@return number
function InventoryTooltipInstance:fieldCount()
    local count = 0
    for _ in pairs(self.fields) do count = count + 1 end
    return count
end

---@param itemFullType string
---@return InventoryTooltipInstance
function InventoryTooltipInstance:new(itemFullType)
    local o = ISBaseObject:new()
    setmetatable(o, self)

    self.__index = self
    o.itemFullType = itemFullType
    o.fields = {}
    return o
end

return InventoryTooltipInstance

--}}}

---------------------------------------------------------------------------------