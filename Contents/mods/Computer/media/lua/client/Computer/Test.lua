
----------------------------------------
--- TESTING
----------------------------------------

print("Test Reloaded!");

----------------------------------------


--just a test



----------------------------------------

--Events.OnGameStart.Add(function()
--
--    require("CommunityAPI")
--
--    local startTime = os.time()
--
--    local function onComputerBoot(param1)
--        print("onComputerBoot", param1)
--        error("test")
--    end
--
--    CommunityAPI.Shared.Event.Add("Computer", "OnComputerBoot", onComputerBoot)
--
--    CommunityAPI.Shared.Event.Trigger("Computer", "OnComputerBoot", "Trigger 1") -- not triggered
--
--    --CommunityAPI.Shared.Event.Remove("Computer", "OnComputerBoot", onComputerBoot)
--
--    local endTime = os.time()
--
--    print(startTime, endTime, endTime - startTime)
--
--end)

----------------------------------------

-----@class HelicopterMod
--local HelicopterMod = {}
--HelicopterMod.functions = {}
--function HelicopterMod.functions.applyDeathOrCrawlerToCrew(isoZombie)
--    -- do thing
--end
--
--CommunityAPI.Client.Spawner.SpawnZombie(data, {
--    helicopterMod = {
--        eventNameToCall = "applyDeathOrCrawlerToCrew"
--    }
--})
--
--local function onZombieSpawned(isoZombie, additionalData)
--    if additionalData.helicopterMod then
--        if HelicopterMod.functions[additionalData.helicopterMod.eventNameToCall] then
--            HelicopterMod.functions[additionalData.helicopterMod.eventNameToCall](isoZombie)
--        end
--    end
--end
--CommunityAPI.Client.Spawner.OnZombieSpawned.Add(onZombieSpawned)

----------------------------------------

--ClimateManager.getInstance():
--
--function onConsumeItem(playerObj, items)
--    -- run a timed action
--end
--
--function doOnFillInventoryObjectContextMenu(player, context, items, item)
--
--    local playerObj = getSpecificPlayer(player)
--    local playerModData = playerObj:getModData()
--
--    local myItem
--    -- check if selected item/s is your item type
--    if instanceof(item, "InventoryItem") then
--        -- is the item
--        if item:getFullType() == "Module.MyItem" then
--            myItem = item
--        end
--    elseif items:size() > 0 then
--        -- is an ArrayList
--        myItem = items:get(0)
--    end
--
--    if myItem then
--        -- check if is allowed to consume if you want to limit it in anyway
--        if not playerModData.itemConsumed then
--            playerModData.itemConsumed = { }
--        end
--
--        -- add option to consume
--        context:addOption("Consume", playerObj, onConsumeItem, items)
--    end
--end
--
--Events.OnFillInventoryObjectContextMenu.Add(doOnFillInventoryObjectContextMenu)



--local dummy
--local function OnFillWorldObjectContextMenu(player, context, _, test)
--    if test then return end
--
--    local character = getSpecificPlayer(player)
--    local x = clickedSquare:getX()
--    local y = clickedSquare:getY()
--
--    if dummy then
--        getCell():addToProcessIsoObjectRemove(dummy)
--        dummy = nil
--        IsoCamera.setCamCharacter(character)
--        print("removed dummy")
--    else
--        SystemDisabler.setOverridePOVCharacters(true)
--        dummy = IsoDummyCameraCharacter.new(x, y, 0)
--        getCell():addMovingObject(dummy)
--        --IsoCamera.setCamCharacter(dummy)
--        print("created dummy")
--    end
--
--end
--Events.OnFillWorldObjectContextMenu.Add(OnFillWorldObjectContextMenu)
--

----------------------------------------

---- Check a java object class fields
--local player = getPlayer()
--local fieldNum = getNumClassFields(player)
--for i=1, fieldNum-1 do
--    print(getClassField(player, i))
--end
--
---- Check a java object class functions
--local funcNum = getNumClassFunctions(player)
--for i=1, funcNum-1 do
--    print(getClassFunction(player, i))
--end
--
--function causeErrorButDontStopExecution(param1, param2)
--    error("Error!!!")
--end
--
--local hasError = pcall(causeErrorButDontStopExecution, "param1", "param2")
--if hasError then
--    print("There was an error running causeErrorButDontStopExecution() but this still got printed !")
--end

----------------------------------------

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