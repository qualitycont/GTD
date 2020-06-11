include("shared.lua")

ENT.m_fMaxYawSpeed = 200

function ENT:Initialize()
	self:TypeSpecific()

	self.range = 200
	self.target = nil 
end

function ENT:TypeSpecific()
	self:SetModel("models/police.mdl")
	self:SetHealth(100)
	self:DropToFloor()
	self.range = 200
	self:SpawnFollowers()
	self.RUN = ACT_RUN
	self.IDLE = ACT_COWER
end

function ENT:SpawnFollowers()
end

function ENT:UpdateFollowers()
end

function ENT:FindTarget()
end


function ENT:OnInjured(info)
	local a = info:GetAttacker()
	local d = info:GetDamage()
	self:SetHealth(self:Health()-d)
end
