--------------------------------------------------
-- CONFIGURATION GLOBALE DU JEU
--------------------------------------------------

sfx_volume = 1
music_volume = 1

loading = false

touchedSeed = 0

speedscale = 1
is_paused = false

--------------------------------------------------
-- INPUT UTILISATEUR
--------------------------------------------------

current_username = "UserDave"

function love.textinput(text)
    current_username = text
end

function inputUsername()
    love.keyboard.setTextInput(true, {
        type = "basic",
        password = false,
        hint = "Username / Pseudonyme",
        length = 20
    })
end

-- Ordre des niveaux (fichiers de Levels/). Modifie cette liste pour
-- changer l'enchaînement.
levelOrder = { "tutorial1", "tutorial2", "tutorial3", "tutorial4" }
currentLevelIndex = 1

-- true entre le clic sur "niveau suivant" et le moment où la fleur
-- Marigold recouvre l'écran (c'est là qu'on charge le nouveau niveau).
levelTransitionPending = false

-- Retour au menu avec un chargement très court (fleur Marigold) :
--  * menuTransitionPending : la fleur grossit, on n'a pas encore quitté la scène
--  * menuTransitionActive  : le menu est affiché, la fleur disparaît
menuTransitionPending = false
menuTransitionActive = false

function getCurrentLevelName()
    return levelOrder[currentLevelIndex]
end

IS_3DS = false

if love._console == "3DS" then
    IS_3DS = true
end

function getUsername()

    return current_username

end

--------------------------------------------------
-- RÉSOLUTIONS
--------------------------------------------------
local fps

local TOP_WIDTH = 400
local TOP_HEIGHT = 240

local BOTTOM_WIDTH = 320
local BOTTOM_HEIGHT = 240


-- Taille virtuelle totale sur PC
--
-- TOP    : 400x240
-- BOTTOM : 320x240 centré
--
-- Total  : 400x480

local VIRTUAL_WIDTH = 400
local VIRTUAL_HEIGHT = 480


--------------------------------------------------
-- SCALE PC
--------------------------------------------------

scale = 1
local offsetX = 0
local offsetY = 0


--------------------------------------------------
-- UI
--------------------------------------------------

local ui_btn_menu_play
local ui_btn_menu_options

ui_panel = nil

--------------------------------------------------
-- CANVAS
--------------------------------------------------

local topCanvas
local bottomCanvas


--------------------------------------------------
-- SPRITES
--------------------------------------------------

loadingBG = nil

local spr_startup_eaLogo
local spr_startup_popcapLogo
local spr_startup_catLogo

local spr_menu_background

local spr_menu_background_top

local spr_menu_logo


----------------------------------------------
-- AUDIO
----------------------------------------------

local sfx_play_button_pressed
local sfx_play_button_released

sfx_options_button_pressed = nil
sfx_options_button_released = nil

-- Music

local mus_title

--------------------------------------------------
-- FONTS
--------------------------------------------------

fnt_noOutline = nil


--------------------------------------------------
-- AUTRES LUA
--------------------------------------------------

Resources = require("resources")

local Carousel = require("carousel")
local NinePatchButton = require("ninepatchbutton")
local NinePatch = require("ninepatch")
local options = require("options")

local MarigoldLoader = require("marigoldloader")
local LoadSequence = require("loadsequence")
Language = require("languageManager")

local Scene = require("scene")


--------------------------------------------------
-- VARIABLES
--------------------------------------------------
mouse_x = 0
mouse_y = 0

menuState = 1

local carousel

state = 0
local fade_alpha

local marigoldLoadInstance

--------------------------------------------------
-- CHARGEMENT DU NIVEAU EN PLUSIEURS ETAPES
--------------------------------------------------
-- Voir loadsequence.lua. La fleur Marigold attend la fin du chargement
-- (waitForLoad) avant de lancer son animation de sortie.

local function startLevelLoading()

    marigoldLoadInstance.waitForLoad = true

    LoadSequence.start({
        levelName = getCurrentLevelName(),

        unload = function()
            Scene.unload()
        end,

        loadScene = function()
            Scene.load("gameplay", true)
        end,

        onFinished = function()
            marigoldLoadInstance.waitForLoad = false
        end
    })

end

local icon_options

--------------------------------------------------
-- UPDATE DU SCALE PC
--------------------------------------------------

