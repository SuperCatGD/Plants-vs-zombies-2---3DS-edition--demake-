--------------------------------------------------
-- CHARGEMENT EN PLUSIEURS ETAPES
--------------------------------------------------
--
-- Sur 3DS, l'ecran n'est rafraichi qu'APRES le retour de love.update().
-- Un gros chargement fait d'un seul coup (Scene.load) fige donc l'ecran :
-- ni le texte ni l'animation de la fleur ne s'affichent.
--
-- Ici on charge par petits morceaux (ITEMS_PER_FRAME assets par frame) et,
-- a chaque changement d'etape, on attend FRAMES_BEFORE_WORK frames avant de
-- recommencer a charger : le nouveau texte a le temps d'etre dessine.
--
-- Etapes :
--   1. images     -> Resources.image() de tous les sprites du gameplay
--   2. sfx        -> Resources.sfx()
--   3. musiques   -> Resources.music()
--   4. niveau     -> require("gameplay") : tout est deja dans le cache de
--                    Resources, il ne reste que la compilation du Lua.
--
-- Resources garde un cache : quand gameplay.lua appelle ensuite
-- Resources.image(...) pour le meme chemin, il recoit l'objet deja charge.
-- Si un chemin manque dans les listes ci-dessous, ce n'est PAS un bug :
-- il sera simplement charge pendant l'etape 4.
--
-- Pour ajouter un asset : ajoute son chemin dans IMAGES / SFX ci-dessous.

local LoadSequence = {}

-- Frames d'attente apres l'affichage d'un nouveau texte (2 = double buffer).
local FRAMES_BEFORE_WORK = 2

-- Nombre d'assets charges par frame. Augmente pour charger plus vite,
-- diminue (1) pour garder la fleur plus fluide.
local ITEMS_PER_FRAME = 1

--------------------------------------------------
-- LISTES D'ASSETS (identiques pour tous les niveaux)
--------------------------------------------------

local IMAGES = {
    -- gameplay.lua
    "Sprites/UI/HUD/Shovel.png",
    "Sprites/UI/HUD/ShovelButton.png",
    "Sprites/UI/HUD/ShovelButtonHover.png",
    "Sprites/Other/HotSauce.png",
    "Sprites/UI/HUD/PlantFoodPanel3.png",
    "Sprites/UI/HUD/PlantFoodLeaf.png",
    "Sprites/UI/HUD/PlantFoodUnit.png",
    "Sprites/Plants/Seeds/Selector.png",
    "Sprites/Plants/Seeds/Seeds.png",
    "Sprites/Plants/PlayerHouse/Peashooter.png",
    "Sprites/Plants/PlayerHouse/Sunflower.png",
    "Sprites/Plants/PlayerHouse/WallNut.png",
    "Sprites/Plants/PlayerHouse/PotatoMine.png",
    "Sprites/BG/TopScreen/BG.png",
    "Sprites/BG/TopScreen/Tutorial.png",
    "Sprites/BG/TopScreen/Overlay.png",
    "Sprites/UI/HUD/SpeedButton.png",
    "Sprites/UI/HUD/SpeedButtonActive.png",
    "Sprites/UI/HUD/PauseButton.png",
    "Sprites/UI/HUD/PauseButtonActive.png",
    "Sprites/BG/Lawn/SoderRoll.png",
    "Sprites/BG/Lawn/SoderLong.png",
    "Sprites/BG/Lawn/SoderEnd.png",
    "Sprites/BG/Lawn/1RowModern.png",
    "Sprites/BG/Lawn/3RowModern.png",
    "Sprites/BG/Lawn/Full.png",
    "Sprites/UI/HUD/SunsHUD.png",

    -- lawnmower.lua
    "Sprites/BG/Lawn/ModernLawnmower.png",

    -- levelsystem.lua
    "Sprites/UI/HUD/ProgressBarOutline.png",
    "Sprites/UI/HUD/ProgressBarFill.png",
    "Sprites/UI/HUD/ProgressBarFlag.png",
    "Sprites/UI/HUD/ProgressBarZombie.png",

    -- plant.lua
    "Sprites/Other/Spudow.png",
    "Sprites/Other/PFeffectGround.png",
    "Sprites/Other/PFeffectBeam.png",
    "Sprites/Plants/Shadow.png",
    "Sprites/Other/DirtPlanted.png",

    -- projectiles.lua / splash.lua
    "Sprites/Plants/Projectiles/Pea.png",
    "Sprites/Plants/Projectiles/Shadow.png",
    "Sprites/Plants/Projectiles/PlantFoodPea.png",
    "Sprites/Plants/Projectiles/PeaSplat.png",

    -- suns.lua
    "Sprites/Other/SunRays.png",
    "Sprites/Other/SunCenter.png",

    -- zombie.lua / zombieparts.lua / presentationzombies.lua
    "Sprites/Zombies/mummy_basic.png",
    "Sprites/Zombies/basic.png",
    "Sprites/Zombies/basic_flag.png",
    "Sprites/Zombies/Cone.png",
    "Sprites/Zombies/Cone2.png",
    "Sprites/Zombies/Cone3.png",
    "Sprites/Zombies/Bucket.png",
    "Sprites/Zombies/Bucket2.png",
    "Sprites/Zombies/Bucket3.png",
    "Sprites/Zombies/Shadow.png",
    "Sprites/Zombies/basicCorpse.png",
    "Sprites/Zombies/mummyCorpse.png",
    "Sprites/Zombies/ZombieHead.png",
    "Sprites/Zombies/ZombieArm.png",
    "Sprites/Zombies/mummy_head.png",
    "Sprites/Zombies/mummy_arm.png",
}

