local EmailService = require("Computer/EmailService");

local Commands = {
    EmailService = {}
};

---@param player IsoPlayer
function Commands.EmailService.CreateUser(player, args)
    local username = player:getUsername();
    EmailService.createUser(username);
end

---@param player IsoPlayer
function Commands.EmailService.SendEmail(player, args)
    local username = player:getUsername();
    EmailService.sendMail(username, args.to, args.title, args.message);
end

---@param player IsoPlayer
function Commands.EmailService.ReadEmail(player, args)
    local username = player:getUsername();
    EmailService.readEmail(username, args.emailId);
end

---@param player IsoPlayer
function Commands.EmailService.DeleteEmail(player, args)
    local username = player:getUsername();
    EmailService.deleteEmail(username, args.emailId);
end

-------------------------------------------------------------

function onInitGlobalModData(isNewGame)
    EmailService.initialize();
end
Events.OnInitGlobalModData.Add(onInitGlobalModData)

local function onClientCommand(module, command, player, args)
    if Commands[module] and Commands[module][command] then
        Commands[module][command](player, args);
    end
end
Events.OnClientCommand.Add(onClientCommand);
