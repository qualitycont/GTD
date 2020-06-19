include("shared.lua")

local modes = {
	IDLE = 1,
	CORE = 2,
	PLAYER = 3,
	TOWER = 4
}

ENT.m_fMaxYawSpeed = 200
ENT.MasterModel = "models/gman_high.mdl"
ENT.FollowerModel = "models/Eli.mdl"

-- list.Set( "NPC", "combine1", {
-- 	Name = "combine",
-- 	Class = "combine1",
-- 	Category = "NextBot"
-- })

function ENT:Initialize()
	self.FollowerModel = self.FollowerModel or self.MasterModel
	self.followers = {}
	self.difficulty = 2
	self:TypeSpecific()

	self.target = nil 
	self:FindTarget()
end

function ENT:RunAnim(enum)
	if self:GetActivity() == enum then return end
	self:StartActivity(enum)
end

function ENT:RemoveDeadFollowers()
	if self.type ~= "master" then return end 
	if table.Count(self.followers) == 0 then return end 
	for k,v in pairs(self.followers) do 
		if not IsValid(v) then 
			table.remove(self.followers,k)
		end
	end
end 

function ENT:SpawnFollowers()
	if self.type ~= "master" then return end 
	local n = 50
	for i=1,self.difficulty do
		local follower = ents.Create(self:GetClass())
		follower:SetPos(self:GetPos()+Vector(n,n,0))
		follower.type = "follower"
		follower:Spawn()
		follower:SetAngles(self:GetAngles())
		follower.master = self
		n = n + 50
		table.insert(self.followers,follower)
	end
end

-- tell the followers what to do 
function ENT:UpdateFollowers(updateMaster)
	if self.type ~= "master" then return end 
	self:RemoveDeadFollowers()
	for k,v in pairs(self.followers) do
		v.mode = self.mode 
		v.target = self.target
		if updateMaster then 
			v.master = self 
		end
	end
end

function ENT:TypeSpecific()
	if self.type ~= "master" then 
		self:SetModel(self.FollowerModel)
	else 
		self:SetModel(self.MasterModel)
	end

	self:SetHealth(100)
	self:DropToFloor()
	self.range = 250
	self:SpawnFollowers()
	self.RUN = ACT_RUN
	self.IDLE = ACT_COWER
end

-- no core
function ENT:Idle()
	self:RunAnim(self.IDLE)
end

-- moving to core
function ENT:Core() 
	if self.target == nil then return end
	self:RunAnim(self.RUN)
	self:MoveToPosition(self.target:GetPos())
end

-- targeting player
function ENT:Ply()
	self:RunAnim(self.RUN)
	self:MoveToPosition(self.target:GetPos())
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
	if self.type == "follower" then return end 
	-- if there's no target, go for the core 
	if self.target == nil then self:SetTargetCore() return false end

	-- allows the ai to keep looking for players, remove if dealing with core focused ai.
	if self.mode == "core" then return false end 

	-- checks if target is alive, in range and in LOS. 
	if not self.target:Alive() then self:FindTarget() return false end
	if not self.target:IsLineOfSightClear(self:GetPos()) or self:GetRangeTo(self.target:GetPos()) > self.range then self:FindTarget() return false end 
	return true
end

-- gets a random core for a target 
function ENT:SetTargetCore()
	if self.type == "follower" then return end 
	local c = ents.FindByClass("info_td_core")
	if table.Count(c) == 0 then self.mode = "idle" self:UpdateFollowers() return end
	local n = math.random(1,table.Count(c))
	self.target = c[n]
	self.mode = "core"
	self:UpdateFollowers()
end

-- find the nearest player, if there's no players, target the core 
function ENT:FindTarget()
	if self.type == "follower" then return end 
	local nearbyents = ents.FindInSphere(self:GetPos(), self.range)
	if nearbyents == nil then self:SetTargetCore() return end 
	for k,v in pairs(nearbyents) do 
		if v:IsPlayer() && v:Alive() && self:IsLineOfSightClear(v:GetPos()) then 
			self.target = v
			self.mode = "player"
			self:UpdateFollowers()
			return
		end
	end
	self:SetTargetCore()
end

function ENT:OnInjured(info)
	local a = info:GetAttacker()
	local d = info:GetDamage()

	self:SetHealth(self:Health()-d)

	if self.type == "follower" then return end 
	if self:Health() > 0 && a:IsPlayer() then 
		self:FindTarget(a)
	else 
		if self.type ~= "master" then return end 
		-- sets a new master 
		self:RemoveDeadFollowers()
		if table.Count(self.followers) == 0 then return end 
		local n = math.random(1,table.Count(self.followers))
		self.followers[n]:SetModel(self.MasterModel) -----------------------------------> temporary
		self.followers[n].type = "master" 
		self.followers[n].followers = self.followers
		self.followers[n]:UpdateFollowers(true)
	end
end

-- edited from nextbot base function
function ENT:MoveToPosition(options)

    local options = options or {}

    local path = Path( "Follow" )

    path:SetMinLookAheadDistance(options.lookahead or 325)
 
    path:SetGoalTolerance(options.tolerance or 20)

    path:Compute(self, self.target:GetPos())     
 
    if ( !path:IsValid() ) then return "failed" end
 
    while path:IsValid() and self.target ~= nil do
        if self.mode ~= "core" && path:GetAge() > 0.1 then              
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