local SFX = {
    -- gameplay.lua
    "Audio/SFX/Shovel.ogg",
    "Audio/SFX/PickShovel.ogg",
    "Audio/SFX/Faster.ogg",
    "Audio/SFX/Slower.ogg",
    "Audio/SFX/Pause.ogg",
    "Audio/SFX/HugeWave.ogg",
    "Audio/SFX/Finalwave.ogg",
    "Audio/SFX/Plant.ogg",
    "Audio/SFX/SeedLift.ogg",
    "Audio/SFX/CannotPick.ogg",
    "Audio/SFX/GameEffects/LevelEndFade.ogg",
    "Audio/SFX/GameEffects/readysetplant.ogg",
    "Audio/SFX/GameEffects/wind.ogg",
    "Audio/SFX/Groans1.ogg",
    "Audio/SFX/Groans2.ogg",
    "Audio/SFX/Groans3.ogg",
    "Audio/SFX/Groans4.ogg",
    "Audio/SFX/Groans5.ogg",
    "Audio/SFX/Groans6.ogg",

    -- levelsystem.lua
    "Audio/SFX/ZombiesComing.ogg",

    -- plant.lua
    "Audio/SFX/PeashooterPlantFood.ogg",
    "Audio/SFX/PlantFoodEnd.ogg",
    "Audio/SFX/potatosplosion.ogg",

    -- projectiles.lua / splash.lua
    "Audio/SFX/Throw.ogg",
    "Audio/SFX/Throw2.ogg",
    "Audio/SFX/Splat.ogg",
    "Audio/SFX/Splat2.ogg",
    "Audio/SFX/Splat3.ogg",
    "Audio/SFX/conehit.ogg",
    "Audio/SFX/conehit2.ogg",
    "Audio/SFX/buckethit.ogg",
    "Audio/SFX/buckethit2.ogg",

    -- suns.lua / zombie.lua / zombieparts.lua
    "Audio/SFX/Sun.ogg",
    "Audio/SFX/Eat.ogg",
    "Audio/SFX/Glup.ogg",
    "Audio/SFX/LimbsPop.ogg",
}

-- Musiques selon le champ "music" du niveau (voir gameplay.lua)
local MUSIC = {
    [1] = {
        "Audio/Music/FrontYard.ogg",
        "Audio/Music/FrontYardReward.ogg",
        "Audio/Music/FrontYardLose.ogg",
    },
    [2] = {
        "Audio/Music/AEfirstWave.ogg",
        "Audio/Music/AEreward.ogg",
        "Audio/Music/FrontYardLose.ogg",
    },
}

--------------------------------------------------
-- ETAT
--------------------------------------------------

local active = false
local stages = {}
local stageIndex = 0
local itemIndex = 1
local waitFrames = 0
local callbacks = nil
local levelData = nil

--------------------------------------------------
-- OUTILS
--------------------------------------------------

