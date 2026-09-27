options_menu = {}

------------------------------------------------
-- DEPENDANCES
------------------------------------------------

local SimpleButton = require("simpleButton")
Checkbox = require("checkbox")

------------------------------------------------
-- CONFIG
------------------------------------------------

local PAGE_WIDTH = 140
local PAGE_HEIGHT = 160

local CONTENT_X = 10
local CONTENT_Y = 30

local CONTENT_WIDTH = 120
local CONTENT_HEIGHT = 120

local PAGE_COUNT = 4
local PAGE_SCROLL = 120

------------------------------------------------
-- POSITION DU MENU
------------------------------------------------

local OPTIONS_SCREEN_X = 90
local OPTIONS_SCREEN_Y = 40

------------------------------------------------
-- CANVAS
------------------------------------------------

local OptionsCanvas
local ContentCanvas

------------------------------------------------
-- SCROLL
------------------------------------------------

local optionsScrollX = 0
local optionsTargetX = 0

local optionsScrollSpeed = 400

------------------------------------------------
-- ETAT
------------------------------------------------

show_particles = true
show_shadows = true
show_fps = false

------------------------------------------------
-- ASSETS
------------------------------------------------

local btn_closeOptions

local btn_language
local btn_graphics
local btn_credits

local btn_back_language
local btn_back_graphics
local btn_back_credits

local ui_btn_arrow
local ui_btn_arrow_disabled

local ui_btn_planet
local ui_btn_planet_disabled

local check_particles
local check_shadows
local check_fps

local en_language
local fr_language

local closeNormal
local closePressed

local sfx_page
local sfx_closePressed
local sfx_closeReleased
local sfx_volumeChanged
local sfx_sfxVolume

------------------------------------------------
-- EASING
------------------------------------------------

local function easeOutCubic(t)

    return 1 - (1 - t)^3

end

------------------------------------------------
-- LOAD
------------------------------------------------

