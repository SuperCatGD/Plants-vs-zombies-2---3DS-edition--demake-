local Resources = {}

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

    local image = love.graphics.newImage(path)

    images[path] = image

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

    if sfx[path] then
        return sfx[path]
    end

    local sound = love.audio.newSource(path, "static")

    sound:setVolume(sfx_volume)

    sfx[path] = sound

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

    local source = love.audio.newSource(path, "stream")

    source:setVolume(music_volume)

    music[path] = source

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

    for i,v in ipairs(sfx) do

        v:setVolume(vol)

    end

end

function ChangeMusicVolume(vol)

    for i,v in ipairs(music) do

        v:setVolume(vol)

    end

end
return Resources