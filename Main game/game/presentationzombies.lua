local presentationzombie = {}
presentationzombie.__index = presentationzombie

local shadow = Resources.image("Sprites/Zombies/Shadow.png")

function presentationzombie:new(type, x, y)

    local self = setmetatable({}, presentationzombie)

    self.x = x
    self.y = y

    self.type = type
    self.frame = math.random(1, 17)

    -- Index du zombie dans sa ligne
    self.index = #zombiesInstancesPres + 1
    zombiesInstancesPres[self.index] = self

    return self
end

function presentationzombie:remove()

    local zombies = zombiesInstancesPres

    if not zombies then
        return
    end

    local index = self.index
    local lastIndex = #zombies

    if index < 1 or index > lastIndex then
        self.index = nil
        return
    end

    if index ~= lastIndex then
        local last = zombies[lastIndex]

        zombies[index] = last

        if last then
            last.index = index
        end
    end

    zombies[lastIndex] = nil
    self.index = nil
end

function presentationzombie:update(dt)

    -- Animation
    self.frame = self.frame + 9 * dt

    if self.frame > 18 then
        self.frame = 1
    end
end

function presentationzombie:draw()

    if show_shadows then
        love.graphics.setColor(1,1,1,0.5)
        love.graphics.draw(shadow, self.x + 10 + scrollX, self.y + 32, 0, 1, 1, 21, 42)
        love.graphics.setColor(1,1,1,1)
    end
    
    if self.type == "basic" or self.type == "conehead" or self.type == "buckethead" then

        love.graphics.draw(
            basicZombie.spriteSheet,
            basicZombie.quads[math.floor(self.frame)],
            self.x + scrollX,
            self.y,
            0,
            1,
            1,
            21,
            42
        )
        if self.type == "conehead" then

            love.graphics.draw(cones[1], self.x + protection_position_values[math.floor(self.frame)].posX + scrollX, self.y + protection_position_values[math.floor(self.frame)].posY, 0, 1, 1, 20, 43)

        elseif self.type == "buckethead" then

            love.graphics.draw(buckets[1], self.x + protection_position_values[math.floor(self.frame)].posX + scrollX, self.y + protection_position_values[math.floor(self.frame)].posY, 0, 1, 1, 20, 43)

        end

    elseif self.type == "mummy_basic" or self.type == "mummy_conehead" or self.type == "mummy_buckethead" then

        love.graphics.draw(
            mummyZombie.spriteSheet,
            mummyZombie.quads[math.floor(self.frame)],
            self.x + scrollX,
            self.y,
            0,
            1,
            1,
            28,
            43
        )
        if self.type == "mummy_conehead" then

            love.graphics.draw(cones_mummy[1], self.x + protection_position_values_mummy[math.floor(self.frame)].posX + scrollX, self.y + protection_position_values_mummy[math.floor(self.frame)].posY, 0, 1, 1, 20, 43)

        elseif self.type == "mummy_buckethead" then

            love.graphics.draw(buckets_mummy[1], self.x + protection_position_values_mummy[math.floor(self.frame)].posX + scrollX, self.y + protection_position_values_mummy[math.floor(self.frame)].posY, 0, 1, 1, 20, 43)

        end

    end

end

return presentationzombie