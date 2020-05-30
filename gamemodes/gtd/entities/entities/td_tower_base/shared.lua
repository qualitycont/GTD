ENT.Type = "anim"
ENT.Base = "base_gmodentity"

ENT.PrintName = "Base Turret"

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "Owner")
    self:NetworkVar("Int", 0, "Level")

    if SERVER then
        self:SetLevel(1)
    end
end