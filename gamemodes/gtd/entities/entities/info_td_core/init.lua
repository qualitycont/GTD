AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()

    self:SetModel("models/props_combine/combinethumper002.mdl")
    self:PhysicsInit( SOLID_VPHYSICS )
    self:SetMoveType( MOVETYPE_NONE )
    self:SetSolid( SOLID_VPHYSICS )
    self:SetUseType( SIMPLE_USE )

    local phys = self:GetPhysicsObject()
    if phys:IsValid() then
        phys:Wake()
    end

    self.starthealth = self.starthealth or 500
    self.regen = self.regen or 50
    if self.On == nil then self.On = true end

    self:SetMaxHealth(self.starthealth)
    self:SetHealth(self.starthealth)
end

function ENT:Use(activator, caller)
    if not self.On then return end
    activator:ChatPrint("Current Health: "..self:Health())
    return
end

function ENT:Think()
    -- Dont need this for now
end

function ENT:OnTakeDamage( dmginfo )
	-- Make sure we're not already applying damage a second time
    if not self.On then return end
	if ( not self.m_bApplyingDamage ) then
		self.m_bApplyingDamage = true
		self:AddHealth( dmginfo:GetDamage() * -1)
		self.m_bApplyingDamage = false

        if self:Health() <= 0 then
            dmginfo:GetAttacker():ChatPrint("You destroyed the core!")
            self:Fire("OnDestroyed")
            GAMEMODE.RoundManager:EndWave(false)
        end
	end
end

function ENT:AddHealth( amount )
    self:SetHealth(math.Clamp(self:Health() + amount, 0, self:GetMaxHealth()))
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "starthealth" then
		self.starthealth = value
    elseif key == "regen" then
        self.regen = value
	elseif key == "enabled" then
		self.On = tonumber(value) == 1
	end
end

function ENT:AcceptInput(name, caller, activator, arg)
	name = string.lower(name)
	if name == "enable" then
		self.On = true
		return true
	elseif name == "disable" then
		self.On = false
		return true
    end
end
