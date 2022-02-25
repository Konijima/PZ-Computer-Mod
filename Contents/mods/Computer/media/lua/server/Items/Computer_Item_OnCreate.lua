local GameAPI = require("ComputerMod/GameAPI");

function ComputerMod_OnGameDiscCreated(item)
    GameAPI.RandomizeDiscItem(item);
end
