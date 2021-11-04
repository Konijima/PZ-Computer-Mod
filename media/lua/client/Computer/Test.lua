
----------------------------------------
--- TESTING
----------------------------------------

print("Test Reloaded!");














----- Find all ComputerMedium in container when loot is spawning
-----@param name string
-----@param type string
-----@param container ItemContainer
--Events.OnFillContainer.Add(function(oname, otype, container)
--    if instanceof(container, "ItemContainer") then
--        local ComputerMediums = ComputerUtils.findAllByTag(container, "ComputerMedium")
--        if ComputerMediums and ComputerMediums:size() > 0 then
--            for i=0, ComputerMediums:size()-1 do
--                local item = ComputerMediums:get(i)
--                print(oname, " ", otype, " ", item:getType())
--            end
--        end
--    end
--end)

--local gameStarted = false
--local totalObjectAdded = 0
--local totalObjectRemoved = 0
--local totalSquareLoaded = 0
--
-----@param isoObject IsoObject
--Events.OnObjectAdded.Add(function(isoObject)
--    totalObjectAdded = totalObjectAdded + 1
--    if instanceof(isoObject, "IsoObject") then print("#-------IsoObject added ", isoObject:getName())
--    elseif instanceof(isoObject, "InventoryItem") then print("#-------InventoryItem added ", isoObject:getName())
--    else print("#-------Object added ", isoObject:getName()) end
--end)
--
-----@param isoObject IsoObject
--Events.OnObjectAboutToBeRemoved.Add(function(isoObject)
--    totalObjectRemoved = totalObjectRemoved + 1
--    print("#-------Object remove ", isoObject:getName())
--end)
--
-----@param square IsoGridSquare
--Events.LoadGridsquare.Add(function(square)
--    totalSquareLoaded = totalSquareLoaded + 1
--end)
--
--Events.OnPlayerMove.Add(function()
--    ---print("#-------OnPlayerMove")
--end)

--Events.OnGameStart.Add(function()
--    if gameStarted then return end
--    gameStarted = true
--    print("#-------Total Object Added: ", totalObjectAdded);
--    print("#-------Total Object Removed: ", totalObjectRemoved);
--    print("#-------Total Square Loaded: ", totalSquareLoaded);
--end)

----------------------------------------

--local BaseDrive = ISBaseObject:derive("BaseDrive")
--local Harddrive = BaseDrive:derive("Harddrive")
--local newHarddrive = Harddrive:new()
--
--print(1,ComputerUtils.getBaseClass(newHarddrive).Type)
--print(2,ComputerUtils.getBaseClass(newHarddrive, 2).Type)
--print(3,ComputerUtils.getBaseClass(newHarddrive, 3).Type)
--print(4,ComputerUtils.getBaseClass(newHarddrive, 4).Type)
--print(5,ComputerUtils.getBaseClass(newHarddrive, 5).Type)

----------------------------------------

--local BaseClass = {}
--BaseClass.Type = "BaseClass"
--BaseClass.Params = {}
--function BaseHardware:addParam(name, type)
--    table.insert(self.Params, { name = name, type = type })
--end
--function BaseClass:derive(type)
--    local o = {}
--    setmetatable(o, self)
--    self.__index = self
--    o.Type = type
--    return o
--end
--function BaseClass:new(type)
--    local o = {}
--    setmetatable(o, self)
--    self.__index = self
--    print("From within BaseClass:new ", o.Type) -- BaseClass
--    return o
--end
--function BaseClass:init(...)
--    print("From within BaseClass:init ", self.Type) -- DerivedClass
--end

--local DerivedClass = BaseClass:derive("DerivedClass")
--function DerivedClass:new(...)
--    local o = BaseClass:new()
--    setmetatable(o, self)
--    self.__index = self
--    print("From within DerivedClass:new ", o.Type) -- DerivedClass
--    o:init(...)
--    return o
--end
--
--DerivedClass:new()

----------------------------------------

--local class1 = ISBaseObject:derive("class1")
--local class2 = class1:derive("class2")
--local class3 = class2:derive("class3")
--local class4 = class3:derive("class4")
--
--local object = class4:new()
--
--local allBaseClasses = ComputerUtils.getAllBaseClasses(object, true)
--if allBaseClasses then
--    for i=1, #allBaseClasses do
--        print(i, ": ", allBaseClasses[i].Type)
--    end
--end
--
--print(ComputerUtils.isClassChildOf(object, nil))

----------------------------------------