local function listToItems(list, loader)

    local items = {}

    for i = 1, #list do
        local path = list[i]
        items[i] = { label = path, run = function() loader(path) end }
    end

    return items
end

local function beginStage(index)

    stageIndex = index
    itemIndex = 1
    waitFrames = FRAMES_BEFORE_WORK

    local stage = stages[index]
    if stage then
        stage.items = stage.build()
    end
end

local function finish()

    active = false

    local done = callbacks and callbacks.onFinished
    callbacks = nil
    levelData = nil

    if done then done() end
end

--------------------------------------------------
-- DEMARRER
--
-- callbacks.levelName  : nom du fichier de Levels/ a charger
-- callbacks.unload     : decharge la scene precedente (Scene.unload)
-- callbacks.loadScene  : charge le gameplay sans vider le cache
-- callbacks.onFinished : appelee quand tout est charge
--------------------------------------------------

function LoadSequence.start(cb)

    callbacks = cb
    levelData = nil

    stages = {

        {
            textKey = "loading_images",

            build = function()

                -- On commence par liberer l'ancienne scene, puis on lit les
                -- donnees du niveau (le gameplay les reutilisera via require).
                local items = {
                    {
                        label = "(liberation de la memoire)",
                        run = function()
                            if callbacks.unload then callbacks.unload() end
                            levelData = require("Levels." .. callbacks.levelName)
                        end
                    },

                    -- Image du terrain : depend du niveau.
                    {
                        label = "(terrain du niveau)",
                        run = function()
                            if levelData and levelData.lawn then
                                Resources.image(levelData.lawn)
                            end
                        end
                    },
                }

                -- Textes traduits (Pret / Feu / Plantez / vagues)
                for _, key in ipairs({
                    "ready_texture", "set_texture", "plant_texture",
                    "huge_wave_texture", "final_wave_texture"
                }) do
                    local path = Language.get(key)
                    items[#items + 1] = {
                        label = path,
                        run = function() Resources.image(path) end
                    }
                end

                local more = listToItems(IMAGES, Resources.image)
                for i = 1, #more do items[#items + 1] = more[i] end

                return items
            end
        },

        {
            textKey = "loading_sfx",
            build = function() return listToItems(SFX, Resources.sfx) end
        },

        {
            textKey = "loading_music",
            build = function()

                local list = MUSIC[levelData and levelData.music or 1] or {}

                return listToItems(list, Resources.music)
            end
        },

        {
            textKey = "loading_level",
            build = function()
                return {
                    {
                        label = "(gameplay.lua)",
                        run = function()
                            if callbacks.loadScene then callbacks.loadScene() end
                        end
                    }
                }
            end
        },
    }

    active = true
    beginStage(1)
end

--------------------------------------------------
-- UPDATE (a appeler a chaque frame depuis love.update)
--------------------------------------------------

function LoadSequence.update()

    if not active then
        return
    end

    -- Laisse le texte de l'etape etre dessine avant de charger.
    if waitFrames > 0 then
        waitFrames = waitFrames - 1
        return
    end

    local stage = stages[stageIndex]

    local count = 0

    while count < ITEMS_PER_FRAME and itemIndex <= #stage.items do
        stage.items[itemIndex].run()
        itemIndex = itemIndex + 1
        count = count + 1
    end

    if itemIndex > #stage.items then

        if stageIndex >= #stages then
            finish()
        else
            beginStage(stageIndex + 1)
        end
    end
end

--------------------------------------------------
-- INFOS
--------------------------------------------------

function LoadSequence.isActive()
    return active
end

-- Texte de l'etape en cours (traduit), ou nil.
function LoadSequence.getText()

    if not active then
        return nil
    end

    local stage = stages[stageIndex]

    return stage and Language.get(stage.textKey) or nil
end

-- Asset sur le point d'etre charge (ou en cours) : "chemin (12/68)", ou nil.
function LoadSequence.getAssetText()

    if not active then
        return nil
    end

    local stage = stages[stageIndex]
    local items = stage and stage.items

    if not items or #items == 0 then
        return nil
    end

    local i = math.min(itemIndex, #items)

    return string.format("%s (%d/%d)", items[i].label, i, #items)
end

function LoadSequence.cancel()
    active = false
    callbacks = nil
    levelData = nil
end

return LoadSequence
