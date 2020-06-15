local manager = GM.TowerManager

manager:Register{
    Name = "Pistol Tower",
    Model = "models/weapons/w_pist_fiveseven.mdl",
    Price = 100,
    Damage = 1,
    FireRate = .5,
    Health = 30
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