local function updateScale()

    if IS_3DS then
        scale = 1
        offsetX = 0
        offsetY = 0
        return
    end


    local windowW = love.graphics.getWidth()
    local windowH = love.graphics.getHeight()

    ------------------------------------------------
    -- On veut uniquement des scales entiers
    ------------------------------------------------

    local scaleX =
        math.floor(windowW / VIRTUAL_WIDTH)

    local scaleY =
        math.floor(windowH / VIRTUAL_HEIGHT)


    scale = math.min(
        scaleX,
        scaleY
    )


    ------------------------------------------------
    -- Évite scale = 0
    ------------------------------------------------

    if scale < 1 then
        scale = 1
    end


    ------------------------------------------------
    -- Taille réelle utilisée
    ------------------------------------------------

    local renderedWidth =
        VIRTUAL_WIDTH * scale

    local renderedHeight =
        VIRTUAL_HEIGHT * scale


    ------------------------------------------------
    -- Centrage dans la fenêtre
    ------------------------------------------------

    offsetX =
        math.floor(
            (windowW - renderedWidth) / 2
        )

    offsetY =
        math.floor(
            (windowH - renderedHeight) / 2
        )

end


--------------------------------------------------
-- CONVERSION SOURIS PC
--
-- Retourne :
--
-- x        = coordonnée virtuelle
-- y        = coordonnée virtuelle
-- screen   = "top" ou "bottom"
--
--------------------------------------------------

function mouseToVirtual(x, y)

    if IS_3DS then
        return x, y, "bottom"
    end


    ------------------------------------------------
    -- Passage fenêtre -> espace virtuel
    ------------------------------------------------

    local vx =
        (x - offsetX) / scale

    local vy =
        (y - offsetY) / scale


    ------------------------------------------------
    -- Écran du haut
    ------------------------------------------------

    if vy >= 0
    and vy < TOP_HEIGHT
    and vx >= 0
    and vx < TOP_WIDTH then

        return vx, vy, "top"

    end


    ------------------------------------------------
    -- Écran du bas
    --
    -- Le bas commence à y = 240
    -- et est décalé de 40 px vers la droite.
    ------------------------------------------------

    local bottomX =
        vx - 40

    local bottomY =
        vy - TOP_HEIGHT


    if bottomX >= 0
    and bottomX < BOTTOM_WIDTH
    and bottomY >= 0
    and bottomY < BOTTOM_HEIGHT then

        return bottomX, bottomY, "bottom"

    end


    ------------------------------------------------
    -- En dehors des deux écrans
    ------------------------------------------------

    return vx, vy, nil

end


--------------------------------------------------
-- CHARGEMENT
--------------------------------------------------

