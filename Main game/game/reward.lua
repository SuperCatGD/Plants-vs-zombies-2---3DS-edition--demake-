local rewardType = 1

local rewardMusic = Resources.music("Audio/Music/Reward.ogg")

local rewardFrame = 1
local alpha = 1

local sfx_options_button_pressed = Resources.sfx("Audio/SFX/Buttons/OptionsPress.ogg")
local sfx_options_button_released = Resources.sfx("Audio/SFX/Buttons/OptionsRelease.ogg")

local NinePatchButton = require("ninepatchbutton")

local ui_btn_reward_menu =
    NinePatchButton:new(
        66,
        165,
        68,
        24,

        "Sprites/UI/Menu/Buttons/Orange.png",

        "Sprites/UI/Menu/Buttons/OrangePressed.png",

        8,

        sfx_options_button_pressed,

        sfx_options_button_released
    )
local ui_btn_reward_next =
    NinePatchButton:new(
        186,
        165,
        68,
        24,

        "Sprites/UI/Menu/Buttons/Purple.png",

        "Sprites/UI/Menu/Buttons/PurplePressed.png",

        8,

        sfx_options_button_pressed,

        sfx_options_button_released
    )

local rewardSpriteSingle = Resources.image("Sprites/Other/HotSauce.png")
local rewardLabel = "sunflowerdesc"
local rewardSprite = newAnimation(Resources.image("Sprites/Plants/PlayerHouse/Sunflower.png"), 31, 35)
if currentLevelIndex == 2 then
    rewardLabel = "wallnutdesc"
    rewardSprite = newAnimation(Resources.image("Sprites/Plants/PlayerHouse/WallNut.png"), 24, 30)
elseif currentLevelIndex == 3 then
    rewardLabel = "potatominedesc"
    rewardSprite = newAnimation(Resources.image("Sprites/Plants/PlayerHouse/PotatoMine.png"), 34, 42)
elseif currentLevelIndex == 4 then
    rewardLabel = "enddesc"
end

local rewardPanel = Resources.image(Language.get("reward_panel"))
local rewardBG = Resources.image("Sprites/UI/Menu/Panels/RewardBG.png")

ui_btn_reward_next:setOnClick(function()

    -- Lance la transition de chargement vers le niveau suivant
    -- (ou retourne au menu s'il n'y a plus de niveau).
    goToNextLevel()

end)
ui_btn_reward_menu:setOnClick(function()

    -- Lance la transition de chargement vers le niveau suivant
    -- (ou retourne au menu s'il n'y a plus de niveau).
    backToMenu()

end)
local function updateReward(dt)

    rewardFrame = rewardFrame + dt * 2
    if alpha > 0 then
        alpha = alpha - 0.008
    else
        alpha = 0
    end

    if rewardMusic and not rewardMusic:isPlaying() then

        rewardMusic:play()

    end

end

-- Panneau de récompense seul (sans le fond), avec une opacité globale.
-- Utilisé aussi par main.lua pendant le fade vers le niveau suivant, pour
-- que le menu reste visible par-dessus le fond de chargement.
local function drawRewardUI(a)

    a = a or 1

    love.graphics.setColor(1, 1, 1, a)

    ui_panel:draw(
        70,
        60,
        180,
        120
    )
    love.graphics.draw(rewardPanel, 70, 20)
    love.graphics.draw(rewardBG, 90, 100)

    if currentLevelIndex == 1 then
        love.graphics.draw(rewardSprite.spriteSheet, rewardSprite.quads[math.floor(math.cos(rewardFrame) * 5 + 7)], 93, 103)
    elseif currentLevelIndex == 2 then
        love.graphics.draw(rewardSprite.spriteSheet, rewardSprite.quads[1], 93, 103)
    elseif currentLevelIndex == 3 then
        love.graphics.draw(rewardSprite.spriteSheet, rewardSprite.quads[6], 93, 103)
    elseif currentLevelIndex == 4 then
        love.graphics.draw(rewardSpriteSingle, 93, 103)
    end

    love.graphics.printf(
        Language.get(rewardLabel)[1],
        90,
        77,
        144,
        "center"
    )
    ui_btn_reward_next:draw()
    ui_btn_reward_menu:draw()

    love.graphics.printf(
        Language.get("menu"),
        60,
        170,
        80,
        "center"
    )
    love.graphics.printf(
        Language.get("next_level"),
        180,
        170,
        80,
        "center"
    )

    love.graphics.setColor(0, 0, 0, a)

    love.graphics.printf(
        Language.get(rewardLabel)[2],
        135,
        97,
        96,
        "left"
    )

    love.graphics.setColor(1, 1, 1, 1)

end

local function drawReward(screen)

    if screen == "bottom" then

        love.graphics.setColor(1, 1, 1, 1)
        love.graphics.draw(loadingBG, -40, 0)

        drawRewardUI(1)

        love.graphics.setColor(1, 1, 1, alpha)

        love.graphics.rectangle("fill", 0, 0, 320, 240)
        
        love.graphics.setColor(1, 1, 1, 1)

    else

        love.graphics.draw(loadingBG, 0, 0)

        love.graphics.setColor(1, 1, 1, alpha)

        love.graphics.rectangle("fill", 0, 0, 400, 240)
        
        love.graphics.setColor(1, 1, 1, 1)

    end
        
end

function rewardPressed(x, y)

    ui_btn_reward_next:press(x, y, 1)
    ui_btn_reward_menu:press(x, y, 1)

end

function rewardReleased(x, y)

    ui_btn_reward_next:release(x, y, 1)
    ui_btn_reward_menu:release(x, y, 1)

end


return {

    update = updateReward,

    draw = drawReward,

    drawUI = drawRewardUI,

    unload = function()

        if rewardMusic then
            rewardMusic:stop()
            rewardMusic = nil
        end

    end

}