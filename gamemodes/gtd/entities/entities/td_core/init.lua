AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/props_combine/combinethumper002.mdl")
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_NONE )
    self:SetSolid( SOLID_VPHYSICS )

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

    self:SetMaxHealth(500)
    self:SetHealth(500)
    self:SetUseType( SIMPLE_USE )

end

function ENT:Use(activator, caller)
    activator:ChatPrint("Current Health: "..self:Health())
    return
end

function ENT:Think()
    -- Dont need this for now
end

function ENT:OnTakeDamage( dmginfo )
	-- Make sure we're not already applying damage a second time
	if ( not self.m_bApplyingDamage ) then
        dmginfo:GetAttacker():ChatPrint("You damaged the core!")
		self.m_bApplyingDamage = true
		self:SetHealth(self:Health() - dmginfo:GetDamage())
		self.m_bApplyingDamage = false

        if self:Health() <= 0 then
            self:Remove()
            GAMEMODE.RoundManager:EndWave(false)
        end
	end
end