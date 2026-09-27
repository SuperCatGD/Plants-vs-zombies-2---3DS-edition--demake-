local Suns = {}
Suns.__index = Suns

local SunSound = Resources.sfx("Audio/SFX/Sun.ogg", "static")

local sunRays = Resources.image("Sprites/Other/SunRays.png")
local sunCenter = Resources.image("Sprites/Other/SunCenter.png")

-- Crée un soleil qui tombe du ciel
function Suns:newFalling(x)
    return setmetatable({
        x = x,
        y = -50,
        speed = 60,
        targetY = math.random(100, 200),
        collected = false,
        timer = 0,
        lifetime = 12,
        mode = "fall",
        rotation = 0,
        value = 50,

        -- interpolation
        collectX = 11,
        collectY = 11,
        scale = 1,
        collectSpeed = 5
    }, Suns)
end

-- Crée un soleil qui saute (tournesol)
function Suns:newJumping(x, y)
    return setmetatable({
        x = x,
        y = y,
        vy = -150,
        gravity = 500,
        speed = 60,
        targetY = y,
        collected = false,
        timer = 0,
        lifetime = 12,
        mode = "jump",
        rotation = 0,
        value = 50,

        -- interpolation
        collectX = 11,
        collectY = 11,
        scale = 1,
        collectSpeed = 5
    }, Suns)
end

function Suns:update(dt)
    if self.collected then 
    
        for i, v in ipairs(sunsInstances) do

            if v == self then

                table.remove(sunsInstances, i)

            end

        end
    
    end
    self.rotation = self.rotation + dt

    self.timer = self.timer + dt
    if self.timer >= self.lifetime then
        self.collected = true
        return
    end

    if self.mode == "fall" then
        -- chute jusqu'à targetY
        if self.y < self.targetY then
            self.y = self.y + self.speed * dt
            if self.y > self.targetY then
                self.y = self.targetY
            end
        end

    elseif self.mode == "jump" then
        -- mouvement de saut
        self.vy = self.vy + self.gravity * dt
        self.y = self.y + self.vy * dt

        -- stoppe le soleil au sol
        if self.y > self.targetY then
            self.y = self.targetY
            self.vy = 0
        end
    elseif self.mode == "collectAnim" then
        -- interpolation position
        self.x = self.x + (self.collectX - self.x) * dt * self.collectSpeed
        self.y = self.y + (self.collectY - self.y) * dt * self.collectSpeed

        -- shrink
        if self.x < 16 then
            self.scale = self.scale - dt * 3
        end
        if self.scale < 0 then self.scale = 0 end

        -- disparition quand proche du point
        local dx = self.collectX - self.x
        local dy = self.collectY - self.y
        if dx*dx + dy*dy < 1 then
            self.collected = true
        end

        return
    end
end

function Suns:draw()
    if self.collected then return end

    local trueScale = self.scale * (self.value / 100)

    love.graphics.draw(sunRays, self.x, self.y, self.rotation, trueScale, trueScale, 32, 32)
    love.graphics.draw(sunCenter, self.x, self.y, 0, trueScale + math.cos(self.rotation) / 16, trueScale + math.cos(self.rotation) / 16, 14, 14)
end

-- Détection de ramassage
function Suns:tryCollect(mx, my)
    if self.collected then return false end
    if self.mode == "collectAnim" then return false end

    local dx = mx - self.x
    local dy = my - self.y
    if dx*dx + dy*dy <= 25*25 then
        SunSound:play()
        self.mode = "collectAnim"
        return true
    end

    return false
end

return Suns