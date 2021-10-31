ComputerUtils = ComputerUtils or {}

--- tableContains
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

--- findAllByTag
function ComputerUtils.findAllByTag(inventory, tag)
    if instanceof(inventory, "ItemContainer") and type(tag) == "string" then
        local validItems = getScriptManager():getItemsTag(tag);
        local foundItems = ArrayList.new();
        for i=0, validItems:size()-1 do
            foundItems:addAll(inventory:getItemsFromFullType(validItems:get(i):getFullName()));
        end
        return foundItems;
    end
end

--- positionToId
function ComputerUtils.positionToId(x, y, z)
    if type(x) == "number" and type(y) == "number" and type(z) == "number" then
        return x .. "|" .. y .. "|" .. z
    end
end

--- squareToId
function ComputerUtils.squareToId(square)
    if instanceof(square, "IsoGridSquare") then
        return square:getX() .. "|" .. square:getY() .. "|" .. square:getZ()
    end
end