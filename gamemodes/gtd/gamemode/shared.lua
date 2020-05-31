GM.Version = "0.0.1"
GM.Release = false
GM.Credits = {
    qualitycont = "Made Most core backend stuff, entites and maps-related stuff",
    Vortexan = "Made the Sexy UI",
    Cee = "Made the placement system",
    Willox = "Creator of the CS:S Weapon Base, thanks!"
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

-- core stuff
_includeSH("core/util.lua")
_includeSH("core/csweapons.lua")
_includeSV("core/enemy_manager.lua")
_includeSV("core/round_manager.lua")
_includeSH("core/class_manager.lua")

-- functionality stuff
_includeSH("core/player_ext.lua")
_includeSV("core/player_ext_sv.lua")
_includeSH("core/concommand.lua")
_includeSH("player_class/player_td.lua")
_includeSV("ui/networking_sv.lua")

-- actual content
_includeSH("ext/default_classes.lua")
_includeCL("ui/class_select.lua")
