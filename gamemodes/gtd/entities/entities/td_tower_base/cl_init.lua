include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	if !IsValid(self:GetobjEnemy()) or !self:GethasEnemy() then return end

	local startAim = self:GetPos() - Vector(0,0,-60)
	local endAim = self:GetPos()+self:GetForward()

	local Dist = self:GetPos():Distance( self:GetobjEnemy():GetPos() )
	render.DrawLine( self:GetPos() - Vector(0,0,-60), self:GetPos()+self:GetForward() * 1000, Color( 255,0,0 ), true )
end
