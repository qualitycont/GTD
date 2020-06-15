-- Taser models/weapons/w_eq_taser.mdl
-- heavy models/weapons/w_mach_m249para.mdl
-- pistol models/weapons/w_pist_p250.mdl

util.AddNetworkString("GTD:PlacementSystem:PlaceTower")
util.AddNetworkString("GTD:PlacementSystem:updPlaceTower")

-- caching clientside models
util.PrecacheModel( "models/Combine_turrets/Floor_turret.mdl" )

PlacementSystem = PlacementSystem or {}
PlacementSystem.Objects = PlacementSystem.Objects or {}


function PlacementSystem.placeTower( player, holdingBP, towerIndex, towerPos, towerAngle )
	--if !PlacementSystem.Objects[ towerIndex ] then return end
	--local CurrentTower = PlacementSystem.Objects[ towerIndex ];

	player:SetholdingBP( holdingBP )

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
	local holdingBP = net.ReadBool()
	local towerIndex = net.ReadInt(32)
	local towerPos = net.ReadVector()
	local towerAngle = net.ReadAngle()

	PlacementSystem.placeTower( playerPlacing, holdingBP, towerIndex, towerPos, towerAngle )
end)

net.Receive("GTD:PlacementSystem:updPlaceTower", function(length,player)
	local _placingBP = net.ReadBool()
	player:SetholdingBP( _placingBP )
end)
