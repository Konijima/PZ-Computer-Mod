require("ISBaseObject")

---@class ComputerEvent
local ComputerEvent = ISBaseObject:derive("ComputerEvent")

---@param func function
function ComputerEvent:add(func)
    if func and type(func) == "function" then
        self.handlers:add(func)
    end
end

---@param func function
function ComputerEvent:remove(func)
    if func and type(func) == "function" then
        self.handlers:remove(func)
    end
end

---@param eventName string
---@vararg any
function ComputerEvent:trigger(eventName, ...)
    local args = {...}

    for i, param in ipairs(self.paramTypes) do
        if param ~= "any" and (args[i] == nil or (type(args[i]) == param or instanceof(args[i], param) or (getmetatable(args[i]) ~= nil and (getmetatable(args[i]).Type == param or getmetatable(getmetatable(args[i])).Type == param))) == false) then
            error("ComputerEvent Trigger Error: Argument["..i.."] expected to be "..param..".", 2);
            return;
        end
    end

    for i=0, self.handlers:size()-1 do
        local handler = self.handlers:get(i)
        if not pcall(handler, ...) then
            self:remove(handler)
            print("ComputerEvent Error: Function removed from "..eventName.." due to error.");
        end
    end
end

---@param paramTypes table<string>|nil
---@return ComputerEvent
function ComputerEvent:new(paramTypes)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self

    o.paramTypes = paramTypes

    --- Properties
    o.handlers = ArrayList.new()
    return o
end

return ComputerEvent
