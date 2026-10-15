local MarigoldLoader = {}
MarigoldLoader.__index = MarigoldLoader
-- =========================================================
-- EASINGS
-- =========================================================
local function clamp01(t)
    return math.max(0, math.min(1, t))
end

local function quadInOut(t)
    t = clamp01(t)

    if t < 0.5 then
        return 2 * t * t
    end

    return 1 - ((-2 * t + 2)^2) / 2
end

local function backIn(t, amount)
    t = clamp01(t)

    amount = amount or 1.70158

    return (amount + 1) * t * t * t
        - amount * t * t
end


local function quadOut(t)
    t = clamp01(t)
    return 1 - (1 - t) * (1 - t)
end

local function backOut(t, amount)
    t = clamp01(t)

    amount = amount or 1.70158

    local c1 = amount
    local c3 = c1 + 1

    return 1 + c3 * (t - 1)^3 + c1 * (t - 1)^2
end


-- =========================================================
-- CONSTRUCTOR
-- =========================================================

function MarigoldLoader:new(face, petal, x, y)

    local self = setmetatable({}, MarigoldLoader)

    self.face = face
    self.petal = petal

    self.x = x
    self.y = y


    -- =====================================================
    -- GLOBAL SCALE
    -- =====================================================

    self.globalScale = 0

    self.globalTimer = 0
    self.globalDuration = 0.42


    -- =====================================================
    -- PETALS
    -- =====================================================

    self.petalCount = 8
    self.petals = {}

    self.petalRadius = 0

    -- Scale générale supplémentaire des pétales
    self.petalScale = 0.75


    -- =====================================================
    -- TIMING
    -- =====================================================

    -- Temps entre chaque pétale
    self.stagger = 0.10

    -- 1. Révélation
    self.revealDuration = 0.3

    -- 2. Apparition complète
    self.appearDuration = 0.5

    -- 3. Détachement anticipé
    self.preDetachDuration = 0.7

    -- 4. Détachement réel
    self.detachDuration = 0.5

    -- Distance du détachement
    self.detachDistance = 80

    -- Nombre de fois où les pétales vont apparaître/disparaître
    self.petalCycles = 1

    -- Attente entre deux animations
    self.respawnDelay = 2.0

    -- Cycle actuel
    self.currentPetalCycle = 1

    -- Timer des pétales
    self.animationTimer = 0

    -- État de sortie de la fleur
    self.exiting = false
    self.exitTimer = 0
    self.exitDuration = 0.42

    -- true tant que LoadSequence charge : bloque la sortie de la fleur
    self.waitForLoad = false
    
    self.loopDuration = 13.0
    self.exitDuration = 0.42

    self.finished = false

    self.petalAnimationDuration =
        self.revealDuration
        + self.appearDuration
        + self.preDetachDuration
        + self.detachDuration

    self.fullDetachTime =
        self.petalAnimationDuration
        + (self.petalCount - 1) * self.stagger

    self.petalCycleDuration =
        self.fullDetachTime
        + self.respawnDelay
    -- =====================================================
    -- CRÉATION DES PÉTALES
    -- =====================================================

    for i = 1, self.petalCount do

        -- Premier pétale vers le haut
        local angle =
            ((i - 1) / self.petalCount) * math.pi * 2
            - math.pi / 2

        self.petals[i] = {

            angle = angle,

            -- Chaque pétale commence avec son propre délai
            timer = -(i - 1) * self.stagger,

            -- État
            phase = 1,

            -- Scale
            scaleX = 0.75,
            scaleY = 0,

            -- Position de détachement
            detachX = 0,
            detachY = 0,

            -- Alpha
            alpha = 1
        }
    end

    return self
end


-- =========================================================
-- PLAY
-- =========================================================

-- short = true : chargement très court (retour au menu). La fleur apparaît,
-- puis repart aussitôt, sans jouer l'animation des pétales.
function MarigoldLoader:play(short)

    self.finished = false

    self.short = short or false

    -- state vers lequel repasser dès que la fleur commence à disparaître
    self.exitState = 7

    if self.short then
        self.globalDuration = 0.3
        self.exitDuration = 0.3
    else
        self.globalDuration = 0.42
        self.exitDuration = 0.42
    end

    ------------------------------------------------
    -- RESET FLEUR
    ------------------------------------------------

    self.globalTimer = 0
    self.globalScale = 0
    self.globalAlpha = 1

    ------------------------------------------------
    -- RESET ANIMATION
    ------------------------------------------------

    self.animationTimer = 0
    self.currentPetalCycle = 1

    ------------------------------------------------
    -- RESET SORTIE
    ------------------------------------------------

    self.exiting = false
    self.exitTimer = 0

    ------------------------------------------------
    -- RESET PÉTALES
    ------------------------------------------------

    for i, petal in ipairs(self.petals) do

        petal.timer =
            -(i - 1) * self.stagger

        petal.phase = 1

        petal.scaleX = 0.75
        petal.scaleY = 0

        petal.detachX = 0
        petal.detachY = 0

        petal.alpha = 1

    end

