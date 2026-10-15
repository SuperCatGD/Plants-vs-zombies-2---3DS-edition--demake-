-----------------------------------------
-- SYSTEME DE NIVEAU POUR FANGAME PVZ
-----------------------------------------

local LevelSystem = {}
LevelSystem.__index = LevelSystem

local animatedprogress = 0
local progress = 0

local progressBarSprites = {
    bar = Resources.image("Sprites/UI/HUD/ProgressBarOutline.png"),
    fill = Resources.image("Sprites/UI/HUD/ProgressBarFill.png"),
    flag = Resources.image("Sprites/UI/HUD/ProgressBarFlag.png"),
    zombie = Resources.image("Sprites/UI/HUD/ProgressBarZombie.png")
}

-- Réutilisé à chaque frame au lieu d'allouer un Quad natif.
local progressBarQuad = love.graphics.newQuad(0, 0, 1, 4, 58, 4)

local startWaveSound =
    Resources.sfx("Audio/SFX/ZombiesComing.ogg")

function LevelSystem:new(config)
    local self = setmetatable({}, LevelSystem)

    self.levelCompleted = false

    -- CONFIG
    self.damageThreshold = config.damageThreshold or 200      -- X dégâts
    self.timeThreshold   = config.timeThreshold or 15         -- Y secondes
    self.waves           = config.waves or {}                 -- tableau de vagues
    self.events          = config.events or {}                -- tableau d'évènements

    -- ETAT
    self.totalDamage = 0
    self.timeElapsed = 0
    self.currentWave = 1
    self.eventIndex  = 1
    self.zombiesSpawned = false

    -- Grosse vague : l'annonce commence d'abord, puis les zombies arrivent 4 s plus tard.
    self.hugeWavePending = false
    self.hugeWavePendingWave = nil

    return self
end

---------------------------------------------------------
-- UPDATE
---------------------------------------------------------
function LevelSystem:update(dt)
    
    progress = math.min(1, (self.currentWave - 1) / #self.waves)

    if progress > animatedprogress then

        animatedprogress = animatedprogress + dt / 3

    else

        animatedprogress = progress

    end

    -- Le temps du niveau doit continuer à avancer pendant les grosses vagues.
    -- Sinon une vague avec waitzombies=true bloque le chronomètre et empêche
    -- toutes les vagues suivantes basées sur `time` de se déclencher.
    if not self.hugeWavePending then
        self.timeElapsed = self.timeElapsed + dt
    end

    -- Si une énorme vague est annoncée, attendre 4 secondes avant de faire apparaître ses zombies.
    if self.hugeWavePending and hugeWaveTimer >= 4 then
        self:launchWave(self.hugeWavePendingWave)
        self.currentWave = self.currentWave + 1
        self.hugeWavePending = false
        self.hugeWavePendingWave = nil
    end

    -- Vérifie si on doit spawn les zombies
    self:checkZombieSpawn()

    -- Vérifie si on doit lancer une vague
    self:checkWave(dt)

    -- Vérifie si un évènement doit se déclencher
    self:checkEvents()

    self:checkLevelComplete()

    -- Timer de l'annonce de grosse vague.
    if hugeWaveActive then
        hugeWaveTimer = hugeWaveTimer + dt
        if hugeWaveTimer >= 7 then
            hugeWaveActive = false
            hugeWaveTimer = 0
            hugeWaveIsFinal = false
        end
    end
    
end
---------------------------------------------------------
-- SPAWN DES ZOMBIES
---------------------------------------------------------
function LevelSystem:checkZombieSpawn()
    if self.zombiesSpawned then return end

    if self.totalDamage >= self.damageThreshold and self.timeElapsed >= self.timeThreshold then
        self.zombiesSpawned = true
        self:spawnZombies()
    end
end

---------------------------------------------------------
-- SYSTEME DE VAGUES
---------------------------------------------------------
function LevelSystem:checkWave(dt)
    -- Une énorme vague est en attente : ne pas passer à la suivante pendant le délai de 4 s.
    if self.hugeWavePending then return end

    local wave = self.waves[self.currentWave]
    if not wave then return end

    if wave.waitzombies == false then
        if self.timeElapsed >= wave.time then
            if self.currentWave == 1 then
                startWaveSound:play()
            end
            self:launchWave(wave)
            self.currentWave = self.currentWave + 1
        end
    else
        local zombieCount =
            #zombiesInstances[1] +
            #zombiesInstances[2] +
            #zombiesInstances[3] +
            #zombiesInstances[4] +
            #zombiesInstances[5]

        if zombieCount <= 1 then
            hugeWaveWaitTimer = hugeWaveWaitTimer + dt

            if self.timeElapsed >= wave.time and hugeWaveWaitTimer > 5 then
                -- L'annonce commence maintenant. Les zombies de cette énorme vague
                -- n'arriveront qu'après 4 secondes.
                hugeWaveTimer = 0
                hugeWaveActive = true
                hugeWaveIsFinal = wave.finalWave == true

                self.hugeWavePending = true
                self.hugeWavePendingWave = wave
                hugeWaveWaitTimer = 0
            end
        end
    end
end

function LevelSystem:launchWave(wave)
    print("LANCEMENT DE LA VAGUE " .. self.currentWave)

    for _, zombie in ipairs(wave.zombies) do
        if zombie.line == 0 then
            SpawnZombie(zombie.type, math.random(1, 5))
        else
            SpawnZombie(zombie.type, zombie.line)
        end
    end
end

---------------------------------------------------------
-- SYSTEME D'EVENEMENTS
---------------------------------------------------------
function LevelSystem:checkEvents()
    local event = self.events[self.eventIndex]
    if not event then return end

    if self.timeElapsed >= event.time then
        self:triggerEvent(event)
        self.eventIndex = self.eventIndex + 1
    end
end

function LevelSystem:triggerEvent(event)
    print("EVENEMENT : " .. event.name)

    if event.action then
        event.action()
    end
end

function LevelSystem:drawBar()

    love.graphics.draw(progressBarSprites.bar, 240, 35)

    local barWidth = math.max(1, animatedprogress * 58)
    progressBarQuad:setViewport(0, 0, barWidth, 4, 58, 4)

    love.graphics.draw(progressBarSprites.fill, progressBarQuad, 301 - (animatedprogress * 58), 38)

    love.graphics.draw(progressBarSprites.zombie, 292 - animatedprogress * 58, 35)

end
---------------------------------------------------------
-- FIN DU NIVEAU / RECOMPENSE
---------------------------------------------------------

local function getZombieCount()

    if not zombiesInstances then
        return 0
    end

    local count = 0

    for line = 1, 5 do
        local zombies = zombiesInstances[line]

        if zombies then
            count = count + #zombies
        end
    end

    return count
end

function LevelSystem:checkLevelComplete()

    if self.levelCompleted then
        return
    end

    -- Toutes les vagues doivent avoir été lancées
    if self.currentWave <= #self.waves then
        return
    end

    -- Compte les zombies restants
    local zombieCount = getZombieCount()

    -- Il reste des zombies
    if zombieCount > 0 then
        return
    end

    self.levelCompleted = true

    print("NIVEAU TERMINE !")
    startReward()

end

return LevelSystem