function love.load()

    loadingBG = love.graphics.newImage("Sprites/BG/LoadingBG.png")

    icon_options = love.graphics.newImage("Sprites/UI/Menu/Buttons/OptionsIcon.png")

    local face = love.graphics.newImage("Sprites/UI/Loading/Face.png")
    local petal = love.graphics.newImage("Sprites/UI/Loading/Petal.png")

    marigoldLoadInstance = MarigoldLoader:new(
        face,
        petal,
        160,
        120
    ) 

    ------------------------------------------------
    -- Pixel art
    ------------------------------------------------

    love.graphics.setDefaultFilter(
        "nearest",
        "nearest"
    )

    ------------------------------------------------
    -- Scale initial
    ------------------------------------------------

    updateScale()


    ------------------------------------------------
    -- Carousel
    ------------------------------------------------

    local images = {

        love.graphics.newImage(
            "Sprites/UI/Menu/Carousel1.png"
        ),

        love.graphics.newImage(
            "Sprites/UI/Menu/Carousel2.png"
        )

    }


    carousel = Carousel:new(images)

    ------------------------------------------------
    -- ÉCRANS PC
    ------------------------------------------------

    if not IS_3DS then

        topCanvas =
            love.graphics.newCanvas(
                TOP_WIDTH,
                TOP_HEIGHT
            )


        bottomCanvas =
            love.graphics.newCanvas(
                BOTTOM_WIDTH,
                BOTTOM_HEIGHT
            )


        fnt_noOutline =
            love.graphics.newFont(
                "Fonts/pixel.ttf",
                5
            )

    else

        fnt_noOutline =
            love.graphics.newFont(
                "Fonts/pixel.ttf",
                10
            )

    end

    ------------------------------------------------
    -- SFX AUDIO
    ------------------------------------------------

    sfx_play_button_pressed = love.audio.newSource("Audio/SFX/Buttons/PlayPress.ogg", "static")
    sfx_play_button_released = love.audio.newSource("Audio/SFX/Buttons/PlayRelease.ogg", "static")

    sfx_options_button_pressed = love.audio.newSource("Audio/SFX/Buttons/OptionsPress.ogg", "static")
    sfx_options_button_released = love.audio.newSource("Audio/SFX/Buttons/OptionsRelease.ogg", "static")

    mus_title = love.audio.newSource("Audio/Music/Title.ogg", "stream")

    ------------------------------------------------
    -- BOUTONS
    ------------------------------------------------
    
    ui_btn_menu_play =
        NinePatchButton:new(
            136,
            200,
            48,
            24,

            "Sprites/UI/Menu/Buttons/Purple.png",

            "Sprites/UI/Menu/Buttons/PurplePressed.png",

            8,

            sfx_play_button_pressed,

            sfx_play_button_released
        )

    ui_btn_menu_options =
        NinePatchButton:new(
            278,
            200,
            32,
            24,

            "Sprites/UI/Menu/Buttons/Orange.png",

            "Sprites/UI/Menu/Buttons/OrangePressed.png",

            8,

            sfx_options_button_pressed,

            sfx_options_button_released
        )

    ui_panel =  NinePatch:new("Sprites/UI/Menu/Panels/WoodPanel.png", 8)

    ui_btn_menu_play:setOnClick(function()

        print("PLAY")

        menuState = 3
        loading = true
        marigoldLoadInstance:play()
        mus_title:stop()

        currentLevelIndex = 1
        levelTransitionPending = false

        startLevelLoading()

    end)

    ui_btn_menu_options:setOnClick(function()

        print("Options button clicked !")
        menuState = 2

    end)
    ------------------------------------------------
    -- IMAGES
    ------------------------------------------------

    options_menu:load()

    spr_menu_logo = 
        love.graphics.newImage(
            "Sprites/UI/Menu/logo.png"
        )

    spr_startup_eaLogo =
        love.graphics.newImage(
            "Sprites/UI/StartupScreen/EA.png"
        )


    spr_startup_popcapLogo =
        love.graphics.newImage(
            "Sprites/UI/StartupScreen/Popcap.png"
        )


    spr_startup_catLogo =
        love.graphics.newImage(
            "Sprites/UI/StartupScreen/SupercatProduction.png"
        )


    spr_menu_background =
        love.graphics.newImage(
            "Sprites/UI/Menu/Background.png"
        )

    spr_menu_background_top =
        love.graphics.newImage(
            "Sprites/UI/Menu/BackgroundTop.png"
        )

    ------------------------------------------------
    -- ÉTAT
    ------------------------------------------------

    state = 1

    -- 1 = EA / PopCap apparaît
    -- 2 = EA / PopCap disparaît
    -- 3 = SuperCat apparaît
    -- 4 = SuperCat disparaît
    -- 5 = Menu
    -- 6 = Transition tutoriel
    -- 7 = Niveau

    fade_alpha = 0

end


--------------------------------------------------
-- ÉCRAN DU HAUT
--------------------------------------------------

local function drawTopScreen()

    love.graphics.clear()
    if state == 8 then

        Scene.draw("top")

    elseif state == 7 then

        Scene.draw("top")

    elseif state == 5 then

        drawMenu(
            "Top",
            fade_alpha
        )

    elseif state <= 4 then

        drawFadeLogos(
            "Top",
            fade_alpha,
            state
        )

    end

    if menuState == 3 then

        marigoldLoadInstance:draw(true)

        -- Texte de l'étape de chargement (en haut)
        local loadingText = LoadSequence.getText()

        if loadingText and marigoldLoadInstance.globalScale > 0.05 then

            love.graphics.setFont(fnt_noOutline)

            -- ombre
            love.graphics.setColor(0, 0, 0, 1)
            love.graphics.printf(loadingText, 1, 21, TOP_WIDTH, "center")

            love.graphics.setColor(1, 1, 1, 1)
            love.graphics.printf(loadingText, 0, 20, TOP_WIDTH, "center")

            -- Asset en cours de chargement
            local assetText = LoadSequence.getAssetText()

            if assetText then
                love.graphics.setColor(0, 0, 0, 1)
                love.graphics.printf(assetText, 1, 41, TOP_WIDTH, "center")

                love.graphics.setColor(1, 1, 1, 1)
                love.graphics.printf(assetText, 0, 40, TOP_WIDTH, "center")
            end

        end

    end
    if show_fps == true then
        love.graphics.printf(
            math.floor(fps + 0.5),
            0,
            0,
            320,
            "left"
        )
    end

