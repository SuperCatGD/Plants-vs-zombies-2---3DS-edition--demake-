local NinePatch = {}
NinePatch.__index = NinePatch


-- path : image 48x48 divisée en 9 parties
-- size : taille d'une case (16 par défaut)
function NinePatch:new(path, size)

    local self = setmetatable({}, NinePatch)

    self.image = love.graphics.newImage(path)
    self.size = size or 8

    local imgW = self.image:getWidth()
    local imgH = self.image:getHeight()
    local s = self.size


    assert(
        imgW == s * 3 and imgH == s * 3,
        "L'image NinePatch doit être de taille 3x3 (ex: 48x48 avec size 16)"
    )


    self.quads = {

        -- Ligne du haut
        tl = love.graphics.newQuad(0,     0,     s, s, imgW, imgH),
        t  = love.graphics.newQuad(s,     0,     s, s, imgW, imgH),
        tr = love.graphics.newQuad(s * 2, 0,     s, s, imgW, imgH),

        -- Ligne du milieu
        l  = love.graphics.newQuad(0,     s,     s, s, imgW, imgH),
        c  = love.graphics.newQuad(s,     s,     s, s, imgW, imgH),
        r  = love.graphics.newQuad(s * 2, s,     s, s, imgW, imgH),

        -- Ligne du bas
        bl = love.graphics.newQuad(0,     s * 2, s, s, imgW, imgH),
        b  = love.graphics.newQuad(s,     s * 2, s, s, imgW, imgH),
        br = love.graphics.newQuad(s * 2, s * 2, s, s, imgW, imgH),
    }


    return self
end



-- Dessine le panneau à la position x,y avec une taille width,height
function NinePatch:draw(x, y, width, height)

    local s = self.size


    -- Taille minimale : 3 cases
    width = math.max(width, s * 2)
    height = math.max(height, s * 2)


    local scaleX = (width - s * 2) / s
    local scaleY = (height - s * 2) / s



    -- Coins
    love.graphics.draw(self.image, self.quads.tl, x, y)
    love.graphics.draw(self.image, self.quads.tr, x + width - s, y)

    love.graphics.draw(
        self.image,
        self.quads.bl,
        x,
        y + height - s
    )

    love.graphics.draw(
        self.image,
        self.quads.br,
        x + width - s,
        y + height - s
    )


    -- Haut
    love.graphics.draw(
        self.image,
        self.quads.t,
        x + s,
        y,
        0,
        scaleX,
        1
    )


    -- Bas
    love.graphics.draw(
        self.image,
        self.quads.b,
        x + s,
        y + height - s,
        0,
        scaleX,
        1
    )


    -- Gauche
    love.graphics.draw(
        self.image,
        self.quads.l,
        x,
        y + s,
        0,
        1,
        scaleY
    )


    -- Droite
    love.graphics.draw(
        self.image,
        self.quads.r,
        x + width - s,
        y + s,
        0,
        1,
        scaleY
    )


    -- Centre
    love.graphics.draw(
        self.image,
        self.quads.c,
        x + s,
        y + s,
        0,
        scaleX,
        scaleY
    )

end


return NinePatch