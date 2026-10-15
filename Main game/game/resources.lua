local Resources = {}

------------------------------------------------
-- DEBUG (Data Abort) -- mets tout à false une fois le bug trouvé
------------------------------------------------
--
-- TRACE : affiche (print) une ligne AVANT et APRÈS chaque chargement.
--         Après un Data Abort, la dernière ligne "LOAD" sans "ok" juste après
--         est l'asset qui fait planter. Chaque ligne indique aussi une estimation
--         de la mémoire LINEAIRE utilisée (textures + sons décodés, limite
--         ~32 Mo sur 3DS, new ou old) et la mémoire Lua.
-- TRACE_FILE : écrit aussi la trace dans <dossier de sauvegarde>/res_trace.txt
--         (utile sur vraie console sans 3dslink). Désactive si ça gêne.
-- NO_SFX / NO_MUSIC : remplace les sons/musiques par des objets muets, pour
--         savoir si le crash vient de l'audio.
local TRACE      = true
local TRACE_FILE = true
local NO_MUSIC   = false   -- mets true pour tester sans aucune musique
local NO_SFX     = false
-- GC_EVERY : force un collectgarbage() avant 1 chargement sur N (0 = désactivé).
-- Teste si le crash vient de la mémoire du tas normal (24 Mo) remplie par des
-- objets temporaires que Lua n'a pas encore libérés.
local GC_EVERY   = 1   -- mets true pour tester sans aucun effet sonore

local traceCount  = 0
local linearBytes = 0

local function pow2(n)
    local p = 1
    while p < n do p = p * 2 end
    return p
end

local function trace(line)
    if not TRACE then return end
    print(line)
    if TRACE_FILE and love.filesystem and love.filesystem.append then
        pcall(love.filesystem.append, "res_trace.txt", line .. "\n")
    end
end

local function traceLoad(kind, path)
    traceCount = traceCount + 1
    if GC_EVERY > 0 and traceCount % GC_EVERY == 0 then
        collectgarbage("collect")
    end
    trace(string.format("[RES %03d] LOAD %-5s %s", traceCount, kind, path))
    return traceCount
end

local function traceDone(id, extra)
    trace(string.format("[RES %03d] ok    linear~%.1f MB  lua=%d KB  %s",
        id, linearBytes / 1048576, math.floor(collectgarbage("count")), extra or ""))
end

if TRACE then
    trace("[RES] ---- trace start ----")
end

-- Objet muet utilisé quand NO_SFX / NO_MUSIC sont actifs.
local function silentSource()
    local noop = function() end
    return {
        play = noop, stop = noop, pause = noop, release = noop,
        setVolume = noop, setLooping = noop, seek = noop,
        isPlaying = function() return false end
    }
end

------------------------------------------------
-- CACHES
------------------------------------------------

local images = {}
local sfx = {}
local music = {}

------------------------------------------------
-- IMAGES
------------------------------------------------

function Resources.image(path)

    if images[path] then
        return images[path]
    end

    local id = traceLoad("image", path)

    local image = love.graphics.newImage(path)

    local w, h = image:getWidth(), image:getHeight()
    -- texture 3DS : RGBA8, dimensions arrondies à la puissance de 2 supérieure
    linearBytes = linearBytes + pow2(w) * pow2(h) * 4

    images[path] = image

    traceDone(id, w .. "x" .. h)

    return image
end

function Resources.releaseImage(path)

    local image = images[path]

    if not image then
        return
    end

    if image.release then
        image:release()
    end

    images[path] = nil
end

function Resources.clearImages()

    for path, image in pairs(images) do

        if image and image.release then
            image:release()
        end

        images[path] = nil
    end
end

------------------------------------------------
-- SFX
------------------------------------------------


function Resources.sfx(path)

    if NO_SFX then
        return silentSource()
    end

    if sfx[path] then
        return sfx[path]
    end

    local id = traceLoad("sfx", path)

    local sound = love.audio.newSource(path, "static")

    -- son décodé en PCM16 dans la mémoire linéaire
    local ok, bytes = pcall(function()
        return sound:getDuration("samples") * sound:getChannelCount() * 2
    end)
    if ok and type(bytes) == "number" then
        linearBytes = linearBytes + bytes
    end

    sound:setVolume(sfx_volume)

    sfx[path] = sound

    traceDone(id)

    return sound
end

function Resources.releaseSFX(path)

    local sound = sfx[path]

    if not sound then
        return
    end

    sound:stop()

    if sound.release then
        sound:release()
    end

    sfx[path] = nil
end

function Resources.clearSFX()

    for path, sound in pairs(sfx) do

        if sound then
            sound:stop()

            if sound.release then
                sound:release()
            end
        end

        sfx[path] = nil
    end
end

------------------------------------------------
-- MUSIQUES
------------------------------------------------

function Resources.music(path)

    if music[path] then
        return music[path]
    end

    if NO_MUSIC then
        trace("[RES] NO_MUSIC : musique ignorée " .. path)
        return silentSource()
    end

    local id = traceLoad("music", path)

    local source = love.audio.newSource(path, "stream")

    source:setVolume(music_volume)

    music[path] = source

    traceDone(id)

    return source
end

function Resources.releaseMusic(path)

    local source = music[path]

    if not source then
        return
    end

    source:stop()

    if source.release then
        source:release()
    end

    music[path] = nil
end

function Resources.clearMusic()

    for path, source in pairs(music) do

        if source then
            source:stop()

            if source.release then
                source:release()
            end
        end

        music[path] = nil
    end
end

------------------------------------------------
-- TOUT LIBERER
------------------------------------------------

function Resources.clear()

    trace("[RES] clear() : libération du cache")
    linearBytes = 0

    Resources.clearImages()
    Resources.clearSFX()
    Resources.clearMusic()

    collectgarbage("collect")
end

------------------------------------------------
-- INFORMATIONS
------------------------------------------------

function Resources.imageCount()

    local count = 0

    for _ in pairs(images) do
        count = count + 1
    end

    return count
end

function Resources.sfxCount()

    local count = 0

    for _ in pairs(sfx) do
        count = count + 1
    end

    return count
end

function Resources.musicCount()

    local count = 0

    for _ in pairs(music) do
        count = count + 1
    end

    return count
end
function ChangeSFXVolume(vol)

    for _,v in pairs(sfx) do

        v:setVolume(vol)

    end

end

function ChangeMusicVolume(vol)

    for _,v in pairs(music) do

        v:setVolume(vol)

    end

end
return Resources