end


--------------------------------------------------
-- ÉCRAN DU BAS
--------------------------------------------------

local function drawBottomScreen()

    love.graphics.clear()

    ------------------------------------------------
    -- MENU NORMAL
    ------------------------------------------------
    if state == 8 then

        Scene.draw("bottom")

    elseif state == 7 then

        Scene.draw("bottom")

    elseif state == 5 then

        drawMenu(
            "Bottom",
            fade_alpha
        )

    elseif state <= 4 then

        drawFadeLogos(
            "Bottom",
            fade_alpha,
            state
        )

    end

    ------------------------------------------------
    -- OPTIONS
    ------------------------------------------------

    if menuState == 2 then

        drawOptionsTransition()

        if not IS_3DS then
            love.graphics.setCanvas(bottomCanvas)
            love.graphics.draw(
                options.getCanvas(),
                90,
                40
            )
            love.graphics.setCanvas()
        end

    end
    ------------------------------------------------
    -- MARIGOLD
    ------------------------------------------------

    if menuState == 3 then

        if state == 8
        and (levelTransitionPending or menuTransitionPending) then

            -- Écran de récompense : le panneau reste visible par-dessus le
            -- fond de la fleur pendant le fade, puis s'efface juste avant
            -- que la fleur recouvre tout.
            marigoldLoadInstance:draw(false, function()

                local scene = Scene.get()

                if scene and scene.drawUI then

                    local t = math.min(
                        marigoldLoadInstance.globalTimer
                        / marigoldLoadInstance.globalDuration,
                        1
                    )

                    local a = 1 - math.max(0, (t - 0.6) / 0.4)

                    scene.drawUI(a)

                end

            end)

        else

            marigoldLoadInstance:draw(false)

        end

    end

end

--------------------------------------------------
-- UPDATE PRINCIPAL
--------------------------------------------------

function love.update(dt)

    fps = 1 / dt

    options_menu.update(dt)
    
    -- Chargement par étapes (une petite portion par frame)
    LoadSequence.update()

    if menuState == 3 then
        -- Après un chargement lourd dt peut être énorme : on le limite
        -- pour que la fleur ne "saute" pas.
        marigoldLoadInstance:update(math.min(dt, 1 / 30))
    end

    -- Transition entre deux niveaux : dès que la fleur recouvre l'écran,
    -- on décharge la récompense et on charge le niveau suivant.
    -- state = 9 : rien n'est dessiné/mis à jour sous le loader. C'est le
    -- loader qui repasse state à 7 quand il commence à disparaître.
    if levelTransitionPending
    and marigoldLoadInstance.globalTimer >= marigoldLoadInstance.globalDuration then

        levelTransitionPending = false
        state = 9

        startLevelLoading()

    end

    -- Retour au menu : dès que la fleur recouvre l'écran, on quitte la scène
    -- et on affiche le menu. La fleur disparaît ensuite et révèle le menu.
    if menuTransitionPending
    and marigoldLoadInstance.globalTimer >= marigoldLoadInstance.globalDuration then

        finishBackToMenu()

    end

    if menuTransitionActive and marigoldLoadInstance.finished then

        menuTransitionActive = false
        menuState = 1
        loading = false

    end

    updateStates()


    if state == 1
    or state == 3
    or state == 5 then

        updateFade(
            1,
            dt
        )


        if state == 5 then

            carousel:update(dt)


            ------------------------------------------------
            -- Souris
            ------------------------------------------------

            if not IS_3DS then

                local mx, my =
                    love.mouse.getPosition()


                local vx, vy, screen =
                    mouseToVirtual(mx, my)


                if screen == "bottom" then

                    ui_btn_menu_play:update(
                        dt,
                        vx,
                        vy
                    )

                else

                    ui_btn_menu_play:update(
                        dt,
                        -9999,
                        -9999
                    )

                end

            end

        end


    elseif state == 2
    or state == 4 then

        updateFade(
            2,
            dt
        )

    end
    
    if state == 7 and is_paused == false then

        Scene.update(dt * speedscale)

    end

    if state == 8 then

        Scene.update(dt)

    end