function options_menu.load()
    
    ------------------------------------------------
    -- CANVAS
    ------------------------------------------------

    OptionsCanvas = love.graphics.newCanvas(
        PAGE_WIDTH,
        PAGE_HEIGHT
    )

    ContentCanvas = love.graphics.newCanvas(
        CONTENT_WIDTH,
        CONTENT_HEIGHT
    )

    ------------------------------------------------
    -- AUDIO
    ------------------------------------------------

    sfx_page = love.audio.newSource(
        "Audio/SFX/Page.ogg",
        "static"
    )

    sfx_closePressed = love.audio.newSource(
        "Audio/SFX/Buttons/ClosePress.ogg",
        "static"
    )

    sfx_closeReleased = love.audio.newSource(
        "Audio/SFX/Buttons/CloseRelease.ogg",
        "static"
    )

    sfx_volumeChanged = love.audio.newSource(
        "Audio/SFX/Buttons/VolumeChanged.ogg",
        "static"
    )
    ------------------------------------------------
    -- IMAGES
    ------------------------------------------------

    ui_btn_arrow = love.graphics.newImage(
        "Sprites/UI/Menu/Buttons/ArrowButton.png"
    )

    ui_btn_arrow_disabled = love.graphics.newImage(
        "Sprites/UI/Menu/Buttons/ArrowButtonDisabled.png"
    )

    ui_btn_planet = love.graphics.newImage(
        "Sprites/UI/Menu/Buttons/PlanetButton.png"
    )

    ui_btn_planet_disabled = love.graphics.newImage(
        "Sprites/UI/Menu/Buttons/PlanetButtonDisabled.png"
    )

    closeNormal = love.graphics.newImage(
        "Sprites/UI/Menu/Buttons/Close.png"
    )

    closePressed = love.graphics.newImage(
        "Sprites/UI/Menu/Buttons/ClosePressed.png"
    )

    ------------------------------------------------
    -- BOUTON CLOSE
    ------------------------------------------------

    btn_closeOptions = SimpleButton:new(
        114,
        7,
        closeNormal,
        closePressed,
        sfx_closePressed,
        sfx_closeReleased
    )

    btn_closeOptions:setOnClick(function()

        menuState = 1
        btn_closeOptions:cancel()

    end)

    ------------------------------------------------
    -- PAGE PRINCIPALE
    ------------------------------------------------

    btn_language = SimpleButton:new(
        106,
        59,
        ui_btn_planet,
        ui_btn_planet_disabled,
        sfx_closePressed,
        sfx_page
    )

    btn_graphics = SimpleButton:new(
        106,
        79,
        ui_btn_arrow,
        ui_btn_arrow_disabled,
        sfx_closePressed,
        sfx_page
    )

    btn_credits = SimpleButton:new(
        106,
        99,
        ui_btn_arrow,
        ui_btn_arrow_disabled,
        sfx_closePressed,
        sfx_page
    )

    btn_language:setOnClick(function()

        optionsTargetX = 120

    end)

    btn_graphics:setOnClick(function()

        optionsTargetX = 240

    end)

    btn_credits:setOnClick(function()

        optionsTargetX = 360

    end)

    ------------------------------------------------
    -- RETOUR
    ------------------------------------------------

    btn_back_language = SimpleButton:new(
        5,
        5,
        ui_btn_arrow,
        ui_btn_arrow_disabled,
        sfx_closePressed,
        sfx_page
    )

    btn_back_graphics = SimpleButton:new(
        5,
        5,
        ui_btn_arrow,
        ui_btn_arrow_disabled,
        sfx_closePressed,
        sfx_page
    )

    btn_back_credits = SimpleButton:new(
        5,
        5,
        ui_btn_arrow,
        ui_btn_arrow_disabled,
        sfx_closePressed,
        sfx_page
    )

    btn_back_language:setOnClick(function()

        optionsTargetX = 0

    end)

    btn_back_graphics:setOnClick(function()

        optionsTargetX = 0

    end)

    btn_back_credits:setOnClick(function()

        optionsTargetX = 0

    end)

    ------------------------------------------------
    -- CHECKBOX
    ------------------------------------------------

    check_particles = Checkbox:new(
        0,
        50,
        love.graphics.newImage(
            "Sprites/UI/Menu/Buttons/CheckDot.png"
        ),
        love.graphics.newImage(
            "Sprites/UI/Menu/Buttons/CheckDotActive.png"
        ),
        sfx_closePressed,
        sfx_closeReleased,
        true
    )

    check_shadows = Checkbox:new(
        0,
        70,
        love.graphics.newImage(
            "Sprites/UI/Menu/Buttons/CheckDot.png"
        ),
        love.graphics.newImage(
            "Sprites/UI/Menu/Buttons/CheckDotActive.png"
        ),
        sfx_closePressed,
        sfx_closeReleased,
        true
    )

    check_fps = Checkbox:new(
        0,
        90,
        love.graphics.newImage(
            "Sprites/UI/Menu/Buttons/CheckDot.png"
        ),
        love.graphics.newImage(
            "Sprites/UI/Menu/Buttons/CheckDotActive.png"
        ),
        sfx_closePressed,
        sfx_closeReleased,
        false
    )

    en_language = Checkbox:new(
        0,
        50,
        love.graphics.newImage(
            "Sprites/UI/Menu/Buttons/CheckDot.png"
        ),
        love.graphics.newImage(
            "Sprites/UI/Menu/Buttons/CheckDotActive.png"
        ),
        sfx_closePressed,
        sfx_closeReleased,
        true
    )

    fr_language = Checkbox:new(
        0,
        70,
        love.graphics.newImage(
            "Sprites/UI/Menu/Buttons/CheckDot.png"
        ),
        love.graphics.newImage(
            "Sprites/UI/Menu/Buttons/CheckDotActive.png"
        ),
        sfx_closePressed,
        sfx_closeReleased,
        false
    )

    check_particles:setOnToggle(function(v)

        show_particles = v

    end)

    check_shadows:setOnToggle(function(v)

        show_shadows = v

    end)

    check_fps:setOnToggle(function(v)

        show_fps = v

    end)

    en_language:setOnToggle(function(v)
    
        if v == true then
            Language.load("en")
            fr_language.checked = false
        else
            Language.load("fr")
            fr_language.checked = true
        end

    end)

    fr_language:setOnToggle(function(v)
    
        if v == true then
            Language.load("fr")
            en_language.checked = false
        else
            Language.load("en")
            en_language.checked = true
        end

    end)

    sfx_sfxVolume = Resources.sfx("Audio/SFX/Throw.ogg")

end

