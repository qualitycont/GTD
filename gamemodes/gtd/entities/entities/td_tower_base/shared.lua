ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Base Turret"

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "Owner")
    self:NetworkVar("Int", 0, "Level")
    self:NetworkVar("Bool", 0, "isBluePrint")

    if SERVER then
        self:SetLevel(1)
        self:SetisBluePrint(true)
    end
end