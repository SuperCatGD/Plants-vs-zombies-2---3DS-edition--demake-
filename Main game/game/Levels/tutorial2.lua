return {
    damageThreshold = 180,
    timeThreshold = 20,
    lines = 3,
    suns = 50,
    reward = 3,
    animationline = true,
    lawn = "Sprites/BG/Lawn/ModernDays.png",
    music = 1,
    plantfood = false,
    zombiespres = {
        "basic",
        "basic",
        "basic",
        "basic",
        "basic",
        "basic"
    },

    seeds = {
        {
            sprite = newAnimation(Resources.image("Sprites/Plants/Seeds/Seeds.png"), 35, 23),
            id = 1,
            type = 1,
            recharge = 5,
            startRecharge = 4.9,
            currentRecharge = 0,
            price = 100,
            rechargeQuad = love.graphics.newQuad(0, 0, 35, 23, 35, 23)
        },
        {
            sprite = newAnimation(Resources.image("Sprites/Plants/Seeds/Seeds.png"), 35, 23),
            id = 2,
            type = 2,
            recharge = 5,
            startRecharge = 4.9,
            currentRecharge = 4.9,
            price = 50,
            rechargeQuad = love.graphics.newQuad(0, 0, 35, 23, 35, 23)
        }
    },

    waves = {
        {
            time = 12,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=2}
            }
        },
        {
            time = 24,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=2},
                {type="basic", line=3}
            }
        },
        {
            time = 32,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=4}
            }
        },
        {
            time = 33,
            waitzombies = true,
            reward = false,
            finalWave = true,
            zombies = {
                {type="flag", line=2},
                {type="basic", line=3},
                {type="basic", line=4}
            }
        },
        {
            time = 39,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=2}
            }
        }
    }
}
