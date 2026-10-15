return {
    damageThreshold = 180,
    timeThreshold = 20,
    lines = 5,
    suns = 50,
    reward = 5,
    animationline = true,
    lawn = "Sprites/BG/Lawn/AncientEgypt.png",
    music = 2,
    plantfood = true,
    zombiespres = {
        "mummy_basic",
        "mummy_basic",
        "mummy_conehead",
        "mummy_conehead",
        "mummy_basic",
        "mummy_basic",
        "mummy_buckethead",
        "mummy_basic",
        "mummy_conehead"
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
        },
        {
            sprite = newAnimation(Resources.image("Sprites/Plants/Seeds/Seeds.png"), 35, 23),
            id = 4,
            type = 4,
            recharge = 20,
            startRecharge = 15,
            currentRecharge = 15,
            price = 25,
            rechargeQuad = love.graphics.newQuad(0, 0, 35, 23, 35, 23)
        }
    },

    waves = {
        {
            time = 16,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="mummy_basic", line=3},
            }
        },
        {
            time = 19,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="mummy_basic", line=3},
            }
        },
        {
            time = 27,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="mummy_basic", line=2},
                {type="mummy_basic", line=4},
            }
        },
        {
            time = 40,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="mummy_basic", line=1},
                {type="mummy_basic", line=2},
                {type="mummy_conehead", line=3},
                {type="mummy_basic", line=4},
                {type="mummy_basic", line=5},
            }
        },
        {
            time = 56,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="mummy_conehead", line=2},
                {type="mummy_conehead", line=4},
            }
        },
        {
            time = 82,
            waitzombies = true,
            reward = false,
            finalWave = true,
            zombies = {
                {type="mummy_basic", line=1},
                {type="mummy_basic", line=2},
                {type="ra", line=3},
                {type="mummy_flag", line=4},
                {type="mummy_basic", line=5},
            }
        },
        {
            time = 90,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="mummy_basic", line=4},
            }
        }
    }
}
