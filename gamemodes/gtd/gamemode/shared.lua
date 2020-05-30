GM.Version = "0.0.1"
GM.Release = false
GM.Credits = {
    qualitycont = "Who knows /shrug",
    Vortexan = "Who knows /shrug",
    Cee = "Who knows /shrug"
}

local function _includeCL(path)
    if SERVER then
        AddCSLuaFile(path)
    else
        include(path)
    end
end

local function _includeSH(path)
    if SERVER then
        AddCSLuaFile(path)
    end
    include(path)
end

local function _includeSV(path)
    if SERVER then
        include(path)
    end
end

_includeSH("core/util.lua")
_includeSH("player_class/player_td.lua")
_includeSV("core/round_manager.lua")