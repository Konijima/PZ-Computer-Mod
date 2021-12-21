require 'ISBaseObject';

---@class Email
local Email = ISBaseObject:derive("Email");

function Email:isValid()
    return true;
end

function Email:getStringDateTime()
    return self.datetime.day .. "/" .. self.datetime.month .. "/" .. self.datetime.year .. " at " .. self.datetime.hour .. ":" .. self.datetime.minute;
end

function Email:new(params)
    local o = {};
    setmetatable(o, self);
    self.__index = self;

    o.id = params.id;
    o.from = params.from;
    o.to = params.to;
    o.title = params.title;
    o.message = params.message;
    o.datetime = params.datetime;

    return o;
end

return Email;