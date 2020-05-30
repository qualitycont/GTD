local manager = GM.ClassManager -- yet again to save my fingers

manager:Register{
    Name = "engineer",
    DisplayName = "Engineer",
    Description = [[Gain access to a powerful extra tower: The Repair Node!]],
    Weapons = {"weapon_smg1","weapon_stunstick"}
}

manager:Register{
    Name = "medic",
    DisplayName = "Medic",
    Description = [[Carry your teammates to victory! (Or just yourself) ]],
    Weapons = {"weapon_pistol","weapon_stunstick","weapon_medkit"}
}

manager:Register{
    Name = "soldier",
    DisplayName = "Soldier",
    Description = [[You like to shoot bad guys]],
    Weapons = {"weapon_ar2","weapon_357"}
}