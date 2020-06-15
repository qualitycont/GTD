local manager = GM.TowerManager

manager:Register{
    Name = "Pistol Tower",
    Model = "models/weapons/w_pist_p250.mdl",
    Price = 50,
    Damage = 12,
    FireRate = 1.2,
    Health = 100
}

manager:Register{
    Name = "Rapid-Fire Pistol Tower",
    Model = "models/weapons/w_pist_fiveseven.mdl",
    Price = 100,
    Damage = 13,
    FireRate = 0.8,
    Health = 100
}

manager:Register{
    Name = "Taser Tower",
    Model = "models/weapons/w_eq_taser.mdl",
    Price = 200,
    Damage = 3,
    FireRate = 1.5,
    Health = 100
}

manager:Register{
    Name = "Shotgun Tower",
    Model = "models/weapons/w_shot_xm1014.mdl",
    Price = 350,
    Damage = 6,
    FireRate = 1.5,
    Health = 130
}

manager:Register{
    Name = "Sniper Tower",
    Model = "models/weapons/w_snip_scout.mdl",
    Price = 750,
    Damage = 13,
    FireRate = 3,
    Health = 90
}

manager:Register{
    Name = "Heavy Tower",
    Model = "models/weapons/w_mach_m249para.mdl",
    Price = 500,
    Damage = 15,
    FireRate = 0.6,
    Health = 200
}