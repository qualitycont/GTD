ENT.Type = "anim"
ENT.Base = "base_anim"

ENT.PrintName = "Base Turret"

function ENT:SetupDataTables()
    self:NetworkVar("Entity", 0, "Owner")
    self:NetworkVar("Entity", 1, "objEnemy")

    self:NetworkVar("Bool", 0, "isBluePrint")
    self:NetworkVar("Bool", 1, "hasEnemy")

    self:NetworkVar("Int", 0, "Level")
    self:NetworkVar("Int", 1, "TowerRange")
    self:NetworkVar("Int", 2, "TowerFireRate")
    self:NetworkVar("Int", 3, "TowerDamage")

    if SERVER then
        self:SetLevel(1)
        self:SetisBluePrint(true)

        self:SetTowerRange(120)
        self:SetTowerFireRate(0)
     	self:SetTowerDamage(0)
     else
     	self:SetTowerRange(120)
    end
end