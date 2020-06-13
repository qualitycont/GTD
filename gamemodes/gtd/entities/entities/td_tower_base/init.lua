AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/Combine_turrets/Floor_turret.mdl")
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_NONE )
    self:SetSolid( SOLID_NONE ) -- SOLID_VPHYSICS

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

    self.isBluePrint = nil
    self.Owner = nil

    self.hasEnemy = nil
    self.objEnemy = nil

    self:FindTowerEnemy()

end

function ENT:Use(activator, caller)
    return
end


function ENT:FindTowerEnemy()
	for k, v in pairs(ents.FindInSphere( self:GetPos(), self:GetTowerRange() or 1 ) ) do
		if v == self then continue end;
        if v:IsPlayer() then continue end;
        
			self.hasEnemy = true
			self.objEnemy = v

            self:SethasEnemy( self.hasEnemy )
            self:SetobjEnemy( self.objEnemy )

            Entity(1):ChatPrint( tostring(self.hasEnemy) )
            Entity(1):ChatPrint( tostring(self.objEnemy) )
		--end
	end
end

function ENT:Think()

	if self.hasEnemy then
        if IsValid(self.objEnemy) then
    		self:PointAtEntity( self.objEnemy )
            self:SetAngles(Angle(0,self:GetAngles()[2],0) )

        --    local tr = util.TraceLine( {
        --        start = self:GetPos() - Vector(0,0,-60),
       --         endpos = self:GetPos() + self:GetForward() * 500,
        --        filter = function( ent ) if ( ent:GetClass() == "prop_physics" ) then return true end end
        --    } )

        --   Entity(1):ChatPrint( tostring(tr.HitPos) )
        --   Entity(1):ChatPrint( tostring(tr.Entity) )
          else
            Entity(1):ChatPrint(" enemy obj not valid ")
        end

	end
end