end


--------------------------------------------------
-- DRAW PRINCIPAL
--------------------------------------------------

function love.draw(screen)

    --------------------------------------------------
    -- 3DS
    --------------------------------------------------

    if IS_3DS then

        if screen == "bottom" then

            drawBottomScreen()

        else

            drawTopScreen()

        end

        return

    end


    --------------------------------------------------
    -- PC
    --------------------------------------------------

    --------------------------------------------------
    -- CANVAS TOP
    --------------------------------------------------

    love.graphics.setCanvas(
        topCanvas
    )

    drawTopScreen()

    love.graphics.setCanvas()


    --------------------------------------------------
    -- CANVAS BOTTOM
    --------------------------------------------------

    love.graphics.setCanvas(
        bottomCanvas
    )

    drawBottomScreen()

    love.graphics.setCanvas()


    --------------------------------------------------
    -- AFFICHAGE PC
    --------------------------------------------------

    love.graphics.push()


    love.graphics.translate(
        offsetX,
        offsetY
    )


    love.graphics.scale(
        scale,
        scale
    )


    --------------------------------------------------
    -- TOP
    --------------------------------------------------

    love.graphics.draw(
        topCanvas,
        0,
        0
    )


    --------------------------------------------------
    -- BOTTOM
    --
    -- Centré sous le TOP :
    --
    -- (400 - 320) / 2 = 40
    --------------------------------------------------

    love.graphics.draw(
        bottomCanvas,
        40,
        TOP_HEIGHT
    )

    love.graphics.pop()

end


--------------------------------------------------
-- RESIZE
--------------------------------------------------

function love.resize(w, h)

    updateScale()

end


--------------------------------------------------
-- ÉTATS
--------------------------------------------------

function updateStates()

    if state == 1
    and fade_alpha >= 3 then

        state = 2
        fade_alpha = 1


    elseif state == 2
    and fade_alpha <= 0 then

        state = 3

        fade_alpha = 0

        mus_title:stop()
        mus_title:play()

    elseif state == 3
    and fade_alpha >= 3 then

        state = 4
        fade_alpha = 1


    elseif state == 4
    and fade_alpha <= 0 then

        state = 5
        fade_alpha = 0

    end

end


--------------------------------------------------
-- FADE
--------------------------------------------------

function updateFade(fadeid, delta)

    if fadeid == 1 then

        fade_alpha =
            fade_alpha +
            delta * 2

    elseif fadeid >= 2 then

        fade_alpha =
            fade_alpha -
            delta * 2

    end

end


--------------------------------------------------
-- LOGOS
--------------------------------------------------

function drawFadeLogos(
    screen,
    alpha,
    currentState
)

    love.graphics.setColor(
        1,
        1,
        1,
        alpha
    )


    if currentState == 1
    or currentState == 2 then

        if screen == "Bottom" then

            love.graphics.draw(
                spr_startup_eaLogo,
                160,
                120,
                0,
                1,
                1,
                64,
                64
            )

        else

            love.graphics.draw(
                spr_startup_popcapLogo,
                200,
                120,
                0,
                1,
                1,
                128,
                64
            )

        end


    elseif currentState == 3
    or currentState == 4 then

        if screen == "Bottom" then

            love.graphics.draw(
                spr_startup_catLogo,
                160,
                120,
                0,
                1,
                1,
                128,
                32
            )

        end

    end


    love.graphics.setColor(
        1,
        1,
        1,
        1
    )

end


--------------------------------------------------
-- MENU
--------------------------------------------------

function drawMenu(screen, fade)

    love.graphics.setColor(
        fade,
        fade,
        fade,
        1
    )


    love.graphics.setFont(
        fnt_noOutline
    )


    ------------------------------------------------
    -- BOTTOM
    ------------------------------------------------

    if screen == "Bottom" then

        love.graphics.draw(
            spr_menu_background,
            160,
            120,
            0,
            1,
            1,
            200,
            120
        )
        
        love.graphics.draw(
            spr_menu_logo,
            160,
            18,
            0,
            1,
            1,
            80,
            16
        )

        carousel:draw()

        ui_btn_menu_play:draw()

        ui_btn_menu_options:draw()
        love.graphics.draw(icon_options, 279, 199)


        love.graphics.printf(
            Language.get("play"),
            0,
            206,
            320,
            "center"
        )


    ------------------------------------------------
    -- TOP
    ------------------------------------------------

    else

        love.graphics.draw(
            spr_menu_background_top,
            200,
            120,
            0,
            1,
            1,
            200,
            120
        )

    end


    love.graphics.setColor(
        1,
        1,
        1,
        1
    )

