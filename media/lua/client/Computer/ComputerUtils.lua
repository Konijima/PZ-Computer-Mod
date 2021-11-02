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
---@return ArrayList|nil
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

--- Get the base class of object, optionally choose how deep you want to check.
---@param object table Will return nil if the object is not a table.
---@param level  number Will return the deepest found if level is higher than the actual amount of base classes.
function ComputerUtils.getBaseClass(object, level)
    if not level or level < 1 then level = 1; end

    if type(object) == "table" then
        local baseClass = getmetatable(object)
        for i=2, level do
            if type(baseClass) == "table" then
                local class = getmetatable(baseClass)
                if class then
                    baseClass = class
                end
            end
        end
        return baseClass
    end
end

--- Get a table with all the base class from the current to the deepest.
---@param object table Will return nil if the object is not a table.
---@param exludeCurrent boolean optionally exclude the current object class from the list
---@return table|nil
function ComputerUtils.getAllBaseClasses(object, exludeCurrent)
    if type(object) == "table" then
        local baseClasses = {}
        local current = getmetatable(object)

        local lastBaseClass
        for i=1, 10 do
            local baseClass = ComputerUtils.getBaseClass(object, i)
            if baseClass ~= nil and lastBaseClass ~= baseClass then
                if not exludeCurrent or exludeCurrent and current ~= baseClass then
                    table.insert(baseClasses, baseClass)
                end
                lastBaseClass = baseClass
            else
                break
            end
        end

        return baseClasses
    end
end

--- Check if table object is derive from this class
---@param object table The table object to check
---@param class table|string The class to find
---@return boolean
function ComputerUtils.isClassChildOf(object, class)
    local classType = type(class)
    local allBaseClasses = ComputerUtils.getAllBaseClasses(object, false)
    if allBaseClasses then
        for i=1, #allBaseClasses do
            if (classType == "table" and allBaseClasses[i] == class) or (classType == "string" and allBaseClasses[i].Type == class) then
                return true
            end
        end
    end
    return false
end
