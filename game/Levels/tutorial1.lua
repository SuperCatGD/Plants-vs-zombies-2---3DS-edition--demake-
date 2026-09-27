return {
    damageThreshold = 160,
    timeThreshold   = 20,
    lines = 1,
    suns = 100

    seeds = { 
        {
            sprite = newAnimation(Resources.image("Sprites/Plants/Seeds/Seeds.png"), 35, 23),
            id = 1,
            type = 1,
            recharge = 5,
            startRecharge = 5,
            currentRecharge = 0,
            price = 100,
            rechargeQuad = love.graphics.newQuad(0, 0, 35, 23, 35, 23)
        }
    },

    waves = {
        {
            time = 2,
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
            time = 8.5,
            waitzombies = true,
            reward = false,
            zombies = {
                {type="flag", line=3}
            }
        },
        {
            time = 9,
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
            time = 13,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=3}
            }
        },
        {
            time = 15,
            waitzombies = false,
            reward = true,
            zombies = {
                {type="basic", line=3}
            }
        }
    }
}
