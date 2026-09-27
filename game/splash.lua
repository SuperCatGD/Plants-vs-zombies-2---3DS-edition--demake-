local splash = {}
splash.__index = splash

local splatSounds = {
    Resources.sfx("Audio/SFX/Splat.ogg", "static"),
    Resources.sfx("Audio/SFX/Splat2.ogg", "static"),
    Resources.sfx("Audio/SFX/Splat3.ogg", "static")
}

local splashAnim = newAnimation(
    Resources.image("Sprites/Plants/Projectiles/PeaSplat.png"),
    32,
    19
)

function splash:new(x, y)

    if show_particles == true then

        local self = setmetatable({}, splash)

        self.x = x
        self.y = y

        self.frame = 1
        self.speed = 22

        self.index = #splashesInstances + 1
        splashesInstances[self.index] = self

        local random = math.random(1, 3)

        splatSounds[random]:stop()
        splatSounds[random]:play()

        return self

    end
    
end

function splash:remove()

    local index = self.index
    local lastIndex = #splashesInstances

    if index ~= lastIndex then
        local last = splashesInstances[lastIndex]

        splashesInstances[index] = last
        last.index = index
    end

    splashesInstances[lastIndex] = nil
end

function splash:update(dt)

    self.frame = self.frame + self.speed * dt

    -- Animation terminée
    if self.frame >= #splashAnim.quads + 1 then
        self:remove()
        return
    end
end

function splash:draw()

    love.graphics.draw(
        splashAnim.spriteSheet,
        splashAnim.quads[math.floor(self.frame)],
        self.x,
        self.y,
        0,
        1,
        1,
        23,
        2
    )

end

return splash