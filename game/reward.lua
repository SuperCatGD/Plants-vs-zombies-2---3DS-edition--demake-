local rewardType = 1

local rewardMusic = Resources.music("Audio/Music/Reward.ogg")

local rewardFrame = 1
local alpha = 1

local sfx_options_button_pressed = love.audio.newSource("Audio/SFX/Buttons/OptionsPress.ogg", "static")
local sfx_options_button_released = love.audio.newSource("Audio/SFX/Buttons/OptionsRelease.ogg", "static")

local NinePatchButton = require("ninepatchbutton")

local ui_btn_reward_next =
    NinePatchButton:new(
        126,
        165,
        68,
        24,

        "Sprites/UI/Menu/Buttons/Purple.png",

        "Sprites/UI/Menu/Buttons/PurplePressed.png",

        8,

        sfx_options_button_pressed,

        sfx_options_button_released
    )

local rewardSprite = newAnimation(Resources.image("Sprites/Plants/PlayerHouse/Sunflower.png"), 31, 35)

local rewardPanel = Resources.image(Language.get("reward_panel"))
local rewardBG = Resources.image("Sprites/UI/Menu/Panels/RewardBG.png")

ui_btn_reward_next:setOnClick(function()

    backToMenu()

end)

function updateReward(dt)

    rewardFrame = rewardFrame + dt * 2
    if alpha > 0 then
        alpha = alpha - 0.008
    else
        alpha = 0
    end

    if not rewardMusic:isPlaying() then

        rewardMusic:play()

    end

end

function drawReward(screen)

    if screen == "bottom" then

        love.graphics.draw(loadingBG, -40, 0)

        ui_panel:draw(
            70,
            60,
            180,
            120
        )
        love.graphics.draw(rewardPanel, 70, 20)
        love.graphics.draw(rewardBG, 90, 100)

        love.graphics.draw(rewardSprite.spriteSheet, rewardSprite.quads[math.floor(math.cos(rewardFrame) * 5 + 7)], 93, 103)

        love.graphics.printf(
            Language.get("sunflowerdesc")[1],
            90,
            77,
            144,
            "center"
        )
        ui_btn_reward_next:draw()

        love.graphics.printf(
            Language.get("next_level"),
            120,
            170,
            80,
            "center"
        )

        love.graphics.setColor(0, 0, 0, 1)

        love.graphics.printf(
            Language.get("sunflowerdesc")[2],
            135,
            97,
            96,
            "left"
        )

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

end

function rewardReleased(x, y)

    ui_btn_reward_next:release(x, y, 1)

end


return {

    update = updateReward,

    draw = drawReward,

    unload = function()

        if rewardMusic then

            rewardMusic:stop()

        end

    end

}