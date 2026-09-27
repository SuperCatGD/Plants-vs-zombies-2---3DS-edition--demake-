------------------------------------------------------------
-- SIMPLE BUTTON
------------------------------------------------------------

local simpleButton = {}
simpleButton.__index = simpleButton


------------------------------------------------------------
-- Création
------------------------------------------------------------

function simpleButton:new(x, y, spriteNormal, spritePressed, soundPressed, soundReleased)

    local self = setmetatable({}, simpleButton)

    self.x = x or 0
    self.y = y or 0

    self.spriteNormal = spriteNormal
    self.spritePressed = spritePressed or spriteNormal

    self.width = spriteNormal:getWidth()
    self.height = spriteNormal:getHeight()

    self.soundPressed = soundPressed
    self.soundReleased = soundReleased

    self.pressed = false
    self.touchID = nil

    self.enabled = true

    self.onClick = nil

    return self

end


------------------------------------------------------------
-- Callback
------------------------------------------------------------

function simpleButton:setOnClick(callback)

    self.onClick = callback

end


------------------------------------------------------------
-- Collision
------------------------------------------------------------

function simpleButton:contains(x, y)

    if not x or not y then
        return false
    end

    return
        x >= self.x and
        x < self.x + self.width and
        y >= self.y and
        y < self.y + self.height

end


------------------------------------------------------------
-- Press
------------------------------------------------------------

function simpleButton:press(x, y, id)

    if not self.enabled then
        return false
    end

    if self.pressed then
        return false
    end

    if not self:contains(x, y) then
        return false
    end

    self.soundPressed:stop()
    self.soundPressed:play()

    self.pressed = true
    self.touchID = id

    return true

end


------------------------------------------------------------
-- Release
------------------------------------------------------------

function simpleButton:release(x, y, id)

    if not self.pressed then
        return false
    end

    --------------------------------------------------------
    -- Vérifie le doigt
    --------------------------------------------------------

    if self.touchID ~= nil
    and id ~= nil
    and self.touchID ~= id then

        return false

    end

    local inside = self:contains(x, y)

    self.pressed = false
    self.touchID = nil

    --------------------------------------------------------
    -- Relâché en dehors
    --------------------------------------------------------

    if not inside then
        return false
    end

    --------------------------------------------------------
    -- Callback
    --------------------------------------------------------
    self.soundPressed:stop()
    self.soundReleased:stop()
    self.soundReleased:play()

    if self.onClick then
        self.onClick()
    end

    return true

end


------------------------------------------------------------
-- Souris
------------------------------------------------------------

function simpleButton:mousepressed(x, y, button)

    if button ~= 1 then
        return false
    end

    return self:press(x, y, "mouse")

end


function simpleButton:mousereleased(x, y, button)

    if button ~= 1 then
        return false
    end

    return self:release(x, y, "mouse")

end


------------------------------------------------------------
-- Tactile
------------------------------------------------------------

function simpleButton:touchpressed(id, x, y)

    return self:press(x, y, id)

end


function simpleButton:touchreleased(id, x, y)

    return self:release(x, y, id)

end


------------------------------------------------------------
-- Dessin
------------------------------------------------------------

function simpleButton:draw()

    if not self.enabled then
        return
    end

    local sprite = self.spriteNormal

    if self.pressed then
        sprite = self.spritePressed
    end

        love.graphics.draw(
            sprite,
            self.x,
            self.y
        )

end


------------------------------------------------------------
-- Position
------------------------------------------------------------

function simpleButton:setPosition(x, y)

    self.x = x
    self.y = y

end


------------------------------------------------------------
-- Activation
------------------------------------------------------------

function simpleButton:setEnabled(enabled)

    self.enabled = enabled

    if not enabled then
        self.pressed = false
        self.touchID = nil
    end

end

function simpleButton:cancel()

    self.pressed = false
    self.touchID = nil

end

------------------------------------------------------------
-- Export
------------------------------------------------------------

return simpleButton
