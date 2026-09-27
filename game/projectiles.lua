local projectiles = {}
projectiles.__index = projectiles

local throwSounds = {
    love.audio.newSource("Audio/SFX/Throw.ogg", "static"),
    love.audio.newSource("Audio/SFX/Throw2.ogg", "static")
}

local pea = Resources.image("Sprites/Plants/Projectiles/Pea.png")
local shadow = Resources.image("Sprites/Plants/Projectiles/Shadow.png")

local SplashClass = require("splash")

splashesInstances = {}

function projectiles:new(type, x, y, line)

    local self = setmetatable({}, projectiles)

    self.x = x + 9
    self.y = y - 5
    self.type = type
    self.line = line

    -- Index dans projectilesInstances
    self.index = #projectilesInstances + 1
    projectilesInstances[self.index] = self


    local random = math.random(1, 2)
    throwSounds[random]:stop()
    throwSounds[random]:play()

    return self
end

function projectiles:draw()
    if show_shadows then

        love.graphics.setColor(1,1,1,0.5)
        love.graphics.draw(shadow, self.x + 4, self.y + 18, 0, 1, 1, 3, 3)
        love.graphics.setColor(1,1,1,1)

    end
    love.graphics.draw(pea, self.x, self.y, 0, 1, 1, 3, 3)
end

function projectiles:remove()

    local index = self.index
    local lastIndex = #projectilesInstances

    -- Si ce n'est pas le dernier projectile,
    -- on déplace le dernier à sa place.
    if index ~= lastIndex then
        local last = projectilesInstances[lastIndex]

        projectilesInstances[index] = last
        last.index = index
    end

    projectilesInstances[lastIndex] = nil
end

function projectiles:update(dt)

    -- Déplacement
    self.x = self.x + 140 * dt

    -- Collision avec les zombies de la même ligne
    local zombies = zombiesInstances[self.line]

    if zombies then
        for _, z in ipairs(zombies) do
            if self.x > z.x - 15 then

                -- Dégâts
                z.life = z.life - 20

                -- Splash à la position de l'impact
                SplashClass:new(
                    self.x,
                    self.y
                )

                -- Supprime le projectile
                self:remove()

                return
            end
        end
    end

    -- Sortie de l'écran
    if self.x > 420 then
        self:remove()
        return
    end
end

return projectiles