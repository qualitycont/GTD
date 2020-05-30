ENT.Base = "base_brush"
ENT.Type = "brush"


function ENT:StartTouch( entity )
	if not IsPlayer(entity) then return end
	entity:SetCanBuild(false)
end

function ENT:EndTouch( entity )
	if not IsPlayer(entity) then return end
	entity:SetCanBuild(true)
end

