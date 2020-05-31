ENT.Type = "anim"
ENT.Base = "base_anim"

function ENT:Initialize()

    self.size = self.size or 1
    self.type = self.type or 0
    if self.On == nil then self.On = true end

end

function ENT:Think()
    -- Dont need this for now
end

function ENT:KeyValue(key, value)
	key = string.lower(key)
	if key == "size" then
		self.size = value
    elseif key == "type" then
        self.type = value
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
