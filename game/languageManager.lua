local Language = {}

local currentLanguage = "en"
local translations = {}

------------------------------------------------
-- CHARGER UNE LANGUE
------------------------------------------------

function Language.load(language)

    translations = require("Lang." .. language)

    currentLanguage = language

end

------------------------------------------------
-- OBTENIR UN TEXTE
------------------------------------------------

function Language.get(key)

    if translations[key] ~= nil then
        return translations[key]
    end

    return "[" .. key .. "]"

end

------------------------------------------------
-- LANGUE ACTUELLE
------------------------------------------------

function Language.current()

    return currentLanguage

end

------------------------------------------------
-- LANGUE PAR DEFAUT
------------------------------------------------

Language.load("en")

return Language