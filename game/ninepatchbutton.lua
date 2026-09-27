local NinePatchRect = require("ninepatch")

local NinePatchButton = {}
NinePatchButton.__index = NinePatchButton


--------------------------------------------------
-- Création
--------------------------------------------------

function NinePatchButton:new(
    x,
    y,
    w,
    h,
    spriteNormal,
    spritePressed,
    size,
    soundPressed,
    soundReleased
)

    local self =
        setmetatable({}, NinePatchButton)


    self.x = x
    self.y = y

    self.w = w
    self.h = h

    self.SFXP = soundPressed
    self.SFXR = soundReleased

    ------------------------------------------------
    -- NinePatch
    ------------------------------------------------

    self.normal =
        NinePatchRect:new(
            spriteNormal,
            size
        )


    self.pressed =
        NinePatchRect:new(
            spritePressed,
            size
        )


    ------------------------------------------------
    -- État
    ------------------------------------------------

    self.isDown = false

    -- ID du doigt actuellement utilisé
    self.touchID = nil


    ------------------------------------------------
    -- Callback
    ------------------------------------------------

    self.onClick = nil


    return self

end


--------------------------------------------------
-- Callback
--------------------------------------------------

function NinePatchButton:setOnClick(fn)

    self.onClick = fn

end


--------------------------------------------------
-- Collision
--------------------------------------------------

function NinePatchButton:contains(mx, my)

    return
        mx >= self.x and
        mx < self.x + self.w and
        my >= self.y and
        my < self.y + self.h

end


--------------------------------------------------
-- PRESS
--------------------------------------------------

function NinePatchButton:press(mx, my, id)

    if self.isDown then
        return false
    end

    if not self:contains(mx, my) then
        return false
    end


    self.isDown = true
    self.touchID = id

    self.SFXP:stop()
    self.SFXP:play()

    return true

end


--------------------------------------------------
-- RELEASE
--------------------------------------------------

function NinePatchButton:release(mx, my, id)

    if not self.isDown then
        return false
    end

    ------------------------------------------------
    -- Vérifie le doigt
    ------------------------------------------------

    if self.touchID ~= nil
    and id ~= nil
    and self.touchID ~= id then

        return false

    end


    local inside =
        self:contains(mx, my)


    self.isDown = false
    self.touchID = nil
    self.SFXR:stop()
    self.SFXP:stop()
    self.SFXR:play()


    ------------------------------------------------
    -- Release en dehors
    ------------------------------------------------

    if not inside then
        return false
    end


    ------------------------------------------------
    -- Callback
    ------------------------------------------------

    if self.onClick then
        self.onClick()
    end


    return true

end


--------------------------------------------------
-- SOURIS
--------------------------------------------------

function NinePatchButton:mousepressed(
    mx,
    my,
    button
)

    if button ~= 1 then
        return
    end


    self:press(
        mx,
        my,
        "mouse"
    )

end


function NinePatchButton:mousereleased(
    mx,
    my,
    button
)

    if button ~= 1 then
        return
    end


    self:release(
        mx,
        my,
        "mouse"
    )

end


--------------------------------------------------
-- TACTILE
--------------------------------------------------

function NinePatchButton:touchpressed(
    id,
    mx,
    my
)

    self:press(
        mx,
        my,
        id
    )

end


function NinePatchButton:touchreleased(
    id,
    mx,
    my
)

    self:release(
        mx,
        my,
        id
    )

end


--------------------------------------------------
-- UPDATE
--
-- Pas de hover.
--------------------------------------------------

function NinePatchButton:update(dt)

    -- Rien à faire pour l'instant.

end


--------------------------------------------------
-- DRAW
--------------------------------------------------

function NinePatchButton:draw()

    if self.isDown then

        self.pressed:draw(
            self.x,
            self.y,
            self.w,
            self.h
        )

    else

        self.normal:draw(
            self.x,
            self.y,
            self.w,
            self.h
        )

    end


end


return NinePatchButton