local zombie = {}
zombie.__index = zombie

basicZombie = newAnimation(
    Resources.image("Sprites/Zombies/basic.png"),
    43,
    52
)
flagZombie = newAnimation(
    Resources.image("Sprites/Zombies/basic_flag.png"),
    56,
    73
)
cones = {
    Resources.image("Sprites/Zombies/Cone.png"),
    Resources.image("Sprites/Zombies/Cone2.png"),
    Resources.image("Sprites/Zombies/Cone3.png")
}

buckets = {
    Resources.image("Sprites/Zombies/Bucket.png"),
    Resources.image("Sprites/Zombies/Bucket2.png"),
    Resources.image("Sprites/Zombies/Bucket3.png")
}

protection_position_values = {
    {posX = -3, posY = -17},
    {posX = -3, posY = -17},
    {posX = -3, posY = -17},
    {posX = -4, posY = -17},
    {posX = -4, posY = -16},
    {posX = -5, posY = -16},
    {posX = -5, posY = -15},
    {posX = -5, posY = -15},
    {posX = -5, posY = -14},
    {posX = -5, posY = -14},
    {posX = -5, posY = -14},
    {posX = -5, posY = -15},
    {posX = -4, posY = -15},
    {posX = -4, posY = -16},
    {posX = -3, posY = -16},
    {posX = -3, posY = -17},
    {posX = -3, posY = -17},
    {posX = -3, posY = -17},
    {posX = -3, posY = -17},
    {posX = -4, posY = -17},
    {posX = -5, posY = -16},
    {posX = -6, posY = -16},
    {posX = -6, posY = -14},
    {posX = -7, posY = -12},
    {posX = -7, posY = -10},
    {posX = -7, posY = -10},
    {posX = -8, posY = -9},
    {posX = -8, posY = -10},
    {posX = -7, posY = -12},
    {posX = -6, posY = -13},
    {posX = -6, posY = -14},
    {posX = -5, posY = -14},
    {posX = -4, posY = -15},
    {posX = -3, posY = -15},
    {posX = -3, posY = -16},
    {posX = -3, posY = -16},
    {posX = -2, posY = -16},
    {posX = -1, posY = -16},
    {posX = -1, posY = -16},
    {posX = -2, posY = -16},
    {posX = -3, posY = -15},
    {posX = -4, posY = -15},
    {posX = -4, posY = -15},
    {posX = -4, posY = -15},
    {posX = -4, posY = -15},
    {posX = -4, posY = -16},
    {posX = -3, posY = -16},
    {posX = -3, posY = -16},
    {posX = -3, posY = -16},
    {posX = -2, posY = -17},
    {posX = -1, posY = -17},
    {posX = 0, posY = -17},
    {posX = 0, posY = -17},
    {posX = -1, posY = -16},
    {posX = -3, posY = -15},
    {posX = -4, posY = -15},
    {posX = -4, posY = -15},
    {posX = -4, posY = -15},
    {posX = -4, posY = -16},
    {posX = -4, posY = -16},
    {posX = -3, posY = -16},
    {posX = -3, posY = -16},
    {posX = -2, posY = -17},
    {posX = 0, posY = -17},
    {posX = 0, posY = -17},
    {posX = -1, posY = -16},
    {posX = -3, posY = -16},
    {posX = -5, posY = -15},
    {posX = -5, posY = -15},
    {posX = -4, posY = -16},
    {posX = -3, posY = -16},
}

local shadow = Resources.image("Sprites/Zombies/Shadow.png")
local corpseClass = require("zombieparts")

local eatSound = Resources.sfx("Audio/SFX/Eat.ogg", "static")
local glupSound = Resources.sfx("Audio/SFX/Glup.ogg", "static")

function zombie:new(type, x, y)

    local self = setmetatable({}, zombie)

    self.x = x
    self.y = y * 37 + 40
    self.line = y
    self.arm = true

    self.life = 190
    self.type = type
    if self.type == "conehead" then
        self.life = 560
    end
    if self.type == "buckethead" then
        self.life = 1370
    end
    self.eating_state = 1
    self.state = 1
    self.frame = 19

    -- Index du zombie dans sa ligne
    self.index = #zombiesInstances[self.line] + 1
    zombiesInstances[self.line][self.index] = self

    return self
end

function zombie:remove()

    local zombies = zombiesInstances[self.line]

    local index = self.index
    local lastIndex = #zombies

    -- Remplace le zombie supprimé par le dernier
    if index ~= lastIndex then
        local last = zombies[lastIndex]

        zombies[index] = last
        last.index = index
    end

    zombies[lastIndex] = nil
end

