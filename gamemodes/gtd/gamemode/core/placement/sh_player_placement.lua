-- Taser models/weapons/w_eq_taser.mdl
-- heavy models/weapons/w_mach_m249para.mdl
-- pistol models/weapons/w_pist_p250.mdl

PlacementSystem = PlacementSystem or {}
PlacementSystem.Objects = PlacementSystem.Objects or GM.TowerManager.GetAll() or {
	[1] = {
		Name = "Pistol Tower",
		Model = "models/weapons/w_pist_p250.mdl",
		Damage = 12,
		FireRate = 1.2,
		Health = 100,
		Price = 50
	},
	[2] = {
		Name = "Taser Tower",
		Model = "models/weapons/w_eq_taser.mdl",
		Damage = 3,
		FireRate = 1.5,
		Health = 100,
		Price = 120
	},
	[3] = {
		Name = "Shotgun Tower",
        Model = "models/weapons/w_shot_xm1014.mdl",
        Price = 350,
        Damage = 36,
        FireRate = 1.5,
        Health = 200
	},
	[4] = {
		Name = "Heavy Tower",
		Model = "models/weapons/w_mach_m249para.mdl",
		Damage = 15,
		FireRate = 0.6,
		Health = 200,
		Price = 500
	},
    [5] = {
        Name = "Sniper Tower",
        Model = "models/weapons/w_snip_scout.mdl",
        Price = 750,
        Damage = 80,
        FireRate = 2.4,
        Health = 200
    }
}
