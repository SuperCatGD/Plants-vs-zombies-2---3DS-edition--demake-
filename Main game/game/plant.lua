local plant = {}
plant.__index = plant

local peashooterPFsound = Resources.sfx("Audio/SFX/PeashooterPlantFood.ogg")
local PFsoundEnd = Resources.sfx("Audio/SFX/PlantFoodEnd.ogg")
local SunsClass = require("suns")
local spudow = Resources.image("Sprites/Other/Spudow.png")
local visualobjectsInstances = {}

local pfEffectGround = newAnimation(Resources.image("Sprites/Other/PFeffectGround.png"), 40, 27)
local pfEffectBeam = Resources.image("Sprites/Other/PFeffectBeam.png")

local potatosplosionSound = Resources.sfx("Audio/SFX/potatosplosion.ogg")

local shadow = Resources.image("Sprites/Plants/Shadow.png")
local projectiles = require("projectiles")

local dirtPlanted = newAnimation(Resources.image("Sprites/Other/DirtPlanted.png"), 30, 14)

projectilesInstances = projectilesInstances or {}

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
    if self.type == 3 then
        self.life = 4000
    end
    self.anim = 1
    self.dirttimer = 0
    self.plantFood = false
    self.pfframe = 1
    self.pfscale = 0
    self.plantFoodState = 1

    self.timer = math.random(17, 19)
    if self.type == 4 then self.timer = 0 end

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

    if self.pfscale > 0 then

        love.graphics.draw(pfEffectGround.spriteSheet, pfEffectGround.quads[math.floor(self.pfframe)], self.x + scrollX + 105, self.y + 13, 0, self.pfscale, self.pfscale, 20, 13)
        love.graphics.draw(pfEffectBeam, self.x + scrollX + 105, self.y + 18, 0, self.pfscale, 1, 18, 56)

    end

    if self.type == 1 then

        love.graphics.draw(peashooterAnim.spriteSheet, peashooterAnim.quads[math.floor(self.frame)], self.x + scrollX + 105, self.y, 0, 1, 1, 18, 18)

    elseif self.type == 2 then

        if self.plantFood then

            love.graphics.draw(sunflowerAnim.spriteSheet, sunflowerAnim.quads[math.floor(self.frame)], self.x + scrollX + 105, self.y, 0, 1, 1, 15, 16)

        else

            if self.anim == 1 then

                love.graphics.draw(sunflowerAnim.spriteSheet, sunflowerAnim.quads[math.floor(math.cos(self.frame) * 5 + 7)], self.x + scrollX + 105, self.y, 0, 1, 1, 15, 16)

            else

                love.graphics.draw(sunflowerAnim.spriteSheet, sunflowerAnim.quads[math.floor(math.min(22, self.frame))], self.x + scrollX + 105, self.y, 0, 1, 1, 15, 16)

            end

        end

    elseif self.type == 3 then

        if self.life > 6000 then

            love.graphics.draw(wallnutAnim.spriteSheet, wallnutAnim.quads[15], self.x + scrollX + 105, self.y, 0, 1, 1, 12, 15)

        elseif self.life > 5000 then

            love.graphics.draw(wallnutAnim.spriteSheet, wallnutAnim.quads[16], self.x + scrollX + 105, self.y, 0, 1, 1, 12, 15)

        elseif self.life > 4000 then

            love.graphics.draw(wallnutAnim.spriteSheet, wallnutAnim.quads[17], self.x + scrollX + 105, self.y, 0, 1, 1, 12, 15)

        elseif self.life > 3000 then

            love.graphics.draw(wallnutAnim.spriteSheet, wallnutAnim.quads[1], self.x + scrollX + 105, self.y, 0, 1, 1, 12, 15)

        elseif self.life > 2000 then

            love.graphics.draw(wallnutAnim.spriteSheet, wallnutAnim.quads[4], self.x + scrollX + 105, self.y, 0, 1, 1, 12, 15)

        elseif self.life > 1000 then

            love.graphics.draw(wallnutAnim.spriteSheet, wallnutAnim.quads[7], self.x + scrollX + 105, self.y, 0, 1, 1, 12, 15)

        else

            love.graphics.draw(wallnutAnim.spriteSheet, wallnutAnim.quads[10], self.x + scrollX + 105, self.y, 0, 1, 1, 12, 15)

        end
        
    elseif self.type == 4 then

        love.graphics.draw(potatomineAnim.spriteSheet, potatomineAnim.quads[math.floor(self.frame)], self.x + scrollX + 105, self.y, 0, 1, 1, 16, 20)

    end
    love.graphics.setColor(1, 1, 1, math.min(1, math.max(3 - math.min(3, self.dirttimer), 0)))

    if self.dirttimer < 3 then
        
        love.graphics.draw(dirtPlanted.spriteSheet, dirtPlanted.quads[math.floor(math.min(12, self.dirtframe))], self.x + scrollX + 105, self.y + 24, 0, 1, 1, 18, 18)

    end

    love.graphics.setColor(1, 1, 1, 1)
