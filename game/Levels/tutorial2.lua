return {
    damageThreshold = 160,
    timeThreshold   = 20,
    lines = 3,
    suns = 50,
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
        },
        {
            sprite = newAnimation(Resources.image("Sprites/Plants/Seeds/Seeds.png"), 35, 23),
            id = 2,
            type = 2,
            recharge = 5,
            startRecharge = 5,
            currentRecharge = 5,
            price = 50,
            rechargeQuad = love.graphics.newQuad(0, 0, 35, 23, 35, 23)
        }
    },

    waves = {
        {
            time = 16,
            waitzombies = false,
            reward = true,
            zombies = {
                {type="basic", line=2}
            }
        }
    }
}
