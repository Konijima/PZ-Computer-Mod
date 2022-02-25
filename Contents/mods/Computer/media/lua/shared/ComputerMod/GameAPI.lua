
local games = {};

local GameAPI = {};

function GameAPI.GetAll()
    return copyTable({}, games);
end

function GameAPI.Get(id)
    return copyTable({}, games[id]);
end

function GameAPI.GetRandom()
    local keys = {};
	for k in pairs(games) do
		table.insert(keys, k);
	end
	local rand = ZombRand(1, #keys);
	return GameAPI.Get(keys[rand]);
end

function GameAPI.Add(id, title, year, publisher, genre, audio)
    games[id] = {
        id = id,
        title = title,
        date = date,
        publisher = publisher,
        genre = genre,
        audio = audio,
    };
    print("Adding computer game: " .. id);
end

function GameAPI.Remove(id)
    games[id] = nil;
end

function GameAPI.RandomizeDiscItem(item)
    if item and item:getType() == "Disc_Game" then
        local game = GameAPI.GetRandom()
        if game then
            item:setName("Game CD: " .. game.title);
            item:getModData().game = game;
            print("Randomize new Game CD:");
            print("Title: " .. tostring(game.title));
            print("Date: " .. tostring(game.date));
            print("Publisher: " .. tostring(game.publisher));
            print("Genre: " .. tostring(game.genre));
        end
    end
end

return GameAPI;
