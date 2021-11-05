require("ISBaseObject")

---@class LightInstance
local LightInstance = ISBaseObject:derive("LightInstance")

function LightInstance:getSquare()
    return getCell():getGridSquare(self.x, self.y, self.z)
end

function LightInstance:remove()
    if self.lightSource ~= nil then
        getCell():removeLamppost(self.lightSource)
        self.lightSource = nil
        print("Light Instance removed at x:", self.x, " y:", self.y, " z:", self.z)
    end
end

function LightInstance:setRadius(radius)
    if type(radius) ~= "number" then radius = 2.0 end
    self.radius = radius
end

function LightInstance:setColor(r, g, b)
    if type(r) ~= "number" then r = 0.33 end
    if type(g) ~= "number" then g = 0.33 end
    if type(b) ~= "number" then b = 0.33 end
    self.color = { r = r, g = g, b = b }
end

function LightInstance:update()
    local square = getCell():getGridSquare(self.x, self.y, self.z)
    if square == nil and self.lightSource then
        getCell():removeLamppost(self.lightSource)
        self.lightSource = nil
    end

    if square and self.lightSource == nil then
        self.lightSource = IsoLightSource.new(self.x, self.y, self.z, 0.0, 0.0, 1.0, self.radius)
        self.lightWasRemoved = true
    end

    if self.lightWasRemoved then
        getCell():addLamppost(self.lightSource)
        IsoGridSquare.RecalcLightTime = -1
        self.lightWasRemoved = false
    end

    if self.lightSource ~= nil then
        IsoGridSquare.RecalcLightTime = -1
        self.lightSource:setRadius(self.radius)
        self.lightSource:setR(self.color.r)
        self.lightSource:setG(self.color.g)
        self.lightSource:setB(self.color.b)
    end
end

---@param x number
---@param y number
---@param z number
---@param radius number
---@param r number
---@param g number
---@param b number
function LightInstance:new(x, y, z, radius, r, g, b)
    local o = ISBaseObject:new()
    setmetatable(o, self)
    self.__index = self

    o.lightSource = nil
    o.x = x
    o.y = y
    o.z = z
    o.lightWasRemoved = false

    o:setColor(r, g, b)
    o:setRadius(radius)

    return o
end

return LightInstance