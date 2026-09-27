local Carousel = {}
Carousel.__index = Carousel


function Carousel:new(images)

    local self = setmetatable({}, Carousel)


    -- Images
    self.images = images
    self.count = #images


    -- Position
    -- 1 = première image
    self.position = 1
    self.target = 1


    -- Mouvement
    self.velocity = 0


    -- Configuration
    self.spacing = 250

    self.centerX = 160
    self.centerY = 120


    -- Animation
    self.lerpSpeed = 8
    self.friction = 0.88


    -- Drag
    self.dragging = false
    self.lastX = 0


    -- Auto slide
    self.timer = 0
    self.autoDelay = 3


    -- Limites
    self.min = 1
    self.max = self.count


    return self

end



------------------------------------------------
-- UPDATE
------------------------------------------------

function Carousel:update(dt)


    ------------------------------------------------
    -- AUTO SLIDE
    ------------------------------------------------

    if not self.dragging
    and math.abs(self.velocity) < 0.01 then


        self.timer =
            self.timer + dt


        if self.timer >= self.autoDelay then


            self.timer = 0


            self.target =
                self.target + 1


            if self.target > self.max then
                self.target = self.min
            end


        end

    end



    ------------------------------------------------
    -- INERTIE
    ------------------------------------------------

    if not self.dragging then


        self.position =
            self.position +
            self.velocity * dt


        self.velocity =
            self.velocity *
            math.pow(
                self.friction,
                dt * 60
            )



        -- fin inertie
        if math.abs(self.velocity) < 0.01 then

            self.velocity = 0


            -- snap
            self.target =
                math.floor(
                    self.position + 0.5
                )


        end

    end



    ------------------------------------------------
    -- LERP VERS TARGET
    ------------------------------------------------


    if not self.dragging then


        self.position =
            self.position +
            (
                self.target -
                self.position
            )
            *
            self.lerpSpeed
            *
            dt


    end



    ------------------------------------------------
    -- LIMITES
    ------------------------------------------------

    if self.position < self.min then

        self.position = self.min
        self.target = self.min

    end


    if self.position > self.max then

        self.position = self.max
        self.target = self.max

    end



end




------------------------------------------------
-- DRAW
------------------------------------------------

function Carousel:draw()


    for i,img in ipairs(self.images) do


        local distance =
            i - self.position



        local x =
            self.centerX +
            distance *
            self.spacing



        local y =
            self.centerY

        love.graphics.draw(

            img,

            math.floor(x),
            y,

            0,

            1,
            1,

            img:getWidth()/2,
            img:getHeight()/2

        )


    end


end





------------------------------------------------
-- INPUT SOURIS / TOUCH
------------------------------------------------

function Carousel:pressed(x)

    if menuState ~= 1 then
        return
    end

    self.dragging = true

    self.lastX = x


    self.velocity = 0


    self.timer = 0


end



function Carousel:moved(x)

    if menuState ~= 1 then
        return
    end

    if not self.dragging then
        return
    end


    local dx =
        x - self.lastX



    self.position =
        self.position -
        dx / self.spacing



    self.target =
        self.position



    self.velocity =
        -dx /
        self.spacing *
        8



    self.lastX = x


    self.timer = 0


end



function Carousel:released()

    if menuState ~= 1 then
        return
    end

    self.dragging = false


    self.target =
        math.floor(
            self.position + 0.5
        )


    self.target =
        math.max(
            self.min,
            math.min(
                self.max,
                self.target
            )
        )


end





------------------------------------------------
-- TOUCH 3DS
------------------------------------------------

function Carousel:touchpressed(id,x,y)
    
    self:pressed(x)

end


function Carousel:touchmoved(id,x,y)

    self:moved(x)

end


function Carousel:touchreleased(id,x,y)

    self:released()

end


return Carousel