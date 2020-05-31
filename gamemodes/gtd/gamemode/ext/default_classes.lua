local manager = GM.ClassManager -- yet again to save my fingers

manager:Register{
    Name = "engineer",
    DisplayName = "Engineer",
    Description = [[Gain access to a powerful extra tower: The Repair Node!]],
    Weapons = {"weapon_smg1","weapon_knife"},
    Model = "models/player/odessa.mdl"
}

manager:Register{
    Name = "medic",
    DisplayName = "Medic",
    Description = [[Carry your teammates to victory! (Or just yourself) ]],
    Weapons = {"weapon_pistol","weapon_knife","weapon_medkit"},
    Model = "models/player/Group03m/male_07.mdl"
}

manager:Register{
    Name = "soldier",
    DisplayName = "Soldier",
    Description = [[You like to shoot bad guys]],
    Weapons = {"weapon_ar2","weapon_357"},
    Model = "models/player/Group03/male_07.mdl"
}

manager:Register{
    Name = "sniper",
    DisplayName = "Sniper",
    Description = [[The ultimate camper!]],
    Weapons = {"weapon_smg1"},
    Model = "models/player/arctic.mdl"
}

manager:Register{
    Name = "trapper",
    DisplayName = "Trapper",
    Description = "Traps are gay!",
    Weapons = {"weapon_shotgun", "weapon_pistol", "weapon_slam"},
    Model = "models/player/guerilla.mdl"
}

manager:Register{
    Name = "specialist",
    DisplayName = "Specialist",
    Description = "You could say that you are special...",
    Weapons = {"weapon_rpg", "weapon_smg1"},
    Model = "models/player/gasmask.mdl"
}

manager:Register{
    Name = "scout",
    DisplayName = "Scout",
    Description = "Im running circles around you!",
    Weapons = {"weapon_shotgun", "weapon_357"},
    Model = "models/player/leet.mdl",
    OnSpawn = function(ply)
        ply:SetRunSpeed(310)
    end
}

manager:Register{
    Name = "tank",
    DisplayName = "Tank",
    Description = "Cry some more!",
    Weapons = {"weapon_m249", "weapon_shotgun"},
    Model = "models/player/swat.mdl",
    OnSpawn = function(ply)
        ply:SetMaxHealth(200)
        ply:SetHealth(200)
    end
}