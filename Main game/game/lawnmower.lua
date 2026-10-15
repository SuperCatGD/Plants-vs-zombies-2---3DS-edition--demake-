local lawnmower = {}
lawnmower.__index = lawnmower

local lawnmowerSprite = Resources.image("Sprites/BG/Lawn/ModernLawnmower.png")

lawnmowers = {}

function lawnmower:new(x, y)

    local self = setmetatable({}, lawnmower)

    self.dirtDuration = 2

    self.x = x
    self.y = y

    self.speed = 0
    self.line = math.floor((y - 30) / 37)

    self.activated = false

    self.index = #lawnmowers + 1
    lawnmowers[self.index] = self

    return self

end

function lawnmower:remove()

    local index = self.index
    local lastIndex = #lawnmowers

    -- Remplace le zombie supprimé par le dernier
    if index ~= lastIndex then
        local last = lawnmowers[lastIndex]

        lawnmowers[index] = last
        last.index = index
    end

    lawnmowers[lastIndex] = nil
end

function lawnmower:update(dt)
    if self.x > 350 then
        self:remove()
    end
    if self.activated then
        self.speed = self.speed + dt * 120
        self.x = self.x + self.speed * dt
    end
end

function lawnmower:draw(dt)
    love.graphics.draw(lawnmowerSprite, self.x, self.y, -self.speed / 1000, 1, 1, 18, 15)
end

return lawnmower