end


--------------------------------------------------
-- SOURIS : PRESS
--------------------------------------------------

function love.mousepressed(x, y, button)

    

    if button ~= 1 then
        return
    end

    ------------------------------------------------
    -- OPTIONS
    ------------------------------------------------

    if menuState == 2 then

        options.mousepressed(
            x,
            y,
            button
        )

        return
    end

    ------------------------------------------------
    -- MENU PRINCIPAL
    ------------------------------------------------

    local vx, vy, screen =
        mouseToVirtual(x, y)

    if screen ~= "bottom" then
        return
    end

    carousel:pressed(vx)

    if state == 5 then
        
        if loading == false then

            ui_btn_menu_play:mousepressed(
                vx,
                vy,
                button
            )

            ui_btn_menu_options:mousepressed(
                vx,
                vy,
                button
            )

        end

    end

    if state == 7 then
        if is_paused == false then
            gpmousepressed(vx, vy, button)
            for _, s in ipairs(sunsInstances) do
                if s:tryCollect(vx, vy) then
                    -- ajoute des soleil au joueur
                    suns = suns + 50
                end
            end

            touchedSeed = checkTouchedSeed(math.floor((vx - 23) / 37), vx, vy)
        else
            pauseButton:mousepressed(vx,vy,button)
            ui_btn_pause_resume:mousepressed(vx,vy,button)
            ui_btn_pause_quit:mousepressed(vx,vy,button)
        end
    end
    if state == 8 and not levelTransitionPending and not menuTransitionPending then

        rewardPressed(vx, vy)

    end

end


--------------------------------------------------
-- SOURIS : MOVE
--------------------------------------------------

function love.mousemoved(x, y)

    local vx, vy, screen =
        mouseToVirtual(x, y) 

    options_menu.move(x, 45)
    

    if menuState == 2 then
        return
    end

    if screen == "bottom" then
        carousel:moved(vx)
    end

    mouse_x, mouse_y = mouseToVirtual(x, y)

    if state == 7 then
        if is_paused == false then
            for _, s in ipairs(sunsInstances) do
                if s:tryCollect(vx, vy) then
                    -- ajoute 25 soleil au joueur
                    suns = suns + 50
                end
            end
        end
    end

end


function love.mousereleased(x, y, button)

    

    if button ~= 1 then
        return
    end

    ------------------------------------------------
    -- OPTIONS
    ------------------------------------------------

    if menuState == 2 then

        options.mousereleased(
            x,
            y,
            button
        )

        return
    end


    ------------------------------------------------
    -- MENU PRINCIPAL
    ------------------------------------------------

    local vx, vy, screen =
        mouseToVirtual(x, y)

    if screen == "bottom" then

        carousel:released()

    end

    if state == 5 then

        if loading == false then


            carousel:released(vx)

            ui_btn_menu_play:mousereleased(
                vx,
                vy,
                button
            )

            ui_btn_menu_options:mousereleased(
                vx,
                vy,
                button
            )

        end

    elseif state == 7 then
        if is_paused == false then        
            PlacePlant()
            gpmousereleased(vx, vy, button)
        else
            pauseButton:mousereleased(vx,vy,button)
            ui_btn_pause_resume:mousereleased(vx,vy,button)
            ui_btn_pause_quit:mousereleased(vx,vy,button)
        end
    end
    if state == 8 and not levelTransitionPending and not menuTransitionPending then

        rewardReleased(vx, vy)

    end

end


--------------------------------------------------
-- TOUCH PRESS
--
-- Sur 3DS, les coordonnées sont déjà
-- celles de l'écran tactile 320x240.
--------------------------------------------------

