return {
    damageThreshold = 180,
    timeThreshold = 20,
    lines = 5,
    suns = 50,

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
            reward = false,
            zombies = {
                {type="basic", line=1},
            }
        },
        {
            time = 29,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=5},
            }
        },
        {
            time = 39,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=3},
            }
        },
        {
            time = 47,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=1},
                {type="basic", line=4},
            }
        },
        {
            time = 55,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=2},
            }
        },
        {
            time = 55,
            waitzombies = true,
            reward = false,
            zombies = {
                {type="flag", line=1},
                {type="basic", line=2},
                {type="basic", line=3},
                {type="basic", line=4},
                {type="conehead", line=5},
            }
        },
        {
            time = 68,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=1},
                {type="basic", line=3},
            }
        },
        {
            time = 74,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="conehead", line=2},
                {type="basic", line=5},
            }
        },
        {
            time = 75,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=1},
                {type="basic", line=5},
            }
        },
        {
            time = 81,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=1},
                {type="basic", line=3},
            }
        },
        {
            time = 83,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=2},
                {type="basic", line=5},
            }
        },
        {
            time = 100,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="conehead", line=1},
                {type="conehead", line=3},
                {type="basic", line=5},
            }
        },
        {
            time = 101,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=2},
                {type="basic", line=4},
            }
        },
        {
            time = 103,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=1},
                {type="basic", line=5},
            }
        },
        {
            time = 124,
            waitzombies = true,
            reward = false,
            zombies = {
                {type="flag", line=1},
                {type="conehead", line=2},
                {type="basic", line=3},
                {type="conehead", line=4},
                {type="basic", line=5},
            }
        },
        {
            time = 125,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=1},
                {type="basic", line=3},
                {type="basic", line=5},
            }
        },
        {
            time = 126,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=2},
                {type="basic", line=4},
            }
        },
        {
            time = 150,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=1},
                {type="basic", line=3},
                {type="conehead", line=5},
            }
        },
        {
            time = 153,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="conehead", line=2},
                {type="basic", line=4},
            }
        },
        {
            time = 170,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=1},
                {type="basic", line=2},
                {type="basic", line=3},
                {type="basic", line=4},
                {type="conehead", line=5},
            }
        },
        {
            time = 173,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="conehead", line=1},
                {type="basic", line=2},
                {type="basic", line=3},
                {type="basic", line=5},
            }
        },
        {
            time = 190,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=1},
                {type="basic", line=2},
                {type="conehead", line=3},
                {type="conehead", line=4},
                {type="basic", line=5},
            }
        },
        {
            time = 191,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="basic", line=1},
            }
        },
        {
            time = 212,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="conehead", line=1},
                {type="conehead", line=3},
            }
        },
        {
            time = 222,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="conehead", line=5},
            }
        },
        {
            time = 223,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="conehead", line=2},
            }
        },
        {
            time = 224,
            waitzombies = false,
            reward = false,
            zombies = {
                {type="buckethead", line=4},
            }
        },
        {
            time = 245,
            waitzombies = true,
            reward = false,
            finalWave = true,
            zombies = {
                {type="conehead", line=1},
                {type="conehead", line=2},
                {type="flag", line=3},
                {type="buckethead", line=4},
                {type="conehead", line=5},
            }
        },
        {
            time = 246,
            waitzombies = false,
            reward = true,
            zombies = {
                {type="basic", line=1},
                {type="basic", line=2},
                {type="conehead", line=3},
                {type="basic", line=4},
                {type="basic", line=5},
            }
        }
    }
}