------------------------------------------------
-- UPDATE
------------------------------------------------

function options_menu.update(dt)

    local diff =
        optionsTargetX - optionsScrollX

    if math.abs(diff) < 0.01 then

        optionsScrollX = optionsTargetX
        return

    end

    local t =
        math.min(1, dt * optionsScrollSpeed)

    optionsScrollX =
        optionsScrollX +
        diff * easeOutCubic(t)

end

------------------------------------------------
-- PAGE MAIN
------------------------------------------------

local function drawOptionsMain(x)

    love.graphics.setColor(0,0,0,1)

    love.graphics.printf(
        Language.get("language"),
        x + 4,
        60,
        120,
        "left"
    )

    love.graphics.printf(
        Language.get("graphics"),
        x + 4,
        80,
        120,
        "left"
    )

    love.graphics.printf(
        Language.get("credits"),
        x + 4,
        100,
        120,
        "left"
    )

    love.graphics.setColor(1,1,1,1)

    love.graphics.draw(
        ui_btn_planet,
        x + 106,
        59
    )

    love.graphics.draw(
        ui_btn_arrow,
        x + 106,
        79
    )

    love.graphics.draw(
        ui_btn_arrow,
        x + 106,
        99
    )
end

------------------------------------------------
-- PAGE LANGUAGE
------------------------------------------------

local function drawOptionsLanguage(x)

    love.graphics.setColor(0,0,0,1)

    love.graphics.printf(
        Language.get("language"),
        x,
        8,
        120,
        "center"
    )

    love.graphics.printf(
        "English",
        x,
        52,
        120,
        "center"
    )

    love.graphics.printf(
        "Francais",
        x,
        72,
        120,
        "center"
    )

    love.graphics.setColor(1,1,1,1)

    love.graphics.draw(
        ui_btn_arrow,
        x + 5,
        5
    )

    en_language:drawAt(x, 0)
    fr_language:drawAt(x, 0)

end

------------------------------------------------
-- PAGE GRAPHICS
------------------------------------------------

local function drawOptionsGraphics(x)

    love.graphics.setColor(0,0,0,1)

    love.graphics.printf(
        Language.get("graphics"),
        x,
        8,
        120,
        "center"
    )

    love.graphics.print(
        Language.get("show_particles"),
        x + 24,
        52
    )

    love.graphics.print(
        Language.get("show_shadows"),
        x + 24,
        72
    )

    love.graphics.print(
        Language.get("show_frames"),
        x + 24,
        92
    )

    love.graphics.setColor(1,1,1,1)

    check_particles:drawAt(x,0)
    check_shadows:drawAt(x,0)
    check_fps:drawAt(x,0)

    love.graphics.draw(
        ui_btn_arrow,
        x + 5,
        5
    )

end

------------------------------------------------
-- PAGE CREDITS
------------------------------------------------

local function drawOptionsCredits(x)

    love.graphics.setColor(0,0,0,1)

    love.graphics.printf(
        Language.get("credits"),
        x,
        8,
        120,
        "center"
    )

    love.graphics.printf(
        Language.get("thanks_to"),
        x,
        30,
        120,
        "center"
    )

    love.graphics.printf(
        "- Oxiho Sanchez",
        x,
        50,
        120,
        "center"
    )

    love.graphics.printf(
        "- RaffyPVZ",
        x,
        60,
        120,
        "center"
    )

    love.graphics.printf(
        "- SK3",
        x,
        70,
        120,
        "center"
    )

    love.graphics.printf(
        "- Roro",
        x,
        80,
        120,
        "center"
    )

    love.graphics.setColor(1,1,1,1)

    love.graphics.draw(
        ui_btn_arrow,
        x + 5,
        5
    )

end

------------------------------------------------
-- REND UNIQUEMENT LES PAGES VISIBLES
------------------------------------------------