end

function plant:update(dt)

    self.pfframe = self.pfframe + dt * 12
    if self.pfframe > 4 then

        self.pfframe = 1

    end

    if self.plantFood == true and self.pfscale < 1 then

        self.pfscale = self.pfscale + dt * 3

    elseif self.plantFood == false and self.pfscale > 0 then

        self.pfscale = self.pfscale - dt * 3

    end

    if self.pfscale > 1 then

        self.pfscale = 1

    elseif self.pfscale < 0 then

        self.pfscale = 0

    end

    self.dirttimer = self.dirttimer + dt

    self.timer = self.timer + dt

    if self.type == 1 then

        self.frame = self.frame + dt * 14.5

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

        if self.plantFood == true then

            if self.plantFood then

                self.frame = self.frame + dt * 6

                if self.plantFoodState == 1 and self.frame < 33 then

                    self.frame = 33

                    peashooterPFsound:stop()
                    peashooterPFsound:play()

                    spawnPFpea(
                        self.x,
                        self.y,
                        self.line
                    )

                elseif self.frame > 39.4 then

                    if self.plantFoodState <= 3 then

                        spawnPFpea(
                            self.x,
                            self.y,
                            self.line
                        )

                    elseif self.plantFoodState > 5 then

                        peashooterPFsound:stop()
                        PFsoundEnd:play()

                        self.plantFood = false

                        return
                    end

                    self.frame = 33
                    self.plantFoodState =
                        self.plantFoodState + 1
                end
            end

        else

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
        
        end

    elseif self.type == 2 then

        if self.plantFood == true then

            if self.plantFoodState == 1 then
                
                self.frame = 23
                self.plantFoodState = 2

            elseif self.plantFoodState <= 4 then

                self.frame = self.frame + dt * 12

                if self.frame >= 25 then

                    self.frame = 23
                    self.timer = -8
                    self.plantFoodState = self.plantFoodState + 1
                    table.insert(sunsInstances, SunsClass:newJumping(self.x, self.y))
                
                end

            else

                self.plantFood = false

            end

        else

            if self.timer >= 23 then

                if self.frame >= 23 then
                    self.frame = 13
                end

                self.anim = 2

            end

            if math.floor(self.frame) == 19 and self.timer > 10 then

                table.insert(sunsInstances, SunsClass:newJumping(self.x, self.y))

                self.timer = -8

            end

            if math.floor(self.frame) > 21 and self.anim == 2 then

                self.anim = 1

            end

        end

    elseif self.type == 3 then

        if self.plantFood == true then

            self.life = 7000
            self.plantFoodState = self.plantFoodState + dt

        end
        if self.plantFoodState > 2 then

            self.plantFood = false

        end

    elseif self.type == 4 then

        if self.anim == 1 then

            if self.timer > 18 then

                if self.frame < 6 then

                    self.frame = self.frame + dt * 8

                end

                for _, s in ipairs(zombiesInstances[self.line]) do

                    if s.x < self.x + 20 and s.x > self.x - 20 then

                        self.anim = 2

                    end

                end

            end

        else

            self.frame = self.frame + dt * 8
            if self.frame > 12.7 then

                for _, s in ipairs(zombiesInstances[self.line]) do

                    if s.x < self.x + 20 and s.x > self.x - 20 then

                        s.life = 0

                    end

                end

                spawnPotatosplosion(self.x, self.y)
                self:remove()

            end
            
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

function spawnPFpea(x, y, line)

    projectiles:new("PFpea", x, y, line)

end

function drawPotatosplosion()

    for i, p in ipairs(visualobjectsInstances) do

        love.graphics.draw(spudow, p.x + p.shake + scrollX + 105, p.y, 0, 1, 1, 39, 62)

    end

end

function updatePotatosplosion(dt)

    for i, p in ipairs(visualobjectsInstances) do

        p.time = p.time + dt
        if p.time > 0.048 then

            p.time = 0
            p.shake = p.shake * -0.9

            if p.shake < 0.2 and p.shake > -0.2 then

                table.remove(visualobjectsInstances, i)

            end

        end

    end

end

function spawnPotatosplosion(x, y)

    potatosplosionSound:play()

    local spudowinstance = {}
    spudowinstance.x = x
    spudowinstance.y = y
    spudowinstance.shake = 3
    spudowinstance.time = 0

    table.insert(visualobjectsInstances, spudowinstance)

end

return plant