end


-- =========================================================
-- UPDATE
-- =========================================================

function MarigoldLoader:update(dt)

    -- =====================================================
    -- FLEUR : APPARITION INITIALE
    -- =====================================================

    if not self.exiting then

        self.globalTimer =
            self.globalTimer + dt

        local globalT =
            clamp01(
                self.globalTimer /
                self.globalDuration
            )

        self.globalScale =
            backOut(globalT)
    end


    -- Mode court : dès que la fleur recouvre l'écran, on repart
    if self.short
    and not self.exiting
    and self.globalTimer >= self.globalDuration then

        self.exiting = true
        self.exitTimer = 0

        for _, petal in ipairs(self.petals) do
            petal.scaleX = 0
            petal.scaleY = 0
            petal.alpha = 0
        end
    end


    -- =====================================================
    -- ANIMATION DES PÉTALES
    -- =====================================================

    if not self.exiting then

        self.animationTimer =
            self.animationTimer + dt


        -- Temps dans le cycle actuel
        local cycleTime =
            self.animationTimer


        -- Toutes les pétales ont disparu (le dernier finit son détachement
        -- à fullDetachTime + 1, voir les phases plus bas).
        local allPetalsGone =
            cycleTime >= self.fullDetachTime + 1

        -- Fin d'animation :
        --  * dès que tous les pétales ont disparu, si on doit sortir
        --    (chargement fini) ou rejouer (chargement pas fini) ;
        --  * sinon, après le délai de réapparition normal.
        if (allPetalsGone
            and (self.waitForLoad
                 or self.currentPetalCycle >= self.petalCycles))
        or cycleTime >= self.petalCycleDuration then

            self.currentPetalCycle =
                self.currentPetalCycle + 1

            self.animationTimer =
                0

            cycleTime = 0


            -- =================================================
            -- APRÈS LA 2E ANIMATION
            -- =================================================

            if self.currentPetalCycle >
                self.petalCycles
            and self.waitForLoad then

                -- Le chargement n'est pas fini : on rejoue les pétales
                -- au lieu de sortir (sinon on afficherait le niveau
                -- avant qu'il soit prêt).
                self.currentPetalCycle = 1

            elseif self.currentPetalCycle >
                self.petalCycles then

                self.exiting = true
                self.exitTimer = 0

                -- On remet les pétales invisibles
                for _, petal in ipairs(self.petals) do
                    petal.scaleX = 0
                    petal.scaleY = 0
                    petal.alpha = 0
                end

                return
            end
        end


        -- =====================================================
        -- ANIMATION DU CYCLE
        -- =====================================================

        for i, petal in ipairs(self.petals) do

            local time =
                cycleTime
                - (i - 1) * self.stagger


            -- -----------------------------------------------
            -- AVANT L'APPARITION
            -- -----------------------------------------------

            if time < 0 then

                petal.scaleX = 0
                petal.scaleY = 0

                petal.detachX = 0
                petal.detachY = 0

                petal.alpha = 0


            -- -----------------------------------------------
            -- RÉVÉLATION
            -- -----------------------------------------------

            elseif time < self.revealDuration then

                local t =
                    quadInOut(
                        time / self.revealDuration
                    )

                petal.scaleX = 0.75
                petal.scaleY = 0.45 * t

                petal.detachX = 0
                petal.detachY = 0

                petal.alpha = 1


            -- -----------------------------------------------
            -- APPARITION COMPLÈTE
            -- -----------------------------------------------

            elseif time <
                self.revealDuration
                + self.appearDuration then

                local phaseTime =
                    time - self.revealDuration

                local half =
                    self.appearDuration / 2


                if phaseTime < half then

                    local t =
                        quadOut(
                            phaseTime / half
                        )

                    petal.scaleX =
                        0.75
                        + (0.8 - 0.75) * t

                    petal.scaleY =
                        0.45
                        + (1.2 - 0.45) * t

                else

                    local t =
                        backOut(
                            (phaseTime - half)
                            / half
                        )

                    petal.scaleX =
                        0.8
                        + (1 - 0.8) * t

                    petal.scaleY =
                        1.2
                        + (0.99 - 1.2) * t
                end

                petal.detachX = 0
                petal.detachY = 0

                petal.alpha = 1


            -- -----------------------------------------------
            -- DÉTACHEMENT ANTICIPÉ
            -- -----------------------------------------------

            elseif time <
                self.revealDuration
                + self.appearDuration
                + self.preDetachDuration + 1 then

                local phaseTime =
                    time
                    - self.revealDuration
                    - self.appearDuration - 1

                local half =
                    self.preDetachDuration / 2


                if phaseTime < half then

                    local t =
                        quadInOut(
                            phaseTime / half
                        )

                    petal.scaleX =
                        1
                        + (1.15 - 1) * t

                    petal.scaleY =
                        1
                        + (0.6 - 1) * t

                else

                    local t =
                        quadOut(
                            (phaseTime - half)
                            / half
                        )

                    petal.scaleX =
                        1.1
                        + (0.7 - 1.1) * t

                    petal.scaleY =
                        0.8
                        + (2 - 0.8) * t
                end

                petal.detachX = 0
                petal.detachY = 0

                petal.alpha = 1


            -- -----------------------------------------------
            -- DÉTACHEMENT RÉEL
            -- -----------------------------------------------

            elseif time <
                self.petalAnimationDuration + 1 then

                local phaseTime =
                    time
                    - self.revealDuration
                    - self.appearDuration
                    - self.preDetachDuration - 1

                local t =
                    quadOut(
                        phaseTime /
                        self.detachDuration
                    )

                petal.scaleX =
                    0.7
                    + (1 - 0.7) * math.min(t * 2, 1)

                petal.scaleY =
                    2
                    + (1 - 2) * math.min(t * 2, 1)

            -- -----------------------------------------------
            -- PÉTALE DISPARU
            -- -----------------------------------------------
            else

                petal.scaleX = 0
                petal.scaleY = 0

                petal.detachX =
                    math.cos(petal.angle)
                    * self.detachDistance

                petal.detachY =
                    math.sin(petal.angle)
                    * self.detachDistance

                petal.alpha = 0
            end
            if time < self.petalAnimationDuration + 1.4 then

                local phaseTime =
                    time
                    - self.revealDuration
                    - self.appearDuration
                    - self.preDetachDuration - 1

                local t =
                    quadOut(
                        phaseTime /
                        self.detachDuration
                    )

                petal.detachX =
                        math.cos(petal.angle)
                        * self.detachDistance
                        * t

                petal.detachY =
                        math.sin(petal.angle)
                        * self.detachDistance
                        * t

                petal.alpha =
                    1 - t

            end
        end

    -- =====================================================
    -- SORTIE DE LA FLEUR ENTIÈRE
    -- =====================================================

    else

        self.exitTimer =
            self.exitTimer + dt

        local t =
            clamp01(
                self.exitTimer /
                self.exitDuration
            )

        -- Inverse du Back Out d'apparition
        self.globalScale =
            1 - backIn(t)

        -- Fade global
        self.globalAlpha =
            1 - t


        if t >= 1 then

            self.finished = true
        
        else

            state = self.exitState or 7

        end
    end
end


-- =========================================================
-- DRAW
-- =========================================================

-- midCallback (optionnel) : dessiné entre le fond et la fleur
function MarigoldLoader:draw(BGonly, midCallback)

    local globalScale =
        self.globalScale

    if globalScale > 0.05 then

        love.graphics.setColor(1, 1, 1, globalScale)

        if BGonly == false then

            love.graphics.draw(loadingBG, -40, 0)

        else

            love.graphics.draw(loadingBG, 0, 0)

        end

    end

    if BGonly == false then

        if midCallback then
            midCallback(globalScale)
        end

        love.graphics.setColor(1, 1, 1, 1)

        -- =====================================================
        -- PÉTALES
        -- =====================================================

        for _, petal in ipairs(self.petals) do

            if petal.alpha > 0 then

                -- Position normale
                local radius =
                    self.petalRadius
                    * globalScale

                local px =
                    self.x
                    + math.cos(petal.angle)
                    * radius
                    + petal.detachX

                local py =
                    self.y
                    + math.sin(petal.angle)
                    * radius
                    + petal.detachY


                -- Scale globale × scale individuelle
                local sx =
                    globalScale
                    * petal.scaleX
                    * self.petalScale

                local sy =
                    globalScale
                    * petal.scaleY
                    * self.petalScale


                love.graphics.setColor(
                    1,
                    1,
                    1,
                    petal.alpha
                )


                love.graphics.draw(
                    self.petal,

                    px,
                    py,

                    petal.angle,

                    sy,
                    sx,

                    0,
                    self.petal:getHeight() / 2
                )
            end
        end


        -- =====================================================
        -- VISAGE
        -- =====================================================

        love.graphics.setColor(
            1,
            1,
            1,
            1
        )


        love.graphics.draw(
            self.face,

            self.x,
            self.y,

            0,

            globalScale,
            globalScale,

            self.face:getWidth() / 2,
            self.face:getHeight() / 2
        )
    end

end

return MarigoldLoader