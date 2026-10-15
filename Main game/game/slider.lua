local Slider = {}
Slider.__index = Slider

function Slider:new(x, y, knobSprite, barSprite, soundPressed, soundReleased)

    local self = setmetatable({}, Slider)

    self.x = x or 0
    self.y = y or 0

    self.knobSprite = knobSprite
    self.barSprite = barSprite

    self.soundPressed = soundPressed
    self.soundReleased = soundReleased

    self.pressed = false
    self.value = 1

    self.onRelease = nil

    return self
end

function Slider:pressedSlider(x, y)

    local width = self.barSprite:getWidth()
    local height = self.barSprite:getHeight()

    if x >= self.x
    and x <= self.x + width
    and y >= self.y
    and y <= self.y + height then

        self.pressed = true

        -- Place directement le curseur à l'endroit du clic
        self:handle(x, 14)

        if self.soundPressed then
            self.soundPressed:stop()
            self.soundPressed:play()
        end
    end
end

function Slider:handle(x, offsetX)

    if not self.pressed then
        return
    end

    -- Revenir dans le repère du slider
    self.value = (x - offsetX - self.x) / self.barSprite:getWidth()

    self.value =
        math.max(
            0,
            math.min(
                1,
                self.value
            )
        )
end

function Slider:released()

    if self.onRelease then
        self.onRelease()
    end

    if self.pressed and self.soundReleased then
        self.soundReleased:stop()
        self.soundReleased:play()
    end

    self.pressed = false
end

function Slider:draw(offsetX, offsetY)

    offsetX = offsetX or 0
    offsetY = offsetY or 0

    love.graphics.draw(
        self.barSprite,
        self.x - offsetX,
        self.y - offsetY
    )

    local knobX = self.x + self.value * self.barSprite:getWidth()

    love.graphics.draw(
        self.knobSprite,
        knobX - offsetX,
        self.y + 3 - offsetY,
        self.value * 8,
        1,
        1,
        7,
        7
    )
end

function Slider:setOnRelease(func)
    self.onRelease = func
end

return Slider