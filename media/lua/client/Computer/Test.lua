
----------------------------------------
--- TESTING
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