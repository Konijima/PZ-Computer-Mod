local old_render = ISToolTipInv.render
function ISToolTipInv:render()
	
	-- Get the game data from disc
	local gameData = ComputerMod.getGameDiscData(self.item) --- Getting the custom data from Item
	local game
	if gameData then
		-- Get the game from game database
		-- This way information can be updated
		game = ComputerMod.getGame(gameData.id)
	end

	-- Only override for item type Disc_Game
	if game == nil or self.item == nil or self.item:getType() ~= "Disc_Game" then
		return old_render(self)
	end
	
	local old_setWidth = self.setWidth
	local old_setHeight = self.setHeight
	local old_drawRectBorder = self.drawRectBorder

	local font = UIFont[getCore():getOptionTooltipFont()]

	local amountOfCustomLine = 4 --- Set the amount of custom lines you have
	local wos = self.tooltip:getWeightOfStack()
	local mainColor = { 1, 1, 0.8 } --- Color of the left text
	local secondColor = { 1, 1, 1 } --- Color of the right text
	local textHeight = getTextManager():MeasureStringY(font, "HEIGHT") --- Just calculating the height of a line of text

	--- setWidth
	self.setWidth = function(self, num, ...)

		local max = 0

		-- We check which data is the longest

		local titleWidth = getTextManager():MeasureStringX(font, game.title)
		max = math.max(max, titleWidth)

		local publisherWidth = getTextManager():MeasureStringX(font, game.publisher)
		max = math.max(max, publisherWidth)

		local genreWidth = getTextManager():MeasureStringX(font, game.genre)
		max = math.max(max, genreWidth)

		num = max + 110

		return old_setWidth(self, num, ...)
	end

	--- setHeight
	self.setHeight = function(self, num, ...)
		num = textHeight * (amountOfCustomLine + 2) + 15
		if wos > 0 then num = num + textHeight end
		return old_setHeight(self, num, ...)
	end

	--- drawRectBorder
	self.drawRectBorder = function(self, ...)
		local x = 5
		local y = textHeight * 2 + 10
		local count = 0

		if wos > 0 then y = y + textHeight end

		--- Custom Line 1
		self.tooltip:DrawText(font, "Title: ", x, y + textHeight * count, mainColor[1], mainColor[2], mainColor[3], 1)
		self.tooltip:DrawText(font, game.title, x + 87, y + textHeight * count, secondColor[1], secondColor[2], secondColor[3], 1)
		count = count + 1

		--- Custom Line 2
		self.tooltip:DrawText(font, "Publisher: ", x, y + textHeight * count, mainColor[1], mainColor[2], mainColor[3], 1)
		self.tooltip:DrawText(font, game.publisher, x + 87, y + textHeight * count, secondColor[1], secondColor[2], secondColor[3], 1)
		count = count + 1

		--- Custom Line 3
		--self.tooltip:DrawText(font, "Released:", x, y + textHeight * count, mainColor[1], mainColor[2], mainColor[3], 1)
		--self.tooltip:DrawText(font, game.date, x + 87, y + textHeight * count, secondColor[1], secondColor[2], secondColor[3], 1)
		--count = count + 1

		--- Custom Line 4
		self.tooltip:DrawText(font, "Genre: ", x, y + textHeight * count, 0, mainColor[1], mainColor[2], mainColor[3], 1)
		self.tooltip:DrawText(font, game.genre, x + 87, y + textHeight * count, secondColor[1], secondColor[2], secondColor[3], 1)
		count = count + 1

		return old_drawRectBorder(self, ...)
	end

	old_render(self)
	self.setWidth = old_setWidth
	self.setHeight = old_setHeight
	self.drawRectBorder = old_drawRectBorder
end