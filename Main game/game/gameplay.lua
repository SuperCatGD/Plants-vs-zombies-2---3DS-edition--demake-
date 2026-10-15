local shovel = Resources.image("Sprites/UI/HUD/Shovel.png")
local shovelUI = Resources.image("Sprites/UI/HUD/ShovelButton.png")
local shovelUIHover = Resources.image("Sprites/UI/HUD/ShovelButtonHover.png")
local presentationZombiesClass = require("presentationzombies")
local speedOpacity = 0
local speedEffect = 0


zombiesInstancesPres = {}

local LevelSystem = require("levelsystem")

local function loadLevel(name)
    local levelData = require("Levels." .. name)
    lines = levelData.lines

    suns = levelData.suns

    seeds = levelData.seeds
    lawnType = levelData.lawn
    musicType = levelData.music

    rollingsod = levelData.animationline

    plantfoodLevel = levelData.plantfood
    local znumber = levelData.zombiespres
    for i, z in ipairs(znumber) do
        presentationZombiesClass:new(z, math.random(460, 520), 60 + i * 110 / #znumber)
    end
    return LevelSystem:new(levelData)
end

local level = loadLevel(getCurrentLevelName())

local mus_playerhouse = nil
local mus_playerhouseReward = nil
local mus_playerhouseLose = nil

if musicType == 1 then

    mus_playerhouse = Resources.music("Audio/Music/FrontYard.ogg")
    mus_playerhouseReward = Resources.music("Audio/Music/FrontYardReward.ogg")
    mus_playerhouseLose = Resources.music("Audio/Music/FrontYardLose.ogg")

elseif musicType == 2 then

    mus_playerhouse = Resources.music("Audio/Music/AEfirstWave.ogg")
    mus_playerhouseReward = Resources.music("Audio/Music/AEreward.ogg")
    mus_playerhouseLose = Resources.music("Audio/Music/FrontYardLose.ogg")

end

local holdingShovel = false

local holdingPF = false

local haslevelPF = plantfoodLevel
    
local hotSauce = Resources.image("Sprites/Other/HotSauce.png")

local alpha = 0

local plantfoodUI = Resources.image("Sprites/UI/HUD/PlantFoodPanel3.png")
local plantfoodLeaf = Resources.image("Sprites/UI/HUD/PlantFoodLeaf.png")
local plantfoodDot = Resources.image("Sprites/UI/HUD/PlantFoodUnit.png")

local temp = 0
local tutorialMessagesID = 1

local sfx_remove = Resources.sfx("Audio/SFX/Shovel.ogg")
local sfx_shovel = Resources.sfx("Audio/SFX/PickShovel.ogg")

local sfx_speedup = Resources.sfx("Audio/SFX/Faster.ogg")
local sfx_speeddown = Resources.sfx("Audio/SFX/Slower.ogg")
local sfx_pause = Resources.sfx("Audio/SFX/Pause.ogg")

local NinePatchButton = require("ninepatchbutton")
local NinePatch = require("ninepatch")
local Lawnmower = require("lawnmower")

ui_btn_pause_quit =
    NinePatchButton:new(
        68,
        175,
        72,
        24,
        "Sprites/UI/Menu/Buttons/Orange.png",

        "Sprites/UI/Menu/Buttons/OrangePressed.png",

        8,

        sfx_options_button_pressed,

        sfx_options_button_released
    )

ui_btn_pause_resume =
    NinePatchButton:new(
        172,
        175,
        72,
        24,
        "Sprites/UI/Menu/Buttons/Purple.png",

        "Sprites/UI/Menu/Buttons/PurplePressed.png",

        8,

        sfx_options_button_pressed,

        sfx_options_button_released
    )

local pause_panel = NinePatch:new("Sprites/UI/Menu/Panels/WoodPanel.png", 8)

-- Etat de l'annonce des grosses vagues.
hugeWaveTimer = 0
hugeWaveWaitTimer = 0
hugeWaveActive = false
hugeWaveIsFinal = false

local hugeWaveSound = Resources.sfx("Audio/SFX/HugeWave.ogg")
local finalWaveSound = Resources.sfx("Audio/SFX/Finalwave.ogg")

local selector = Resources.image("Sprites/Plants/Seeds/Selector.png")

peashooterAnim = newAnimation(Resources.image("Sprites/Plants/PlayerHouse/Peashooter.png"), 36, 36)
sunflowerAnim = newAnimation(Resources.image("Sprites/Plants/PlayerHouse/Sunflower.png"), 31, 35)
wallnutAnim = newAnimation(Resources.image("Sprites/Plants/PlayerHouse/WallNut.png"), 24, 30)
potatomineAnim = newAnimation(Resources.image("Sprites/Plants/PlayerHouse/PotatoMine.png"), 34, 42)

plants = require("plant")

local lockX
local lockY

local groanTimer = 0

local hugeWave = Resources.image(Language.get("huge_wave_texture"))
local finalWave = Resources.image(Language.get("final_wave_texture"))

plantInstances = {
    {},
    {},
    {},
    {},
    {}
}

zombiesInstances = {
    {},
    {},
    {},
    {},
    {}
}

local topBG = Resources.image("Sprites/BG/TopScreen/BG.png")
local topBGworld = nil
if musicType == 1 then
    topBGworld = Resources.image("Sprites/BG/TopScreen/Tutorial.png")
elseif musicType == 2 then
    topBGworld = Resources.image("Sprites/BG/TopScreen/Egypt.png")
end
local topFG = Resources.image("Sprites/BG/TopScreen/Overlay.png")

local zombies = require("zombie")

local plantSound = Resources.sfx("Audio/SFX/Plant.ogg")
local SeedSound = Resources.sfx("Audio/SFX/SeedLift.ogg")
local BuzzerSound = Resources.sfx("Audio/SFX/CannotPick.ogg")

local sunsTextTemp = 100
is_speedup = false
local ySeeds = -48

local timer = 0

local sfx_endlevel = Resources.sfx("Audio/SFX/GameEffects/LevelEndFade.ogg")

suns = 100

local sunTimer = 0

local groans = {
    Resources.sfx("Audio/SFX/Groans1.ogg"),
    Resources.sfx("Audio/SFX/Groans2.ogg"),
    Resources.sfx("Audio/SFX/Groans3.ogg"),
    Resources.sfx("Audio/SFX/Groans4.ogg"),
    Resources.sfx("Audio/SFX/Groans5.ogg"),
    Resources.sfx("Audio/SFX/Groans6.ogg")
}

local SunsClass = require("suns")
local sysDepth = 0

sunsInstances = {}

local mousePlantFrame = 0

local speedButton = Checkbox:new(
        288,
        0,
        Resources.image("Sprites/UI/HUD/SpeedButton.png"),
        Resources.image("Sprites/UI/HUD/SpeedButtonActive.png"),
        nil,
        nil,
        false
    )
pauseButton = Checkbox:new(
        252,
        0,
        Resources.image("Sprites/UI/HUD/PauseButton.png"),
        Resources.image("Sprites/UI/HUD/PauseButtonActive.png"),
        nil,
        nil,
        false
    )

speedButton:setOnToggle(function(v)

    is_speedup = v
    speedEffect = 1
    speedOpacity = 0
    if is_speedup == true then
        speedscale = 1.45
        sfx_speedup:stop()
        sfx_speedup:play()
    else
        speedscale = 1
        sfx_speeddown:stop()
        sfx_speeddown:play()
    end

end)

pauseButton:setOnToggle(function(v)

    is_paused = v
    if is_paused == true then
        sfx_pause:stop()
        sfx_pause:play()
    end
end)

ui_btn_pause_resume:setOnClick(function()

    is_paused = false
    pauseButton.checked = false

end)

ui_btn_pause_quit:setOnClick(function()

    backToMenu()

end)

local soderRoll = Resources.image("Sprites/BG/Lawn/SoderRoll.png")
local soderLong = Resources.image("Sprites/BG/Lawn/SoderLong.png")
local soderEnd = Resources.image("Sprites/BG/Lawn/SoderEnd.png")

-- 156 120
local row1sprite = Resources.image("Sprites/BG/Lawn/1RowModern.png")

-- 157 84
local row3sprite = Resources.image("Sprites/BG/Lawn/3RowModern.png")


local row5sprite = Resources.image("Sprites/BG/Lawn/Full.png")

-- Quads réutilisables : ne jamais créer de Quad dans love.draw sur 3DS.
local sodQuad1 = love.graphics.newQuad(0, 0, 1, row1sprite:getHeight(), 269, 45)
local sodQuad3 = love.graphics.newQuad(0, 0, 1, row3sprite:getHeight(), 269, 118)
local sodQuad5 = love.graphics.newQuad(0, 0, 1, row5sprite:getHeight(), 269, row5sprite:getHeight())

local sunsHud = Resources.image("Sprites/UI/HUD/SunsHUD.png")

scrollX = 0

local gameplayState = 1
local locked = false

local ready = Resources.image(Language.get("ready_texture"))
local set = Resources.image(Language.get("set_texture"))
local plant = Resources.image(Language.get("plant_texture"))

local readySound = Resources.sfx("Audio/SFX/GameEffects/readysetplant.ogg")

local windSound = Resources.sfx("Audio/SFX/GameEffects/wind.ogg")

local plantFoodCount = 2
------------------------------------------------
-- RECOMPENSE DE FIN DE NIVEAU
------------------------------------------------

local rewardSeed = Resources.image("Sprites/Plants/Seeds/Seeds.png")

local rewardSeedQuad = love.graphics.newQuad(
    currentLevelIndex * 35, 0,
    35, 23,
    140, 23
)

local sodX = 0

local rewardActive = false
local rewardCollected = false
local rewardTimer = 0

local rewardX = 160
local rewardY = 120

local rewardStartY = 160
local rewardJumpHeight = 35

local hadZombies = false

local lawn = Resources.image(lawnType)

local sodX = 0

for i, v in ipairs(seeds) do

    v.currentRecharge = v.startRecharge

end

local function clamp01(t)
    return math.max(0, math.min(1, t))
end

local function quadInOut(t)
    t = clamp01(t)

    if t < 0.5 then
        return 2 * t * t
    end

    return 1 - ((-2 * t + 2)^2) / 2
end

function updateSpeedEffect(dt)
    if speedEffect > 0 then
        speedOpacity = speedOpacity + 0.008
        speedEffect = speedEffect - 0.064
    else
        speedOpacity = speedOpacity - 0.008
    end
    speedOpacity = clamp01(speedOpacity)
end

function drawSpeedEffect()

    love.graphics.setColor(0.7, 0.8, 1, speedOpacity)

    love.graphics.rectangle("fill", 0, 0, 320, 240)

    love.graphics.setColor(1, 1, 1, 1)

end

function drawGame(screen)

    if screen ~= "bottom" then

        love.graphics.draw(topBG, 200, 120, timer / 5, 0.95, 0.95, 320, 320)
        love.graphics.draw(topFG, 0, 0)
        love.graphics.draw(topBGworld, 200, 120 + math.floor(math.cos(timer) * 5), 0, 1, 1, 60, 64)
        if musicType == 2 then
            love.graphics.printf(
                Language.get("day") .. " " .. currentLevelIndex .. " - " .. Language.get("trip_egypt"),
                120,
                214,
                160,
                "center"
            )
        else
            love.graphics.printf(
                Language.get("day") .. " " .. currentLevelIndex .. " - " .. Language.get("player_house"),
                120,
                214,
                160,
                "center"
            )
        end
        drawRewardFade()

    end

    love.graphics.setColor(1, 1, 1, 1)
    
    if screen == "bottom" then

        love.graphics.draw(lawn, scrollX, 0)

        DrawSod()

        for i = 1, 5 do

            if plantInstances[i] then

                for _, p in ipairs(plantInstances[i]) do

                    p:draw()

                end

            end

            if zombiesInstances[i] then

                for _, z in ipairs(zombiesInstances[i]) do

                    z:draw()

                end

            end

        end

        for _, zp in ipairs(zombiesInstancesPres) do

            if zp then   
            
                zp:draw()

            end
        
        end

        for i = 1, 5 do

            if corpsesInstances[i] then

                for _, c in ipairs(corpsesInstances[i]) do

                    c:draw()

                end

            end

        end
        
        drawPotatosplosion()

        for _, l in ipairs(lawnmowers) do

            l:draw()

        end

        for _, p in ipairs(projectilesInstances) do

            p:draw()

        end

        for _, s in ipairs(splashesInstances) do

            s:draw()

        end

        DrawStartText()

        if timer > 16 then

            level:drawBar()

        end

        DrawSuns()

        if ySeeds > -48 then

            DrawSeeds()

        end

        drawReward()

        drawPlantfood()

        drawShovel()

        if timer < 3 then

            love.graphics.printf(
                Language.get("your_house"),
                120,
                214,
                80,
                "center"
            )       

        end

        speedButton:draw()
        pauseButton:draw()

        if timer > 6 then

            drawTutorialText()
            
        end
        if is_paused then

            drawPause()
            
        end

        drawSpeedEffect()

        drawRewardFade()

    end

end

if getCurrentLevelName() == "tutorial2" then

    tutorialMessagesID = 7
    local hx = math.floor((180 - 29) / 30) * 30 + 37
    local hy = math.floor((130 + 18) / 37) * 37 - 10
    plants:new(1, hx, hy)

elseif getCurrentLevelName() == "tutorial3" then

    tutorialMessagesID = 0
    local hx = math.floor((240 - 29) / 30) * 30 + 37
    local hy = math.floor((167 + 18) / 37) * 37 - 10
    plants:new(3, hx, hy)

elseif getCurrentLevelName() == "tutorial1" then

    tutorialMessagesID = 1

else

    tutorialMessagesID = 0

end


if lines == 5 then

    tutorialMessagesID = 0
    
end

function updateGameplay(dt)
    if lines == 1 then
        if tutorialMessagesID == 1 and #plantInstances[3] > 0 then
            tutorialMessagesID = 2
        elseif tutorialMessagesID == 2 then
            temp = temp + dt
            if temp >= 2 then
                sunTimer = 8
                tutorialMessagesID = 3
            end
        elseif tutorialMessagesID == 3 and suns >= 50 then
            tutorialMessagesID = 4
        elseif tutorialMessagesID == 4 and suns >= 100 then
            tutorialMessagesID = 5
        elseif tutorialMessagesID == 5 and #plantInstances[3] > 1 then
            tutorialMessagesID = 6
        elseif tutorialMessagesID == 6 then
            temp = temp + dt
            if temp >= 6 then
                tutorialMessagesID = 0
            end
        end
    elseif lines == 3 then
        if tutorialMessagesID == 7 and #plantInstances[2] + #plantInstances[3] + #plantInstances[4] > 1 then
            tutorialMessagesID = 8
        elseif tutorialMessagesID >= 8 then
            temp = temp + dt
            if temp >= 3 then
                tutorialMessagesID = tutorialMessagesID + 1
                if tutorialMessagesID > 10 then
                    tutorialMessagesID = 0
                end
                temp = 0
            end
        end
    end

    updatePotatosplosion(dt)

    -- Projectiles
    for i = #projectilesInstances, 1, -1 do
        projectilesInstances[i]:update(dt)
    end

    -- Compteur de soleils
    if suns > sunsTextTemp then
        sunsTextTemp = math.min(
            suns,
            sunsTextTemp + 300 * dt
        )
    else
        sunsTextTemp = suns
    end
    
    -- Projectiles
    for i = #splashesInstances, 1, -1 do
        splashesInstances[i]:update(dt)
    end
    
    -- Plantes
    for line = 1, 5 do
        local plant = plantInstances[line]
        
        for i = #plantInstances[line], 1, -1 do
            plant[i]:update(dt)
        end
    end

    -- Soleils
    for i = #sunsInstances, 1, -1 do
        sunsInstances[i]:update(dt)
    end

    for i = #lawnmowers, 1, -1 do
        lawnmowers[i]:update(dt)
    end

    -- Zombies
    for line = 1, 5 do
        local zombies = zombiesInstances[line]

        for i = #zombies, 1, -1 do
            zombies[i]:update(dt)
        end
    end

    for line = 1, 5 do
        local corpse = corpsesInstances[line]

        for i = #corpse, 1, -1 do
            corpse[i]:update(dt)
        end
    end

    -- Musique / sons de début
    if timer <= 0 then
        mus_playerhouse:setLooping(true)
        mus_playerhouse:play()

        windSound:play()
    end

-- Mise à jour des zombies de présentation
    for i = #zombiesInstancesPres, 1, -1 do
        local zp = zombiesInstancesPres[i]

        if zp then
            zp:update(dt)
        end
    end

    -- Suppression de la présentation
    if timer >= 3 then
        for i = #zombiesInstancesPres, 1, -1 do
            local zp = zombiesInstancesPres[i]

            if zp then
                zp:remove()
            end
        end
    end

    timer = timer + dt

    -- Intro
    if gameplayState == 1 then

        local t = quadInOut(timer)

        scrollX = -300 * t

        if timer >= 2 then
            gameplayState = 2
        end

    elseif gameplayState == 2 then

        local t = quadInOut(timer - 2)

        scrollX = -300 + 195 * t

        if timer >= 3 then
            gameplayState = 3
        end

    elseif timer <= 3.1 and not readySound:isPlaying() then

        readySound:play()

    elseif timer >= 3.5 and timer <= 6 then

        if #lawnmowers <= 0 then

            for i = 1, 5 do

                Lawnmower:new(30, 30 + 37 * i)

            end

        end

        local t = quadInOut((timer - 3.5) * 3)
        ySeeds = -48 + 50 * t
        
        if sodX < 280 then

            t = quadInOut((timer - 3.5) * 0.5)
            sodX = 269 * t

        end

    elseif timer > 6 then

        if timer < 8 then
            zombiesInstancesPres = {}
        end

        if timer > 16 then

            if #zombiesInstances[1] + #zombiesInstances[2] + #zombiesInstances[3] + #zombiesInstances[4] + #zombiesInstances[5] > 0 then

                groanTimer = groanTimer + dt

            end

            if groanTimer > 10 - math.min(8, #zombiesInstances[1] + #zombiesInstances[2] + #zombiesInstances[3] + #zombiesInstances[4] + #zombiesInstances[5]) then

                groans[math.random(1, 6)]:play()
                groanTimer = 0

            end

        end
        
        if tutorialMessagesID == 0 or tutorialMessagesID > 10 then

            level:update(dt)

        end

        -- Recharge des graines
        for _, s in ipairs(seeds) do
            s.currentRecharge = math.min(
                s.recharge,
                s.currentRecharge + dt
            )
        end

        -- Apparition des soleils
        if tutorialMessagesID > 2 or tutorialMessagesID == 0 then
            sunTimer = sunTimer + dt

            if sunTimer >= 8 and rewardActive == false then
                table.insert(
                    sunsInstances,
                    SunsClass:newFalling(math.random(60, 260))
                )

                sunTimer = 0
            end
        end
    end

    updateSpeedEffect(dt)
    updateReward(dt)

    -- Animation de la graine sélectionnée
    if touchedSeed == 1 then

        mousePlantFrame = mousePlantFrame + dt * 15

        if mousePlantFrame >= 15 then
            mousePlantFrame = mousePlantFrame - 15
        end
    end
    if touchedSeed == 2 then

        mousePlantFrame = mousePlantFrame + dt * 2

    end
end

function DrawStartText()

    if timer > 3 then

        if timer < 3.6 then

            love.graphics.draw(ready, 160, 120, 0, 1, 1, 48, 21)

        elseif timer < 4.2 then

            love.graphics.draw(set, 160, 120, 0, 1, 1, 48, 21)

        elseif timer < 5.3 then

            love.graphics.draw(plant, 160, 120, 0, 1, 1, 48, 21)

        elseif hugeWaveActive and not hugeWaveIsFinal and hugeWaveTimer < 2 then

            love.graphics.draw(hugeWave, 160, 120, 0, 1, 1, 128, 32)
            if not hugeWaveSound:isPlaying() then
                hugeWaveSound:play()
            end

        elseif hugeWaveActive and hugeWaveIsFinal and hugeWaveTimer >= 2 and hugeWaveTimer < 4 then

            love.graphics.draw(finalWave, 160, 120, 0, 1 - math.min(0.5, hugeWaveTimer - 2), 1 - math.min(0.5, hugeWaveTimer - 2), 128, 32)
            if not finalWaveSound:isPlaying() then
                finalWaveSound:play()
            end
        end

    end

end

function DrawSeeds()

    love.graphics.setColor(1, 1, 1, 1)

    for _, s in ipairs(seeds) do

        if touchedSeed == id or suns < s.price or s.currentRecharge < s.recharge then love.graphics.setColor(0.65, 0.65, 0.65, 1) end

        love.graphics.draw(s.sprite.spriteSheet, s.sprite.quads[s.type], s.id * 37 + 23, ySeeds)

        love.graphics.setColor(0, 0, 0, 0.4)

        if not s.rechargeQuad then
            s.rechargeQuad = love.graphics.newQuad(0, 0, 35, 23, 70, 23)
        end

        local rechargeHeight = 23 - s.currentRecharge * (23 / s.recharge)
        if rechargeHeight < 0 then rechargeHeight = 0 end
        if rechargeHeight > 23 then rechargeHeight = 23 end
        s.rechargeQuad:setViewport(0, 0, 35, rechargeHeight, 70, 23)

        love.graphics.draw(s.sprite.spriteSheet, s.rechargeQuad, s.id * 37 + 23, ySeeds)

        love.graphics.setColor(1, 1, 1, 1)
        
    end

    love.graphics.draw(sunsHud, 0, ySeeds - 2)
    
    love.graphics.printf(
        math.floor(sunsTextTemp),
        24,
        7,
        29,
        "left"
    )

    locked = false
    
    if touchedSeed > 0 then

        if lines == 1 then

            if mouse_x > 58 and mouse_x < 320 and mouse_y > 130 and mouse_y < 163 then

                love.graphics.setColor(1, 1, 1, 0.4)

                lockX = math.floor((mouse_x - 29) / 30) * 30 + 37
                lockY = math.floor((mouse_y + 18) / 37) * 37 - 10

                locked = true

            else

                love.graphics.setColor(1, 1, 1, clamp01(mouse_y / 50))

                lockX = mouse_x
                lockY = mouse_y
            
            end
        
        elseif lines == 3 then

            if mouse_x > 58 and mouse_x < 320 and mouse_y > 98 and mouse_y < 199 then

                love.graphics.setColor(1, 1, 1, 0.4)

                lockX = math.floor((mouse_x - 29) / 30) * 30 + 37
                lockY = math.floor((mouse_y + 18) / 37) * 37 - 10

                locked = true

            else

                love.graphics.setColor(1, 1, 1, clamp01(mouse_y / 50))

                lockX = mouse_x
                lockY = mouse_y
            
            end
        
        elseif lines == 5 then

            if mouse_x > 58 and mouse_x < 320 and mouse_y > 62 and mouse_y < 235 then

                love.graphics.setColor(1, 1, 1, 0.4)

                lockX = math.floor((mouse_x - 29) / 30) * 30 + 37
                lockY = math.floor((mouse_y + 18) / 37) * 37 - 10

                locked = true

            else

                love.graphics.setColor(1, 1, 1, clamp01(mouse_y / 50))

                lockX = mouse_x
                lockY = mouse_y
            
            end
        
        end

    end

    if touchedSeed == 1 then 

        love.graphics.draw(peashooterAnim.spriteSheet, peashooterAnim.quads[math.floor(mousePlantFrame + 1)], math.floor(lockX), math.floor(lockY), 0, 1, 1, 18, 18)

        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.draw(selector, 58, 0)

    elseif touchedSeed == 2 then 
            
        love.graphics.draw(sunflowerAnim.spriteSheet, sunflowerAnim.quads[math.floor(math.cos(mousePlantFrame) * 5 + 7)], math.floor(lockX), math.floor(lockY), 0, 1, 1, 15, 16)

        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.draw(selector, 95, 0)

    elseif touchedSeed == 3 then 
            
        love.graphics.draw(wallnutAnim.spriteSheet, wallnutAnim.quads[1], math.floor(lockX), math.floor(lockY), 0, 1, 1, 12, 15)

        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.draw(selector, 132, 0)

    elseif touchedSeed == 4 then 
            
        love.graphics.draw(potatomineAnim.spriteSheet, potatomineAnim.quads[1], math.floor(lockX), math.floor(lockY), 0, 1, 1, 16, 20)

        love.graphics.setColor(1, 1, 1, 1)

        love.graphics.draw(selector, 169, 0)

    end

    love.graphics.setColor(1, 1, 1, 1)

end

function PlacePlant()

    if locked == true then
        
        if not plantExist(lockX, lockY, math.floor((lockY - 10) / 37)) then

            plants:new(touchedSeed, lockX, lockY)

            suns = suns - seeds[touchedSeed].price

            seeds[touchedSeed].currentRecharge = 0

            plantSound:stop()
            plantSound:play()

        end

    end

    touchedSeed = 0

end

function checkTouchedSeed(slot, x, y)
    
    if (x > slot * 37 + 23) and (x < slot * 37 + 23 + 35) and y < 25 then
        
        if slot <= #seeds and slot > 0 then
    
            if suns >= seeds[slot].price then

                if seeds[slot].currentRecharge >= seeds[slot].recharge then

                    if (y > 2) and (y < 25) then

                        SeedSound:stop()
                        SeedSound:play()
                        return slot

                    end    

                end
            
            end

            BuzzerSound:play()

        end

    end

    return 0

end

function DrawSod()

    if musicType > 1 then return end

    if rollingsod == false then
        
        if lines == 1 then

            love.graphics.draw(row1sprite, 156 + scrollX, 120)

        elseif lines == 3 then

            love.graphics.draw(row3sprite, 157 + scrollX, 84)

        elseif lines == 5 then

            love.graphics.draw(row5sprite, 157 + scrollX, 53)
        
        end

        return

    else

        local sod_quad

        if lines == 1 then

            sodQuad1:setViewport(0, 0, math.max(1, sodX), row1sprite:getHeight(), 269, 45)
            sod_quad = sodQuad1

            love.graphics.draw(row1sprite, sod_quad, 156 + scrollX, 120)

            if sodX < 260 then

                love.graphics.draw(soderLong, 156 + scrollX + sodX, 124, 0, 1 - sodX / 269 * 0.5 - 0.5, 1, 11, 0)
                love.graphics.draw(soderRoll, 156 + scrollX + sodX, 157, 0, 1 - sodX / 269 * 0.5 - 0.5, 1 - sodX / 269 * 0.5 - 0.5, 12, 12)
                love.graphics.draw(soderEnd, 156 + scrollX + sodX, 124, 0, 1 - sodX / 269 * 0.5 - 0.5, 1 - sodX / 269 * 0.5 - 0.5, 9, 8)

            end

        elseif lines == 3 then

            sodQuad3:setViewport(0, 0, math.max(1, sodX), row3sprite:getHeight(), 269, 118)
            sod_quad = sodQuad3

            if sodX < 259 then love.graphics.draw(row1sprite, 156 + scrollX, 120) end

            love.graphics.draw(row3sprite, sod_quad, 157 + scrollX, 84)

            if sodX < 260 then

                love.graphics.draw(soderLong, 156 + scrollX + sodX, 87, 0, 1 - sodX / 269 * 0.5 - 0.5, 1, 11, 0)
                love.graphics.draw(soderRoll, 156 + scrollX + sodX, 120, 0, 1 - sodX / 269 * 0.5 - 0.5, 1 - sodX / 269 * 0.5 - 0.5, 12, 12)
                love.graphics.draw(soderEnd, 156 + scrollX + sodX, 87, 0, 1 - sodX / 269 * 0.5 - 0.5, 1 - sodX / 269 * 0.5 - 0.5, 9, 8)

                love.graphics.draw(soderLong, 156 + scrollX + sodX, 161, 0, 1 - sodX / 269 * 0.5 - 0.5, 1, 11, 0)
                love.graphics.draw(soderRoll, 156 + scrollX + sodX, 194, 0, 1 - sodX / 269 * 0.5 - 0.5, 1 - sodX / 269 * 0.5 - 0.5, 12, 12)
                love.graphics.draw(soderEnd, 156 + scrollX + sodX, 161, 0, 1 - sodX / 269 * 0.5 - 0.5, 1 - sodX / 269 * 0.5 - 0.5, 9, 8)

            end

        elseif lines == 5 then

            sodQuad5:setViewport(0, 0, math.max(1, sodX), row5sprite:getHeight(), 269, row5sprite:getHeight())
            sod_quad = sodQuad5

            if sodX < 259 then love.graphics.draw(row3sprite, 156 + scrollX, 84) end

            love.graphics.draw(row5sprite, sod_quad, 157 + scrollX, 53)

            if sodX < 260 then

                love.graphics.draw(soderLong, 156 + scrollX + sodX, 56, 0, 1 - sodX / 269 * 0.5 - 0.5, 1, 11, 0)
                love.graphics.draw(soderRoll, 156 + scrollX + sodX, 89, 0, 1 - sodX / 269 * 0.5 - 0.5, 1 - sodX / 269 * 0.5 - 0.5, 12, 12)
                love.graphics.draw(soderEnd, 156 + scrollX + sodX, 56, 0, 1 - sodX / 269 * 0.5 - 0.5, 1 - sodX / 269 * 0.5 - 0.5, 9, 8)

                love.graphics.draw(soderLong, 156 + scrollX + sodX, 192, 0, 1 - sodX / 269 * 0.5 - 0.5, 1, 11, 0)
                love.graphics.draw(soderRoll, 156 + scrollX + sodX, 225, 0, 1 - sodX / 269 * 0.5 - 0.5, 1 - sodX / 269 * 0.5 - 0.5, 12, 12)
                love.graphics.draw(soderEnd, 156 + scrollX + sodX, 192, 0, 1 - sodX / 269 * 0.5 - 0.5, 1 - sodX / 269 * 0.5 - 0.5, 9, 8)

            end

        end

    end

end

function DrawSuns()

    for _, s in ipairs(sunsInstances) do

        s:draw()
    
    end

end

function setPF(x, y)

    if math.floor((mouse_y - 10) / 37) < 1 or math.floor((mouse_y - 10) / 37) > 5 then return end

    for _, p in ipairs(plantInstances[math.floor((mouse_y - 10) / 37)]) do

        if x > p.x - 11 and x < p.x + 11 and y > p.y - 11 and y < p.y + 11 then

            if not p.plantFood then
                p.plantFood = true
                p.plantFoodState = 1
            end
            return

        end

    end

end

function removePlant(x, y)

    if math.floor((mouse_y - 10) / 37) < 1 or math.floor((mouse_y - 10) / 37) > 5 then return end

    for _, p in ipairs(plantInstances[math.floor((mouse_y - 10) / 37)]) do

        if x > p.x - 11 and x < p.x + 11 and y > p.y - 11 and y < p.y + 11 then

            sfx_remove:play()
            p:remove()
            return

        end

    end

end

function drawShovel()

    if holdingShovel == true then
        love.graphics.draw(shovelUIHover, 293, 213)
        love.graphics.draw(shovel, mouse_x, mouse_y, 0, 1, 1, 0, 12)
    else
        love.graphics.draw(shovelUI, 293, 213)
        love.graphics.draw(shovel, 385, 217)
    end

end

function drawPlantfood()

    if haslevelPF == false then return end

    love.graphics.draw(plantfoodUI, 0, 217)
    if holdingPF == true then
        love.graphics.draw(plantfoodLeaf, mouse_x, mouse_y)
    else
        love.graphics.draw(plantfoodLeaf, 0, 217)
    end

end

function plantExist(x, y, line)

    for _, p in ipairs(plantInstances[line]) do

        if p.x == x and p.y == y then

            return true

        end

    end

    return false

end

function drawTutorialText()
    if tutorialMessagesID > 0 then
        love.graphics.setColor(0, 0, 0, 0.5)
        love.graphics.rectangle(
            "fill",
            0,
            180,
            320,
            40
        )
        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.printf(
            Language.get("tutorialMessages")[tutorialMessagesID],
            0,
            196,
            320,
            "center"
        )
    end
end

------------------------------------------------
-- MOUSE PRESSED
------------------------------------------------

function gpmousepressed(x,y,button)
    if x > 0 and x < 23 and y > 217 and y < 240 and haslevelPF == true then
        holdingPF = true
    end
    if x > 293 and x < 317 and y > 217 and y < 240 then
        holdingShovel = true
        sfx_shovel:play()
    end
    checkReward(x, y)
    if timer > 6 then
        speedButton:mousepressed(x,y,button)
        pauseButton:mousepressed(x,y,button)
    end
end

------------------------------------------------
-- MOUSE RELEASED
------------------------------------------------

function gpmousereleased(x,y,button)
    if holdingPF == true and haslevelPF == true then
        setPF(x, y)
        holdingPF = false
    end
    if holdingShovel == true then
        removePlant(x, y)
        holdingShovel = false
    end
    if is_paused then
        ui_btn_pause_resume:mousereleased(x,y,button)
    end
    if timer > 6 then
        speedButton:mousereleased(x,y,button)
        pauseButton:mousereleased(x,y,button)
    end
end

------------------------------------------------
-- TOUCH
------------------------------------------------

function gptouchpressed(id,x,y)
    checkReward(x, y)
    if is_paused then
        ui_btn_pause_resume:touchpressed(id,x,y)
    else
        if (x > 0) and (x < 23) and (y > 217) and (y < 240) and haslevelPF == true then
            holdingPF = true
        end
        if x > 293 and x < 317 and y > 217 and y < 240 then
            sfx_shovel:play()
            holdingShovel = true
        end
    end
    if timer > 6 then
        speedButton:touchpressed(id,x,y)
        pauseButton:touchpressed(id,x,y)
    end
end

function gptouchreleased(id,x,y)
    if holdingPF == true and haslevelPF == true then
        setPF(x, y)
        holdingPF = false
    end
    if holdingShovel == true then
        removePlant(x, y)
        holdingShovel = false
    end
    if is_paused then
        ui_btn_pause_resume:touchreleased(id,x,y)
    end
    if timer > 6 then
        speedButton:touchreleased(id,x,y)
        pauseButton:touchreleased(id,x,y)
    end
end

--------------------------------------------------
-- INTERFACE DE SCENE
--------------------------------------------------
function drawPause()

    love.graphics.setColor(0, 0, 0, 0.5)

    love.graphics.rectangle("fill", 0, 0, 320, 240)

    love.graphics.setColor(1, 1, 1, 1)

    pause_panel:draw(
        20,
        50,
        280,
        140
    )

    ui_btn_pause_quit:draw()
    love.graphics.printf(
        Language.get("return_menu"),
        68,
        181,
        72,
        "center"
    )

    ui_btn_pause_resume:draw()
    love.graphics.printf(
        Language.get("resume"),
        172,
        181,
        72,
        "center"
    )
end

function updateReward(dt)

    -- Animation du paquet
    if rewardActive then
        rewardTimer = rewardTimer + dt
        if rewardPicked then
            rewardStartY = rewardStartY - (rewardStartY - 120) / 15
            rewardX = rewardX - (rewardX - 160) / 15
            if not mus_playerhouseReward:isPlaying() then
                if alpha <= 0.05 then
                    sfx_endlevel:play()
                end
                alpha = alpha + dt / 5
                if alpha >= 1 then
                    sfx_endlevel:stop()
                    rewardScreen()
                end
            end
        end
    end
end

function startReward(x, y)
    rewardPicked = false
    rewardActive = true
    rewardTimer = 0

    rewardX = 240
    rewardStartY = 160
end

function drawReward()

    if rewardActive then
        local t = math.min(rewardTimer / 0.6, 1)

        -- Petit saut avec easing
        local jump = math.sin(t * math.pi) * rewardJumpHeight

        local y = rewardStartY - jump

        love.graphics.setColor(1, 1, 1, 1)

        if currentLevelIndex == 4 then

            love.graphics.draw(hotSauce, rewardX, y, 0, 1, 1, 14, 26)

        else

            love.graphics.draw(
                rewardSeed,
                rewardSeedQuad,
                rewardX,
                y,
                0,
                1,
                1,
                17,
                11
            )

        end
    end
end

function checkReward(x, y)

    if not rewardActive then
        return
    end

    if rewardPicked then
        return
    end

    if x > rewardX - 17
    and x < rewardX + 17
    and y > rewardStartY - 11
    and y < rewardStartY + 11 then
        mus_playerhouse:stop()
        mus_playerhouseReward:play()
        rewardPicked = true
    end
end

function triggerLose()

    backToMenu()

end

function drawRewardFade()

    love.graphics.setColor(1, 1, 1, alpha)
    love.graphics.rectangle("fill", 0, 0, 400, 240)
    love.graphics.setColor(1, 1, 1, 1)

end

return {

    update = updateGameplay,

    draw = drawGame,

    unload = function()

        --------------------------------------------------
        -- Arrêter les sons / musiques du gameplay
        --------------------------------------------------

        if mus_playerhouse then
            mus_playerhouse:stop()
        end

        if windSound then
            windSound:stop()
        end

        if hugeWaveSound then
            hugeWaveSound:stop()
        end

        if finalWaveSound then
            finalWaveSound:stop()
        end

        hugeWaveActive = false
        hugeWaveTimer = 0
        hugeWaveWaitTimer = 0
        hugeWaveIsFinal = false

        if levelSystem then
            levelSystem.hugeWavePending = false
            levelSystem.hugeWavePendingWave = nil
        end

        if readySound then
            readySound:stop()
        end

    end

}