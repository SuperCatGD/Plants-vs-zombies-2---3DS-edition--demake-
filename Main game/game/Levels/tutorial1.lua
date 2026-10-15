return {
    damageThreshold = 160,
    timeThreshold   = 20,
    lines = 1,
    suns = 100,
    reward = 2,
    animationline = true,
    lawn = "Sprites/BG/Lawn/ModernDays.png",
    music = 1,
    plantfood = false,
    zombiespres = {
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
            currentRecharge = 4.9,
            price = 100,
            rechargeQuad = love.graphics.newQuad(0, 0, 35, 23, 35, 23)
        }
    },

    waves = {
        {
            time = 0,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=3}
            }
        },
        {
            time = 5.25,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=3}
            }
        },
        {
            time = 8.5,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=3}
            }
        },
        {
            time = 11,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=3}
            }
        },
        {
            time = 12.5,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=3}
            }
        },
        {
            time = 16.5,
            waitzombies = true,
            reward = false,
            finalWave = true,
            zombies = {
                {type="flag", line=3}
            }
        },
        {
            time = 18,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=3}
            }
        },
        {
            time = 20,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=3}
            }
        },
        {
            time = 22,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=3}
            }
        },
        {
            time = 24,
            waitzombies = false,
            reward = true,
            zombies = {
                {type="basic", line=3}
            }
        }
    }
}
