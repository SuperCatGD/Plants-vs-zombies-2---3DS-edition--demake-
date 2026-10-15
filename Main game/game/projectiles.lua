local projectiles = {}
projectiles.__index = projectiles

local throwSounds = {
    Resources.sfx("Audio/SFX/Throw.ogg"),
    Resources.sfx("Audio/SFX/Throw2.ogg")
}

local pea = Resources.image(
    "Sprites/Plants/Projectiles/Pea.png"
)

local shadow = Resources.image(
    "Sprites/Plants/Projectiles/Shadow.png"
)

local PlantfoodPea = Resources.image(
    "Sprites/Plants/Projectiles/PlantFoodPea.png"
)

-- Un seul Quad réutilisé pour l'animation Plant Food.
local plantFoodQuad = love.graphics.newQuad(0, 0, 1, 16, 120, 16)

local SplashClass = require("splash")

splashesInstances = splashesInstances or {}
projectilesInstances = projectilesInstances or {}


function projectiles:new(type, x, y, line)

    local self = setmetatable({}, projectiles)

    self.type = type

    self.x = x + 8
    if self.type == "PFpea" then
        self.x = x + 18
    end
    self.y = y - 5

    self.line = line

    self.indsize = 8
    self.show = 1

    -- Projectile normal
    self.number = 1

    -- Projectile Plant Food
    self.pfHits = 0
    self.pfMaxHits = 15

    self.removed = false

    self.basex = self.x

    -- Ajout dans la liste
    self.index = #projectilesInstances + 1
    projectilesInstances[self.index] = self

    -- Son uniquement pour un tir normal
    local soundIndex = math.random(1, #throwSounds)
    local sound = throwSounds[soundIndex]

    if sound then
        sound:stop()
        sound:play()
    end

    return self
end


--------------------------------------------------
-- DRAW
--------------------------------------------------

function projectiles:draw()

    if self.removed then
        return
    end

    --------------------------------------------------
    -- PLANT FOOD
    --------------------------------------------------

    if self.type == "PFpea" then

        -- Animation du groupe de pois
        if self.x > self.basex and self.show < 15 then
            self.show = self.show + 1
            self.basex = self.basex + self.indsize
        end

        local offset = (self.show - 1) * 8

        local startX = 120 - offset

        local width = 120 - startX

        -- Protection contre les valeurs invalides
        if startX < 0 then
            startX = 0
        end

        if startX >= 120 then
            startX = 119
        end

        if width < 1 then
            width = 1
        end

        if width > 120 - startX then
            width = 120 - startX
        end

        plantFoodQuad:setViewport(
            startX,
            0,
            width,
            16,
            120,
            16
        )

        love.graphics.draw(
            PlantfoodPea,
            plantFoodQuad,
            self.x - offset,
            self.y,
            0,
            1,
            1,
            3,
            3
        )

        return
    end


    --------------------------------------------------
    -- PROJECTILE NORMAL
    --------------------------------------------------

    if show_shadows then

        love.graphics.setColor(
            1,
            1,
            1,
            0.5
        )

        love.graphics.draw(
            shadow,
            self.x + 4,
            self.y + 18,
            0,
            1,
            1,
            3,
            3
        )

        love.graphics.setColor(
            1,
            1,
            1,
            1
        )

    end

    love.graphics.draw(
        pea,
        self.x,
        self.y,
        0,
        1,
        1,
        3,
        3
    )
end


--------------------------------------------------
-- REMOVE
--------------------------------------------------

function projectiles:remove()

    if self.removed then
        return
    end

    self.removed = true

    local list = projectilesInstances

    if not list then
        return
    end

    local index = self.index
    local lastIndex = #list

    if not index then
        return
    end

    if index < 1 or index > lastIndex then
        self.index = nil
        return
    end

    if index ~= lastIndex then

        local last = list[lastIndex]

        list[index] = last

        if last then
            last.index = index
        end
    end

    list[lastIndex] = nil

    self.index = nil
end


--------------------------------------------------
-- UPDATE
--------------------------------------------------

function projectiles:update(dt)

    if self.removed then
        return
    end

    self.x = self.x + 140 * dt

    local allZombies = zombiesInstances

    if allZombies then

        local zombies = allZombies[self.line]

        if zombies then

            for i = #zombies, 1, -1 do

                local z = zombies[i]

                if z and not z.removed then

                    if self.x > z.x - 15
                    and self.x < z.x + 15 then

                        --------------------------------------------------
                        -- DÉGÂTS
                        --------------------------------------------------

                        if type(z.life) == "number" then
                            z.life = z.life - 20
                        end


                        --------------------------------------------------
                        -- SPLASH
                        --------------------------------------------------

                        if z.type == "conehead" then

                            SplashClass:new(
                                self.x,
                                self.y,
                                2
                            )
                        elseif z.type == "buckethead" then

                            SplashClass:new(
                                self.x,
                                self.y,
                                3
                            )

                        else

                            SplashClass:new(
                                self.x,
                                self.y,
                                1
                            )

                        end

                        --------------------------------------------------
                        -- PLANT FOOD
                        --------------------------------------------------

                        if self.type == "PFpea" then

                            self.pfHits = self.pfHits + 1

                            -- Petit recul après impact
                            self.x = self.x - self.indsize

                            -- Après 15 impacts, suppression
                            if self.pfHits >= self.pfMaxHits then
                                self:remove()
                            end

                        else

                            --------------------------------------------------
                            -- POIS NORMAL
                            --------------------------------------------------

                            self:remove()

                        end

                        return
                    end
                end
            end
        end
    end


    --------------------------------------------------
    -- SORTIE DE L'ÉCRAN
    --------------------------------------------------

    if self.x > 420 then
        self:remove()
        return
    end
end


return projectiles