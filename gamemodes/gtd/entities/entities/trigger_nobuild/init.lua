ENT.Base = "base_brush"
ENT.Type = "brush"

function ENT:Initialize()
	self:SetTrigger(true)

	if self.On == nil then self.On = true end
end

function ENT:StartTouch( entity )
	if not entity:IsPlayer() then return end
	entity:SetCanBuild(false)
end

function ENT:EndTouch( entity )
	if not entity:IsPlayer() then return end
	entity:SetCanBuild(true)
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

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "enabled" then
		self.On = tonumber(value) == 1
	end
end
