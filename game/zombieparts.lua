local corpse = {}
corpse.__index = corpse

local shadow = love.graphics.newImage("Sprites/Zombies/Shadow.png")

local limbsPop = love.audio.newSource("Audio/SFX/LimbsPop.ogg", "static")

local basiccorpse = newAnimation(
    love.graphics.newImage("Sprites/Zombies/basicCorpse.png"),
    54,
    44
)

local head = love.graphics.newImage("Sprites/Zombies/ZombieHead.png")
local arm = love.graphics.newImage("Sprites/Zombies/ZombieArm.png")

corpsesInstances = {
    {},
    {},
    {},
    {},
    {}
}

function corpse:new(type, x, y)

    if type > 1 and type < 4 then

        limbsPop:play()

    end

    local self = setmetatable({}, corpse)

    self.vy = -7
    self.vx = math.random(3, 6)
    self.time = 0

    self.x = x
    self.y = y * 37 + 40
    self.line = y

    if type == 3 then
        self.vx = 0
        self.vy = 1
        self.y = y * 37 + 32
    end

    if type == 2 then
        self.y = y * 37 + 3
    end

    self.rotation = 0

    self.frame = 1
    self.type = type

    -- Index du corpse dans sa ligne
    self.index = #corpsesInstances[self.line] + 1
    corpsesInstances[self.line][self.index] = self

    return self
end

function corpse:remove()

    local corpses = corpsesInstances[self.line]

    local index = self.index
    local lastIndex = #corpses

    -- Remplace le corpse supprimé par le dernier
    if index ~= lastIndex then
        local last = corpses[lastIndex]

        corpses[index] = last
        last.index = index
    end

    corpses[lastIndex] = nil
end

function corpse:update(dt)
    
    self.time = self.time + dt

    if self.type == 1 then

        -- Animation
        self.frame = self.frame + 11 * dt

        if self.frame > 18 then
            self:remove()
        end

    elseif self.type == 2 then

        self.vy = self.vy + 1 * dt * 30
        if self.y > self.line * 37 + 40 then
            self.vy = 0
            self.vx = 0
        else
            self.rotation = self.rotation + self.vx * dt
        end
        self.y = self.y + self.vy * dt * 8
        self.x = self.x + self.vx * dt * 8
        if self.time > 1.5 then
            self:remove()
        end

    elseif self.type == 3 then

        self.vy = self.vy + 1 * dt * 70
        if self.y > self.line * 37 + 50 then
            self.vy = 0
        else
            self.rotation = self.rotation + dt * 6
        end
        self.y = self.y + self.vy * dt * 6
        self.x = self.x + self.vx * dt * 8
        if self.time > 1.5 then
            self:remove()
        end

    end

end

function corpse:draw()

    if self.type == 1 then
        if show_shadows then
            love.graphics.setColor(1,1,1,0.5)
            love.graphics.draw(shadow, self.x + 10, self.y + 32, 0, 1, 1, 21, 42)
            love.graphics.setColor(1,1,1,1)
        end
        love.graphics.draw(
            basiccorpse.spriteSheet,
            basiccorpse.quads[math.floor(self.frame)],
            self.x,
            self.y,
            0,
            1,
            1,
            17,
            32
        )

    elseif self.type == 2 then

        love.graphics.draw(
            head,
            self.x,
            self.y,
            self.rotation,
            1,
            1,
            10,
            10
        )

    elseif self.type == 3 then

        love.graphics.draw(
            arm,
            self.x,
            self.y,
            self.rotation,
            1,
            1,
            4,
            9
        )

    end

end

function SpawnPart(type, x, line)

    corpse:new(type, x, line)

end

return corpse