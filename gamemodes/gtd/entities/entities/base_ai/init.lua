include("shared.lua")

ENT.m_fMaxYawSpeed = 200

function ENT:RunAnim(enum)
	if self:GetActivity() == enum then return end
	self:StartActivity(enum)
	--print(self.mode)
end

function ENT:Initialize()
	self:TypeSpecific()

	self.range = 100
	self.target = nil 
	self:FindTarget()
	--PrintTable(self:GetSequenceList())
end

function ENT:TypeSpecific()
	self:SetModel("models/police.mdl")
	self:SetHealth(100)
	self:DropToFloor()
end

-- no core
function ENT:Idle()
	self:RunAnim(ACT_COWER)
end

-- moving to core
function ENT:Core() 
	if self.target == nil then return end
	self:RunAnim(ACT_RUN)
	self:MoveToPos(self.target:GetPos())
end

-- targeting player
function ENT:Ply()
	self:RunAnim(ACT_RUN)
	self:MoveToPlayer(self.target:GetPos())
end

-- attacking tower
function ENT:Tower() 

end

function ENT:RunBehaviour()
	self.loco:SetDesiredSpeed(200)
	while true do 
		if self.mode == "idle" then 
			self:Idle()
		elseif self.mode == "core" then 
			self:Core()
		elseif self.mode == "player" then 
			self:Ply()
		elseif self.mode == "tower" then 
			self:Tower()
		end

		coroutine.yield()
	end
end

function ENT:TargetValidate()
	if self.target == nil or self.mode == "core" then self:SetTargetCore() return false end
	if not self.target:Alive() then self:FindTarget() return false end
	if not self.target:IsLineOfSightClear(self:GetPos()) or self:GetRangeTo(self.target:GetPos()) > self.range then self:FindTarget() return false end 
	return true
end

function ENT:SetTargetCore()
	local c = ents.FindByClass("info_td_core")
	if table.IsEmpty(c) then self.mode = "idle" end

	local n = math.random(1,table.Count(c))
	self.target = c[n]
	self.mode = "core"
end

function ENT:FindTarget()
	local nearbyents = ents.FindInSphere(self:GetPos(), self.range)
	if nearbyents == nil then self:SetTargetCore() return end 
	for k,v in pairs(nearbyents) do 
		if v:IsPlayer() && v:Alive() && self:IsLineOfSightClear(v:GetPos()) then 
			self.target = v
			self.mode = "player"
			return
		end
	end
	self:SetTargetCore()
end

function ENT:OnInjured(info)
	local a = info:GetAttacker()
	local d = info:GetDamage()

	self:SetHealth(self:Health()-d)
	if self:Health() > 0 && a:IsPlayer() then 
		self:FindTarget(a)
	end
end

function ENT:MoveToPlayer(options)

    local options = options or {}

    local path = Path( "Follow" )

    path:SetMinLookAheadDistance(options.lookahead or 325)

    path:SetGoalTolerance(options.tolerance or 20)

    path:Compute(self, self.target:GetPos())     
 
    if ( !path:IsValid() ) then return "failed" end
 
    while path:IsValid() and self.target ~= nil do
        if path:GetAge() > 0.1 then              
            path:Compute(self, self.target:GetPos())
        end

        path:Update( self )                             

        if (options.draw) then path:Draw() end

        if not self:TargetValidate() then
        	self:FindTarget()
        	return "failed"
        end 
        if self.loco:IsStuck() then
            self:HandleStuck()
            return "stuck"
        end
        coroutine.yield()
    end
    return "ok"
end
