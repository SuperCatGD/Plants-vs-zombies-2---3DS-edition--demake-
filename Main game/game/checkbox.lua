local Checkbox = {}
Checkbox.__index = Checkbox

function Checkbox:new(x, y, imgUnchecked, imgChecked, sfxPress, sfxRelease, checked)
    local self = setmetatable({}, Checkbox)

    self.x = x
    self.y = y

    self.imgUnchecked = imgUnchecked
    self.imgChecked = imgChecked

    self.sfxPress = sfxPress
    self.sfxRelease = sfxRelease

    self.checked = checked
    self.pressed = false

    self.onToggle = nil

    return self
end

function Checkbox:setOnToggle(func)
    self.onToggle = func
end

function Checkbox:draw()
    if self.checked then
        love.graphics.draw(self.imgChecked, self.x, self.y)
    else
        love.graphics.draw(self.imgUnchecked, self.x, self.y)
    end
end

function Checkbox:isInside(mx, my)
    return mx >= self.x and mx <= self.x + self.imgUnchecked:getWidth()
       and my >= self.y and my <= self.y + self.imgUnchecked:getHeight()
end

function Checkbox:mousepressed(mx, my, button)
    if button ~= 1 then return end
    if self:isInside(mx, my) then
        self.pressed = true
        if self.sfxPress then 
            self.sfxPress:stop()
            self.sfxPress:play() 
        end
    end
end

function Checkbox:mousereleased(mx, my, button)
    if button ~= 1 then return end
    if self.pressed and self:isInside(mx, my) then
        self.checked = not self.checked
        if self.sfxRelease then 
            self.sfxRelease:stop()
            self.sfxRelease:play()
        end

        if self.onToggle then
            self.onToggle(self.checked)
        end
    end
    self.pressed = false
end
function Checkbox:touchpressed(button, mx, my)
    if self:isInside(mx, my) then
        self.pressed = true
        if self.sfxPress then 
            self.sfxPress:stop()
            self.sfxPress:play()
        end
    end
end
function Checkbox:touchreleased(button, mx, my)
    if self.pressed and self:isInside(mx, my) then
        self.checked = not self.checked
        if self.sfxRelease then 
            self.sfxRelease:stop() 
            self.sfxRelease:play()
        end

        if self.onToggle then
            self.onToggle(self.checked)
        end
    end
    self.pressed = false
end
function Checkbox:drawAt(offsetX, offsetY)

    offsetX = offsetX or 0
    offsetY = offsetY or 0

    local x = self.x + offsetX
    local y = self.y + offsetY

    if self.checked then
        love.graphics.draw(
            self.imgChecked,
            x,
            y
        )
    else
        love.graphics.draw(
            self.imgUnchecked,
            x,
            y
        )
    end

end

return Checkbox