local function drawVisiblePages(baseX)

    local first =
        math.floor(optionsScrollX / PAGE_SCROLL)

    if first < 0 then
        first = 0
    end

    local last =
        math.floor(
            (optionsScrollX + CONTENT_WIDTH - 0.001)
            / PAGE_SCROLL
        )

    if last > PAGE_COUNT - 1 then
        last = PAGE_COUNT - 1
    end

    if IS_3DS then

        love.graphics.push()
        love.graphics.translate(0, 30)
        
    end
    for page = first, last do

        local x =
            baseX +
            page * PAGE_SCROLL -
            optionsScrollX - 90

        if IS_3DS ~= true then 
            x =
                baseX +
                page * PAGE_SCROLL -
                optionsScrollX
        end


        if page == 0 then

            drawOptionsMain(x)

        elseif page == 1 then

            drawOptionsLanguage(x)

        elseif page == 2 then

            drawOptionsGraphics(x)

        elseif page == 3 then

            drawOptionsCredits(x)

        end

    end
    if IS_3DS then

        love.graphics.pop()

    end

end

------------------------------------------------
-- DRAW OPTIONS
------------------------------------------------

local function drawOptions()

    love.graphics.setFont(fnt_noOutline)

    love.graphics.setColor(1,1,1,1)

    ui_panel:draw(
        0,
        0,
        PAGE_WIDTH,
        PAGE_HEIGHT
    )

    love.graphics.rectangle(
        "fill",
        CONTENT_X,
        CONTENT_Y,
        CONTENT_WIDTH,
        CONTENT_HEIGHT
    )

    btn_closeOptions:draw()

    love.graphics.setColor(1,1,1,1)

    love.graphics.printf(
        Language.get("settings"),
        0,
        8,
        PAGE_WIDTH,
        "center"
    )

    ------------------------------------------------
    -- PC
    ------------------------------------------------

    if not IS_3DS then

        love.graphics.setCanvas(ContentCanvas)

        love.graphics.clear(1,1,1,1)

        love.graphics.setScissor(
            0,
            0,
            CONTENT_WIDTH,
            CONTENT_HEIGHT
        )

        drawVisiblePages(0)

        love.graphics.setScissor()

        love.graphics.setCanvas(OptionsCanvas)

        love.graphics.setColor(1,1,1,1)

        love.graphics.draw(
            ContentCanvas,
            CONTENT_X,
            CONTENT_Y
        )
        return

    end

    ------------------------------------------------
    -- 3DS
    ------------------------------------------------

    drawVisiblePages(
        OPTIONS_SCREEN_X + CONTENT_X
    )

end

------------------------------------------------
-- TRANSITION
------------------------------------------------

function drawOptionsTransition()

    ------------------------------------------------
    -- PC
    ------------------------------------------------

    if not IS_3DS then

        love.graphics.setCanvas(OptionsCanvas)

        love.graphics.clear(0,0,0,0)

        drawOptions()

        love.graphics.setCanvas()

        return

    end

    ------------------------------------------------
    -- 3DS
    ------------------------------------------------

    love.graphics.push()

    love.graphics.translate(
        OPTIONS_SCREEN_X,
        OPTIONS_SCREEN_Y
    )

    drawOptions()

    love.graphics.pop()

end

------------------------------------------------
-- INPUT POSITION
------------------------------------------------

local function getOptionsPosition(x,y)

    local vx,vy,screen =
        mouseToVirtual(x,y)

    if screen ~= "bottom" then
        return nil,nil
    end

    local ox =
        vx - OPTIONS_SCREEN_X

    local oy =
        vy - OPTIONS_SCREEN_Y

    if ox < 0 or ox > PAGE_WIDTH then
        return nil,nil
    end

    if oy < 0 or oy > PAGE_HEIGHT then
        return nil,nil
    end

    return ox,oy

end

------------------------------------------------
-- MOUSE PRESSED
------------------------------------------------

function options_menu.mousepressed(x,y,button)

    local ox,oy =
        getOptionsPosition(x,y)

    if not ox then return end

    btn_closeOptions:mousepressed(
        ox,oy,button
    )

    local vx, vy = mouseToVirtual(x, y)

    local px =
        ox - CONTENT_X + optionsScrollX

    local py =
        oy - CONTENT_Y

    if px < 0 or py < 0 then
        return
    end

    local page =
        math.floor(px / PAGE_SCROLL)

    local lx =
        px - page * PAGE_SCROLL

    if page == 0 then

        btn_language:mousepressed(lx,py,button)
        btn_graphics:mousepressed(lx,py,button)
        btn_credits:mousepressed(lx,py,button)

    elseif page == 1 then

        en_language:mousepressed(lx,py,button)
        fr_language:mousepressed(lx,py,button)
        btn_back_language:mousepressed(lx,py,button)

    elseif page == 2 then

        btn_back_graphics:mousepressed(lx,py,button)

        check_particles:mousepressed(lx,py,button)
        check_shadows:mousepressed(lx,py,button)
        check_fps:mousepressed(lx,py,button)

    elseif page == 3 then

        btn_back_credits:mousepressed(lx,py,button)

    end

