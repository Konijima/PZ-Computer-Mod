---@class ComputerUtils
ComputerUtils = ComputerUtils or {}

---@param table table
---@param value any
---@return boolean
function ComputerUtils.tableContains(table, value)
    if type(table) == "table" then
        for i=1, #table do
            if table[i] == value then
                return true
            end
        end
        for k, v in pairs(table) do
            if v == value then
                return true
            end
        end
    end
    return false
end

---@param inventory ItemContainer
---@param tag string
---@return ArrayList | nil
function ComputerUtils.findAllByTag(inventory, tag)
    if instanceof(inventory, "ItemContainer") and type(tag) == "string" then
        local foundItems = ArrayList.new();
        local validItems = getScriptManager():getItemsTag(tag);
        if validItems then
            for i=0, validItems:size()-1 do
                foundItems:addAll(inventory:getItemsFromFullType(validItems:get(i):getFullName()));
            end
        end
        return foundItems;
    end
end

---@param x number
---@param y number
---@param z number
---@return string
function ComputerUtils.positionToId(x, y, z)
    if type(x) == "number" and type(y) == "number" and type(z) == "number" then
        return x .. "|" .. y .. "|" .. z
    end
end

---@param square IsoGridSquare
---@return string
function ComputerUtils.squareToId(square)
    if instanceof(square, "IsoGridSquare") then
        return square:getX() .. "|" .. square:getY() .. "|" .. square:getZ()
    end
end