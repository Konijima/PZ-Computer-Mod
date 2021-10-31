function CustomError(_text, _requireAction, _centered, _width, _height, _posX, _posY)
    local coroutine = getCurrentCoroutine();
    local count = getCoroutineTop(coroutine);
    local stacktrace = ArrayList.new();
    for i= count - 3, 0, -1 do
        local o = getCoroutineObjStack(coroutine,i);
        if o ~= nil then
            local s = KahluaUtil.rawTostring2(o);
            if s ~= nil then
                stacktrace:add(s)
            end
        end
    end
    local posX = _posX or 0;
    local posY = _posY or 0;
    local width = _width or 500;
    local height = _height or 0;
    local text = "Unknown Text Type for custom Error!";
    if type(_text) == "string" then
        text = _text;
    elseif type(_text) == "table" then
        text = (
            "<H2><CENTRE><RED>".._text[1].." ERROR <LINE><TEXT> An error occured in  <ORANGE> "..
            _text[2].." <TEXT>. <LINE>"
        )
        for i = 3, #_text do
            text = text .. _text[i].. " <LINE>"
        end
        text = text .. "<RGB:0.45,0.45,0.45>"
        for i = stacktrace:size()-1, 0, -1 do
            text = text .. " <LINE>[".. math.abs(i-stacktrace:size()) .. "]"..stacktrace:get(i).. " ";
        end
    end
    local centered = _centered or false;
    local required = _requireAction or false;
    local core = getCore();
    local posX = _posX or core:getScreenWidth() - width;
    local posY = _posY or core:getScreenHeight() - height;

    if centered then
        posX = core:getScreenWidth() * 0.5 - width * 0.5;
        posY = core:getScreenHeight() * 0.5 - height * 0.5;
    end
    local modal = ISModalRichText:new(posX, posY, width, height, text, false, nil, nil, nil, nil, nil);
    modal:initialise();
    modal:addToUIManager();
    if UIManager.getSpeedControls() and (UIManager.getSpeedControls():getCurrentGameSpeed() > 0) then
        UIManager.getSpeedControls():SetCurrentGameSpeed(0)
    end
end