end

------------------------------------------------
-- MOUSE RELEASED
------------------------------------------------

function options_menu.mousereleased(x,y,button)

    local ox,oy =
        getOptionsPosition(x,y)

    if not ox then return end

    btn_closeOptions:mousereleased(
        ox,oy,button
    )

    local px =
        ox - CONTENT_X + optionsScrollX

    local py =
        oy - CONTENT_Y

    local page =
        math.floor(px / PAGE_SCROLL)

    local lx =
        px - page * PAGE_SCROLL

    if page == 0 then

        btn_language:mousereleased(lx,py,button)
        btn_graphics:mousereleased(lx,py,button)
        btn_credits:mousereleased(lx,py,button)

    elseif page == 1 then

        en_language:mousereleased(lx,py,button)
        fr_language:mousereleased(lx,py,button)
        btn_back_language:mousereleased(lx,py,button)

    elseif page == 2 then

        btn_back_graphics:mousereleased(lx,py,button)

        check_particles:mousereleased(lx,py,button)
        check_shadows:mousereleased(lx,py,button)
        check_fps:mousereleased(lx,py,button)

    elseif page == 3 then

        btn_back_credits:mousereleased(lx,py,button)

    end

end

------------------------------------------------
-- TOUCH
------------------------------------------------
function options_menu.move(x)

    local vx, vy = mouseToVirtual(x, 0)

end

function options_menu.touchpressed(id,x,y)

    local ox =
        x - OPTIONS_SCREEN_X

    local oy =
        y - OPTIONS_SCREEN_Y

    if ox < 0 or oy < 0 then
        return
    end

    btn_closeOptions:touchpressed(id,ox,oy)

    local px =
        ox - CONTENT_X + optionsScrollX

    local py =
        oy - CONTENT_Y

    local page =
        math.floor(px / PAGE_SCROLL)

    local lx =
        px - page * PAGE_SCROLL

    if page == 0 then

        btn_language:touchpressed(id,lx,py)
        btn_graphics:touchpressed(id,lx,py)
        btn_credits:touchpressed(id,lx,py)

    elseif page == 1 then

        en_language:touchpressed(id,lx,py)
        fr_language:touchpressed(id,lx,py)
        btn_back_language:touchpressed(id,lx,py)

    elseif page == 2 then

        btn_back_graphics:touchpressed(id,lx,py)

        check_particles:touchpressed(id,lx,py)
        check_shadows:touchpressed(id,lx,py)
        check_fps:touchpressed(id,lx,py)

    elseif page == 3 then

        btn_back_credits:touchpressed(id,lx,py)

    end

end

function options_menu.touchreleased(id,x,y)

    local ox =
        x - OPTIONS_SCREEN_X

    local oy =
        y - OPTIONS_SCREEN_Y

    btn_closeOptions:touchreleased(id,ox,oy)

    local px =
        ox - CONTENT_X + optionsScrollX

    local py =
        oy - CONTENT_Y

    local page =
        math.floor(px / PAGE_SCROLL)

    local lx =
        px - page * PAGE_SCROLL

    if page == 0 then

        btn_language:touchreleased(id,lx,py)
        btn_graphics:touchreleased(id,lx,py)
        btn_credits:touchreleased(id,lx,py)

    elseif page == 1 then

        en_language:touchreleased(id,lx,py)
        fr_language:touchreleased(id,lx,py)
        btn_back_language:touchreleased(id,lx,py)

    elseif page == 2 then

        btn_back_graphics:touchreleased(id,lx,py)

        check_particles:touchreleased(id,lx,py)
        check_shadows:touchreleased(id,lx,py)
        check_fps:touchreleased(id,lx,py)

    elseif page == 3 then

        btn_back_credits:touchreleased(id,lx,py)

    end

end

------------------------------------------------
-- GETTERS
------------------------------------------------

function options_menu.getCanvas()
    return OptionsCanvas
end

return options_menu