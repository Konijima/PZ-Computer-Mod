require("ISBaseObject")

---@class BiosSetting
local BiosSetting = ISBaseObject:derive("BiosSetting")

-- TO-DO: check types as the value is saved in computer moddata, any isn't the right thing here

---@vararg any
---@return BiosSetting
function BiosSetting:new(...)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self

    local args = ...
    if type(...) ~= "table" then args = {...}; end

    local paramCheck = {
        {name = "key",              type = "string",    value = type(args[1])},
        {name = "name",             type = "string",    value = type(args[2])},
        {name = "descriptionOn",    type = "string",    value = type(args[3])},
        {name = "descriptionOff",   type = "string",    value = type(args[4])},
        {name = "default",          type = "any",       value = type(args[5])},
    }

    for i = 1, #args do
        if paramCheck[i].type ~= "any" and type(args[i]) ~= paramCheck[i].type then
            error("Error calling BiosSetting:new - Argument["..i.."] ("..paramCheck[i].name..") expected to be of type "..paramCheck[i].type.." but was "..paramCheck[i].value..".", 2);
        else
            o[paramCheck[i].name] = args[i]
        end
    end

    o.defaultType = type(o.default)

    --- Properties
    return o
end

return BiosSetting