function zombie:update(dt)

    if self.x < 29 then
        triggerLose()
    end

    if checkMower(self.line, self.x, dt) == true then
        self.life = 0
    end

    if checkPlant(self.line, self.x, dt) == true then
        self.state = 2
        if self.frame < 35 then
            self.frame = 35
        end
    else
        self.state = 1
    end
    
    if self.life <= 190 and self.type ~= "basic" then

        self.type = "basic"

    end

    if self.life <= 100 and self.arm == true then
        SpawnPart(3, self.x, self.line)
        self.arm = false
        return
    end

    -- Zombie mort
    if self.life <= 0 then
        SpawnPart(1, self.x, self.line)
        SpawnPart(2, self.x, self.line)
        self:remove()
        return
    end

    if self.state == 1 then
        -- Déplacement
        if self.x > 395 then
            self.x = self.x - 8 * dt
        else
            self.x = self.x - 4 * dt
        end
        -- Animation de marche

        if self.type == "basic" or self.type == "conehead" or self.type == "buckethead" then
            self.frame = self.frame + 5 * dt
            if self.frame > 34 then
                self.frame = 19
            end
        elseif self.type == "flag" then
            self.frame = self.frame + 5 * dt
            if self.frame > 34 then
                self.frame = 17
            end
        end
    elseif self.state == 2 then
        if self.type == "basic" or self.type == "conehead" or self.type == "buckethead" then
            -- Animation d'attaque
            self.frame = self.frame + 6 * dt
            if self.eating_state == 1 then
                if self.frame > 44 then
                    self.eating_state = 2
                end
            elseif self.eating_state >= 2 and self.eating_state <= 4 then
                if self.frame > 58 then
                    if self.eating_state < 4 then
                        self.frame = 45
                    end
                    self.eating_state = self.eating_state + 1
                end
            else
                if self.frame > 71 then
                    self.frame = 35
                    self.eating_state = 1
                end
            end
        elseif self.type == "flag" then
            if self.frame > 59 then
                self.frame = 35
            end
        end
    end
end

function zombie:draw()

    if show_shadows then
        love.graphics.setColor(1,1,1,0.5)
        love.graphics.draw(shadow, self.x + 10, self.y + 32, 0, 1, 1, 21, 42)
        love.graphics.setColor(1,1,1,1)
    end
    if self.type == "basic" or self.type == "conehead" or self.type == "buckethead" then
        love.graphics.draw(
            basicZombie.spriteSheet,
            basicZombie.quads[math.floor(self.frame)],
            self.x,
            self.y,
            0,
            1,
            1,
            21,
            42
        )
        if self.type == "conehead" then
            if self.life > 190 then
                if self.life >= 410 then
                    love.graphics.draw(cones[1], self.x + protection_position_values[math.floor(self.frame)].posX, self.y + protection_position_values[math.floor(self.frame)].posY, 0, 1, 1, 20, 43)
                elseif self.life >= 280 then
                    love.graphics.draw(cones[2], self.x + protection_position_values[math.floor(self.frame)].posX, self.y + protection_position_values[math.floor(self.frame)].posY, 0, 1, 1, 20, 43)
                else
                    love.graphics.draw(cones[3], self.x + protection_position_values[math.floor(self.frame)].posX, self.y + protection_position_values[math.floor(self.frame)].posY, 0, 1, 1, 20, 43)
                end
            end
        elseif self.type == "buckethead" then
            if self.life > 190 then
                if self.life >= 940 then
                    love.graphics.draw(buckets[1], self.x + protection_position_values[math.floor(self.frame)].posX, self.y + protection_position_values[math.floor(self.frame)].posY, 0, 1, 1, 20, 43)
                elseif self.life >= 510 then
                    love.graphics.draw(buckets[2], self.x + protection_position_values[math.floor(self.frame)].posX, self.y + protection_position_values[math.floor(self.frame)].posY, 0, 1, 1, 20, 43)
                else
                    love.graphics.draw(buckets[3], self.x + protection_position_values[math.floor(self.frame)].posX, self.y + protection_position_values[math.floor(self.frame)].posY, 0, 1, 1, 20, 43)
                end
            end
        end
    elseif self.type == "flag" then
        love.graphics.draw(
            flagZombie.spriteSheet,
            flagZombie.quads[math.floor(self.frame)],
            self.x,
            self.y,
            0,
            1,
            1,
            34,
            63
        )
    end
end

function SpawnZombie(type, line)

    zombie:new(type, 350, line)

end

function checkPlant(line, x, dt)
    
    if x < 58 then

        return false

    end

    local plant = plantInstances[line]

    if plant then
        for _, p in ipairs(plant) do
            if x < p.x + 15 then

                if not eatSound:isPlaying() then

                    eatSound:play()

                end

                p.life = p.life - 90 * dt

                if p.life <= 0 then
                    glupSound:stop()
                    glupSound:play()
                end

                return true
            end
        end
    end

    return false
end

function checkMower(line, x, dt)

    local mower = lawnmowers

    if mower then
        for _, p in ipairs(mower) do
            if x < p.x + 15 and p.line == line then
                p.activated = true
                return true
            end
        end
    end

    return false
end

return zombie