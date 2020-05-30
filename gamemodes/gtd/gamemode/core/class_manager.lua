GM.ClassManager = GM.ClassManager or {}
local manager = GM.ClassManager -- saves my fingers
local classes = {
    ["none"] = {
        DisplayName = "No Class",
        Description = [[You have no class selected!]],
        Weapons = {},
        Model = "models/player/Group03/male_07.mdl"
    }
}

function manager:Register(info)
    if not info.Name or classes[info.Name] then return false end
    info.Name = string.lower(info.Name)
    info.DisplayName = info.DisplayName or info.Name
    info.Description = info.Description or [[No Description Set!]]
    info.Weapons = info.Weapons or {}
    info.Model = info.Model or "models/player/kleiner.mdl"
    info.Loadout = function(ply) end
    info.Spawn = function(ply) end

    classes[info.Name] = {
        DisplayName = info.DisplayName,
        Description = info.Description,
        Weapons = info.Weapons,
        Model = info.Model,
        Loadout = info.Loadout,
        Spawn = info.Spawn,
    }
end

function manager:GetAll()
    return classes
end
