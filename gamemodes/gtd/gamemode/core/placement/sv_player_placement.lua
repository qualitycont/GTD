-- Taser models/weapons/w_eq_taser.mdl
-- heavy models/weapons/w_mach_m249para.mdl
-- pistol models/weapons/w_pist_p250.mdl

util.AddNetworkString("GTD:PlacementSystem:PlaceTower")


-- caching clientside models
util.PrecacheModel( "models/Combine_turrets/Floor_turret.mdl" )

PlacementSystem = PlacementSystem or {}
PlacementSystem.Objects = PlacementSystem.Objects or {}


function PlacementSystem.placeTower( player, towerIndex, towerPos, towerAngle )
	--if !PlacementSystem.Objects[ towerIndex ] then return end
	--local CurrentTower = PlacementSystem.Objects[ towerIndex ];

	local Tower = ents.Create("td_tower_base")
	Tower:SetModel( "models/Combine_turrets/Floor_turret.mdl" ) 
	Tower:SetTowerRange( 100 )
	Tower:SetPos( towerPos )
	Tower:SetAngles( towerAngle )
	Tower:Spawn()

	--net.Start("GTD:PlacementSystem:PlaceTower")
	-- net.WriteInt(Tower)

end


net.Receive("GTD:PlacementSystem:PlaceTower", function(length, player)
	local playerPlacing = player
	local towerIndex = net.ReadInt(32)
	local towerPos = net.ReadVector()
	local towerAngle = net.ReadAngle()

	PlacementSystem.placeTower( playerPlacing, towerIndex, towerPos, towerAngle )
end)