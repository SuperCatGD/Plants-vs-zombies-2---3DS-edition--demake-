--------------------------------------------------
-- GESTIONNAIRE DE SCENES
--------------------------------------------------

local Scene = {}

local currentScene = nil
local currentName = nil

--------------------------------------------------
-- MODULES UTILISES PAR LE GAMEPLAY
--------------------------------------------------

local gameplayModules = {
    "gameplay",
    "lawnmower",
    "plant",
    "zombie",
    "zombieparts",
    "projectiles",
    "splash",
    "suns",
    "presentationzombies",
    "levelsystem"
}

--------------------------------------------------
-- CHARGER UNE SCENE
--------------------------------------------------

function Scene.load(name)

    -- Si une scène est déjà chargée,
    -- on la décharge avant.
    Scene.unload()

    print("================================")
    print("CHARGEMENT : " .. name)
    print("================================")

    currentScene = require(name)
    currentName = name

    return currentScene
end

--------------------------------------------------
-- DECHARGER LE GAMEPLAY
--------------------------------------------------

function Scene.unload()

    print("================================")
    print("DECHARGEMENT : " .. tostring(currentName))
    print("================================")

    --------------------------------------------------
    -- Demande à la scène de s'arrêter proprement
    --------------------------------------------------

    if currentScene and currentScene.unload then
        currentScene.unload()
    end
    Resources.clear()

    --------------------------------------------------
    -- Supprime la référence vers la scène
    --------------------------------------------------

    currentScene = nil
    currentName = nil

    --------------------------------------------------
    -- Supprime les instances du gameplay
    --------------------------------------------------

    plantInstances = nil
    zombiesInstances = nil
    corpsesInstances = nil

    projectilesInstances = nil
    splashesInstances = nil
    sunsInstances = nil
    zombiesInstancesPres = nil

    --------------------------------------------------
    -- Supprime les références globales du gameplay
    --------------------------------------------------

    level = nil
    plants = nil

    --------------------------------------------------
    -- Retire les modules du cache Lua
    --------------------------------------------------

    for i = 1, #gameplayModules do
        package.loaded[gameplayModules[i]] = nil
    end

    -- Les données de niveaux contiennent des références vers des
    -- Image/Quad créés avec Resources.image(). Elles doivent être
    -- rechargées après Resources.clear(), sinon elles gardent des
    -- objets LÖVE déjà libérés (ex: Levels.demo1.seeds[].sprite).
    for moduleName in pairs(package.loaded) do
        if type(moduleName) == "string" and moduleName:match("^Levels%.") then
            package.loaded[moduleName] = nil
        end
    end

    --------------------------------------------------
    -- Garbage Collector
    --------------------------------------------------

    collectgarbage("collect")

    print("GAMEPLAY DECHARGE")

end

--------------------------------------------------
-- UPDATE
--------------------------------------------------

function Scene.update(dt)

    if currentScene and currentScene.update then
        currentScene.update(dt)
    end
end

--------------------------------------------------
-- DRAW
--------------------------------------------------

function Scene.draw(screen)

    if currentScene and currentScene.draw then
        currentScene.draw(screen)
    end
end

--------------------------------------------------
-- RECUPERER LA SCENE
--------------------------------------------------

function Scene.get()

    return currentScene
end

--------------------------------------------------
-- VERIFIER SI UNE SCENE EST CHARGEE
--------------------------------------------------

function Scene.isLoaded()

    return currentScene ~= nil
end

function Scene.shouldReturnToMenu()

    if currentScene and currentScene.shouldReturnToMenu then
        return currentScene.shouldReturnToMenu()
    end

    return false

end

return Scene