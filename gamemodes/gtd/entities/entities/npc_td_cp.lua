AddCSLuaFile()

ENT.Base = "npc_td_base"
ENT.MasterModel = "models/Police.mdl"

function ENT:TypeSpecific()
	self:SetModel(self.MasterModel)
	self:SetHealth(100)
	self:DropToFloor()
	self.range = 400
    self:SpawnFollowers()
	self.RUN = ACT_RUN
	self.IDLE = ACT_COWER
end