function love.touchpressed(id, x, y)
    
    if state == 8 and not levelTransitionPending and not menuTransitionPending then

        rewardPressed(x, y)

    end

    if state == 7 then
        if is_paused == false then
            gptouchpressed(id, x, y)
        end
    end

    if not IS_3DS then
        return
    end

    if menuState == 2 then

        options.touchpressed(
            id,
            x,
            y
        )

        return
    end


    ------------------------------------------------
    -- Carousel
    ------------------------------------------------

    carousel:touchpressed(
        id,
        x,
        y
    )


    ------------------------------------------------
    -- Bouton
    ------------------------------------------------
    if menuState == 1 then

        if loading == false then

            ui_btn_menu_play:touchpressed(
                id,
                x,
                y
            )

            ui_btn_menu_options:touchpressed(
                id,
                x,
                y
            )

        end

    elseif state == 7 then
        if is_paused == false then
            gptouchpressed(id, x, y)
            for _, s in ipairs(sunsInstances) do
                if s:tryCollect(x, y) then
                    -- ajoute des soleil au joueur
                    suns = suns + 50
                end
            end

            touchedSeed = checkTouchedSeed(math.floor((x - 23) / 37), x, y)
        else
            pauseButton:touchpressed(id,x,y)
            ui_btn_pause_resume:touchpressed(id,x,y)
            ui_btn_pause_quit:touchpressed(id,x,y)
        end

    end

end


--------------------------------------------------
-- TOUCH MOVE
--------------------------------------------------

function love.touchmoved(
    id,
    x,
    y
)

    mouse_x, mouse_y = mouseToVirtual(x, y)

    options_menu.move(x, y)

    if not IS_3DS then
        return
    end


    carousel:touchmoved(
        id,
        x,
        y
    )

    if state == 7 then
        if is_paused == false then
            for _, s in ipairs(sunsInstances) do
                if s:tryCollect(x, y) then
                    -- ajoute des soleil au joueur
                    suns = suns + 50
                end
            end
        end

    end
    
end


--------------------------------------------------
-- TOUCH RELEASE
--------------------------------------------------

function love.touchreleased(
    id,
    x,
    y
)

    if not IS_3DS then
        return
    end

    if menuState == 2 then

        options.touchreleased(
            id,
            x,
            y
        )

        return
    end


    carousel:touchreleased(
        id,
        x,
        y
    )

    if menuState == 1 then

        ui_btn_menu_play:touchreleased(
            id,
            x,
            y
        )

        ui_btn_menu_options:touchreleased(
            id,
            x,
            y
        )

    end
    if state == 8 and not levelTransitionPending and not menuTransitionPending then

        rewardReleased(x, y)

    end
    if state == 7 then
        if is_paused == false then
            gptouchreleased(id, x, y)
            PlacePlant()
        else
            pauseButton:touchreleased(id,x,y)
            ui_btn_pause_resume:touchreleased(id, x, y)
            ui_btn_pause_quit:touchreleased(id, x, y)
        end
    end

end

function newAnimation(image, width, height, duration)
    local animation = {}
    animation.spriteSheet = image;
    animation.quads = {};

    for y = 0, image:getHeight() - height, height do
        for x = 0, image:getWidth() - width, width do
            table.insert(animation.quads, love.graphics.newQuad(x, y, width, height, image:getDimensions()))
        end
    end

    return animation
end

function ChangeVolume(var, volume)
    var = volume
end

-- Lance le retour au menu : petit chargement avec la fleur Marigold.
-- Le vrai changement d'écran se fait dans finishBackToMenu(), quand la fleur
-- recouvre l'écran.
function backToMenu()

    if menuTransitionPending then
        return
    end

    levelTransitionPending = false
    menuTransitionPending = true
    menuTransitionActive = false

    loading = true
    menuState = 3

    LoadSequence.cancel()
    marigoldLoadInstance.waitForLoad = false

    marigoldLoadInstance:play(true)

    -- Le loader repasse state à 5 en commençant à disparaître
    marigoldLoadInstance.exitState = 5

end

function finishBackToMenu()

    menuTransitionPending = false
    menuTransitionActive = true

    is_paused = false
    is_speedup = false
    speedscale = 1

    Scene.unload()

    state = 5

end

-- Appelée par le bouton "niveau suivant" de l'écran de récompense.
function goToNextLevel()

    if levelTransitionPending then
        return
    end

    -- Plus de niveau : retour au menu
    if currentLevelIndex >= #levelOrder then
        backToMenu()
        return
    end

    currentLevelIndex = currentLevelIndex + 1

    levelTransitionPending = true
    loading = true
    menuState = 3

    marigoldLoadInstance:play()

end

function rewardScreen()

    is_paused = false
    is_speedup = false
    speedscale = 1
    menuState = 1

    Scene.unload()

    state = 8

    Scene.load("reward")
end