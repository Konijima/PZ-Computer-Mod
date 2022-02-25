
local function onClientCommand(module, command, playerObj, data)
    if module ~= "ComputerMod" then return; end

    if command == "ComputerTurnedOn" or command == "ComputerTurnedOff" then
        print("[ComputerModServer] Recieved command " .. command);
        if isServer() then
            sendServerCommand(module, command, data);
        else
            triggerEvent("OnServerCommand", module, command, data)
        end
    end

end
Events.OnClientCommand.Add(onClientCommand);
