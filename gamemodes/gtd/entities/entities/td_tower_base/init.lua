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

    self.c_nMaxTraceLength = math.sqrt(3) * 2 * 16384 -- Adjust this value for the max length of the beam
    self.c_vOffset = Vector(0, 0, 60)
    self.c_tDefaultTrace = {start = nil, endpos = nil, mask = MASK_OPAQUE_AND_NPCS, filter = nil} -- constants
    self.c_tDefaultTrace.output = self.c_tDefaultTrace -- Reuse the same table for the result for efficiency

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

function ENT:ShootAtEnemy()
    if !IsValid(self.objEnemy) or !self.hasEnemy then
        self:FindTowerEnemy()
    end

end

function ENT:Think()

	if self.hasEnemy then
        if IsValid(self.objEnemy) then

    		self:PointAtEntity( self.objEnemy )
            self:SetAngles(Angle(0,self:GetAngles()[2],0) )


            local vPos = self:GetPos()
            vPos:Add(self.c_vOffset)
            self.c_tDefaultTrace.start = vPos

            local vForward = self:GetForward()
            vForward:Mul(self.c_nMaxTraceLength)
            vForward:Add(vPos)
            self.c_tDefaultTrace.endpos = vForward

            self.c_tDefaultTrace.filter = self

            local tTrace = util.TraceLine(self.c_tDefaultTrace)

        else
            Entity(1):ChatPrint(" enemy obj not valid ")
        end

	end
end