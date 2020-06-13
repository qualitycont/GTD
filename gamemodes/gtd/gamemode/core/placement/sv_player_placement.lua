-- Taser models/weapons/w_eq_taser.mdl
-- heavy models/weapons/w_mach_m249para.mdl
-- pistol models/weapons/w_pist_p250.mdl

util.AddNetworkString("GTD:PlacementSystem:Init")
util.AddNetworkString("GTD:PlacementSystem:StartPrePlace")
util.AddNetworkString("GTD:PlacementSystem:CancelPrePlace")

-- caching clientside models
util.PrecacheModel( "models/Combine_turrets/Floor_turret.mdl" )

PlacementSystem = PlacementSystem or {}
PlacementSystem.Objects = PlacementSystem.Objects or {}

--[[

	* Tower Blueprints MOVED clientside!

function PlacementSystem.PlaceBlueprint( plyPlacing, towerIndex )

	print("BP MODE: -> ", plyPlacing:Nick(), towerIndex)
	plyPlacing:ChatPrint(" Starting to place tower...")

	-- Player is now holding a blueprint
	plyPlacing:SetholdingBP( true )

	local idToTower = PlacementSystem.Objects[ towerIndex ]
	local bp = ents.Create("td_tower_base")
	bp:SetPos(plyPlacing:GetEyeTrace().HitPos)
	bp:SetAngles(plyPlacing:GetAngles())
	bp:SetModel("models/Combine_turrets/Floor_turret.mdl")
	  bp:SetOwner( plyPlacing )
	  bp:SetisBluePrint( true )
	bp:Spawn()
	bp.Think = function(_s)
		print(_s:GetOwner())
		if !_s:GetOwner() then return end
		if !_s:GetisBluePrint() then return end

		_s:SetPos( _s:GetOwner():GetEyeTrace().HitPos )
	end


end
--]]



