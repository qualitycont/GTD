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
end

function ENT:Use(activator, caller)
    return
end

function ENT:Think()
   -- if self.Owner != nil and self.isBluePrint == true then
     --   self:SetPos(self.Owner:GetEyeTrace().HitPos)
       --self:SetColor(Color(0,0,0,100))
    --end
end