return {
    damageThreshold = 180,
    timeThreshold = 20,
    lines = 3,
    suns = 50,
    reward = 4,
    animationline = false,
    lawn = "Sprites/BG/Lawn/ModernDays.png",
    music = 1,
    plantfood = false,
    zombiespres = {
        "basic",
        "basic",
        "conehead",
        "conehead",
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
            startRecharge = 0,
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
        },
        {
            sprite = newAnimation(Resources.image("Sprites/Plants/Seeds/Seeds.png"), 35, 23),
            id = 3,
            type = 3,
            recharge = 20,
            startRecharge = 15,
            currentRecharge = 15,
            price = 50,
            rechargeQuad = love.graphics.newQuad(0, 0, 35, 23, 35, 23)
        }
    },

    waves = {
        {
            time = 16,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="conehead", line=3},
                {type="conehead", line=4},
            }
        },
        {
            time = 25,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="conehead", line=3},
            }
        },
        {
            time = 39,
            waitzombies = true,
            reward = false,
            finalWave = true,
            zombies = {
                {type="basic", line=2},
                {type="basic", line=3},
                {type="flag", line=4},
            }
        },
        {
            time = 45,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="conehead", line=2},
                {type="basic", line=4},
            }
        }
    }
}
