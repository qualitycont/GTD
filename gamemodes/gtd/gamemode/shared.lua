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

-- include config first so we can use its values later
_includeSH("config/config.lua")
_includeSH("config/economy.lua")

-- Backend Functions
_includeSH("core/util.lua")
_includeSH("core/enemy_manager.lua")
_includeSH("core/round_manager.lua")
_includeSH("core/class_manager.lua")
_includeSH("core/perk_manager.lua")
_includeSH("core/tower_manager.lua")

-- Functionality
_includeSH("core/entity_ext.lua")
_includeSH("core/player_ext.lua")
_includeSV("core/player_ext_sv.lua")
_includeSH("core/concommand.lua")
_includeSH("player_class/player_td.lua")
_includeSV("core/economy.lua")

-- content
_includeSH("ext/default_enemies.lua")
_includeSH("ext/default_classes.lua")
_includeSH("ext/default_perks.lua")
_includeSH("ext/default_towers.lua")

-- UI
_includeSV("ui/networking_sv.lua")
_includeCL("ui/class_select.lua")
_includeCL("ui/perk_select.lua")
_includeCL("ui/levelup_notify.lua")

-- placement
_includeSV("core/placement/sv_player_placement.lua")
_includeSH("core/placement/sh_player_placement.lua")
_includeCL("core/placement/cl_player_placement.lua")

--_includeSH("core/placement/placement_blueprint.lua") -- removed

