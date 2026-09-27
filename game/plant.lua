local plant = {}
plant.__index = plant

local SunsClass = require("suns")

local shadow = Resources.image("Sprites/Plants/Shadow.png")
local projectiles = require("projectiles")

local dirtPlanted = newAnimation(Resources.image("Sprites/Other/DirtPlanted.png"), 30, 14)

projectilesInstances = {}

function plant:new(type, x, y)

    local self = setmetatable({}, plant)

    self.dirtDuration = 2

    self.x = x
    self.y = y

    self.line = math.floor((y - 10) / 37)
    
    self.type = type
    self.frame = 1
    self.dirtframe = 1
    self.life = 300
    self.anim = 1
    self.dirttimer = 0

    self.timer = math.random(17, 19)

    self.throwed = false

    self.index = #plantInstances[self.line] + 1
    plantInstances[self.line][self.index] = self

    return self

end

function plant:draw()

    if show_shadows then

        love.graphics.setColor(1,1,1,0.5)
        love.graphics.draw(shadow, self.x + 5 + scrollX + 105, self.y + 26, 0, 1, 1, 18, 18)
        love.graphics.setColor(1,1,1,1)

    end

    if self.type == 1 then

        love.graphics.draw(peashooterAnim.spriteSheet, peashooterAnim.quads[math.floor(self.frame)], self.x + scrollX + 105, self.y, 0, 1, 1, 18, 18)

    elseif self.type == 2 then

        if self.anim == 1 then

            love.graphics.draw(sunflowerAnim.spriteSheet, sunflowerAnim.quads[math.floor(math.cos(self.frame) * 5 + 7)], self.x + scrollX + 105, self.y, 0, 1, 1, 15, 16)

        else

            love.graphics.draw(sunflowerAnim.spriteSheet, sunflowerAnim.quads[math.floor(math.min(22, self.frame))], self.x + scrollX + 105, self.y, 0, 1, 1, 15, 16)

        end

    end
    love.graphics.setColor(1, 1, 1, math.min(1, math.max(3 - math.min(3, self.dirttimer), 0)))

    if self.dirttimer < 3 then
        
        love.graphics.draw(dirtPlanted.spriteSheet, dirtPlanted.quads[math.floor(math.min(12, self.dirtframe))], self.x + scrollX + 105, self.y + 24, 0, 1, 1, 18, 18)

    end

    love.graphics.setColor(1, 1, 1, 1)
end

function plant:update(dt)

    self.dirttimer = self.dirttimer + dt

    self.timer = self.timer + dt

    if self.type == 1 then

        self.frame = self.frame + dt * 13

    elseif self.type == 2 then

        self.frame = self.frame + dt * 2

        if self.anim == 2 then

            self.frame = self.frame + dt * 4

        end

    end

    self.dirtframe = self.dirtframe + dt * 17

    if self.life <= 0 then

        self:remove()

    end

    if self.type == 1 then

        if zombiesInstances[self.line] then

            if #zombiesInstances[self.line] > 0 then

                if self.frame >= 32 then

                    self.frame = 12

                end

                if math.floor(self.frame) == 25 and self.throwed == false then

                    spawnPea(self.x, self.y, self.line)

                    self.throwed = true

                end

                if math.floor(self.frame) == 27 then

                    self.throwed = false

                end

            else

                if math.floor(self.frame) == 16 then

                    self.frame = 1

                end

                if self.frame >= 32 then

                    self.frame = math.random(10, 12)

                end
                
                if math.floor(self.frame) == 25 and self.throwed == false then

                    spawnPea(self.x, self.y, self.line)

                    self.throwed = true

                end

                if math.floor(self.frame) == 27 then

                    self.throwed = false

                end

            end

        else

            if math.floor(self.frame) == 16 then

                self.frame = 1

            end

            if self.frame >= 32 then

                self.frame = math.random(10, 12)

            end

        end

    elseif self.type == 2 then

        if self.timer >= 23 then

            if self.frame >= 23 then
                self.frame = 13
            end

            self.anim = 2

        end

        if math.floor(self.frame) == 19 then

            table.insert(sunsInstances, SunsClass:newJumping(self.x, self.y))

            self.timer = -4
            self.frame = 20

        end

        if math.floor(self.frame) > 21 and self.anim == 2 then

            self.anim = 1

        end

    end
    
end

function plant:remove()

    local plants = plantInstances[self.line]

    local index = self.index
    local lastIndex = #plants

    -- Remplace le corpse supprimé par le dernier
    if index ~= lastIndex then
        local last = plants[lastIndex]

        plants[index] = last
        last.index = index
    end

    plants[lastIndex] = nil
end

function spawnPea(x, y, line)

    projectiles:new("pea", x, y, line)

end

return plant